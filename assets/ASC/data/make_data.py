"""
Simulate the fictitious "Juniper Health Plan" data used in the ASC
Healthcare Analytics workshop.

Every value here is synthetic. ZIP codes are real Utah ZIPs used only for
flavor; the census values attached to them are made up.

Run from this folder:  python make_data.py
Writes: members.csv, claims.csv, ehr_encounters.csv, mrn_crosswalk.csv,
        census_zip.csv, vendor_sdoh.csv
"""
from pathlib import Path

import numpy as np
import pandas as pd

rng = np.random.default_rng(2026)
OUT = Path(__file__).parent
N = 3000
YEAR = 2025

# ---------------------------------------------------------------- census (ACS-like)
zips = pd.DataFrame({
    "zip":    ["84321", "84341", "84302", "84401", "84041", "84101",
               "84111", "84119", "84057", "84601", "84770", "84501"],
    "county": ["Cache", "Cache", "Box Elder", "Weber", "Davis", "Salt Lake",
               "Salt Lake", "Salt Lake", "Utah", "Utah", "Washington", "Carbon"],
})
k = len(zips)
zips["svi"] = np.round([0.42, 0.22, 0.55, 0.78, 0.30, 0.71, 0.84, 0.88, 0.35, 0.62, 0.48, 0.81], 2)
zips["median_hh_income"] = np.round(105_000 - 70_000 * zips["svi"] + rng.normal(0, 5_000, k), -2).astype(int)
zips["pct_poverty"] = np.clip(np.round(4 + 22 * zips["svi"] + rng.normal(0, 1.5, k), 1), 2, 40)
zips["pct_uninsured"] = np.clip(np.round(3 + 12 * zips["svi"] + rng.normal(0, 1, k), 1), 1, 25)
zips["pct_age65plus"] = np.round(rng.uniform(8, 22, k), 1)
zips["population"] = rng.integers(9_000, 60_000, k)
zip_weights = zips["population"] / zips["population"].sum()

# ---------------------------------------------------------------- members
m = pd.DataFrame({"member_id": [f"M{100000 + i}" for i in range(N)]})
m["zip"] = rng.choice(zips["zip"], N, p=zip_weights)
m = m.merge(zips[["zip", "svi"]], on="zip")
m["plan_type"] = rng.choice(["Commercial", "Medicare Advantage", "Medicaid"], N, p=[0.62, 0.18, 0.20])
age = np.where(m["plan_type"] == "Medicare Advantage", rng.integers(65, 92, N), rng.integers(1, 65, N))
m["birth_year"] = YEAR - age
m["sex"] = rng.choice(["F", "M"], N, p=[0.52, 0.48])

# enrollment: most full-year, some partial (teaches member-months)
start_m = np.where(rng.random(N) < 0.85, 1, rng.integers(2, 12, N))
end_m = np.where(rng.random(N) < 0.9, 12, np.maximum(start_m, rng.integers(3, 13, N)))
m["enroll_start"] = pd.to_datetime([f"{YEAR}-{s:02d}-01" for s in start_m])
m["enroll_end"] = pd.to_datetime([f"{YEAR}-{e:02d}-01" for e in end_m]) + pd.offsets.MonthEnd(0)
m["member_months"] = end_m - start_m + 1

# latent truth (never shipped directly)
adult = age >= 18
lin = lambda x: 1 / (1 + np.exp(-x))
food_insec = np.clip(rng.normal(20 + 60 * m["svi"], 15), 0, 100)
diabetes = rng.random(N) < lin(-5.2 + 0.055 * age + 1.2 * m["svi"]) * adult
obesity = rng.random(N) < lin(-1.4 + 0.012 * age + 1.0 * m["svi"] + 1.5 * diabetes)
hypert = rng.random(N) < lin(-4.6 + 0.065 * age + 0.8 * obesity)
dep_sev = np.where(adult, rng.choice([0, 1, 2, 3], N, p=[0.80, 0.09, 0.08, 0.03]), 0)  # 0 none .. 3 severe
dep_sev = np.where((food_insec > 60) & (dep_sev == 0) & (rng.random(N) < 0.08), 2, dep_sev)
asthma = rng.random(N) < 0.08
glp1 = (obesity | diabetes) & (rng.random(N) < 0.12)

# ---------------------------------------------------------------- claims
mm = m["member_months"].to_numpy()
lam_ed = (mm / 12) * np.exp(-2.1 + 0.012 * food_insec + 0.45 * diabetes + 0.40 * (dep_sev >= 2)
                            + 0.30 * asthma + 0.35 * (m["plan_type"] == "Medicaid") + 0.01 * np.maximum(age - 60, 0))
lam_off = (mm / 12) * np.exp(0.6 + 0.5 * diabetes + 0.3 * hypert + 0.4 * (dep_sev >= 1) + 0.01 * age)
lam_ip = (mm / 12) * np.exp(-3.3 + 0.03 * np.maximum(age - 50, 0) + 0.6 * diabetes + 0.5 * (dep_sev == 3))
n_ed, n_off, n_ip = rng.poisson(lam_ed), rng.poisson(lam_off), rng.poisson(lam_ip)

def chronic_dx(i):
    pool = []
    if diabetes[i] and rng.random() < 0.80: pool.append("E11.9")    # claims miss ~20% of diabetes
    if hypert[i] and rng.random() < 0.85: pool.append("I10")
    if obesity[i] and rng.random() < 0.45: pool.append("E66.01")    # obesity badly under-coded
    if dep_sev[i] >= 1 and rng.random() < 0.40 + 0.15 * dep_sev[i]:
        pool.append("F33.1" if dep_sev[i] >= 2 else "F32.0")
    if asthma[i] and rng.random() < 0.85: pool.append("J45.909")
    return pool

def rand_date(i):
    s, e = m.at[i, "enroll_start"], m.at[i, "enroll_end"]
    return s + pd.Timedelta(days=int(rng.integers(0, (e - s).days + 1)))

rows = []
for i in range(N):
    mid, cdx = m.at[i, "member_id"], chronic_dx(i)
    for _ in range(n_off[i]):
        dx = rng.choice(cdx) if cdx and rng.random() < 0.7 else rng.choice(["Z00.00", "J06.9", "M54.50", "R51.9"])
        tele = rng.random() < 0.18
        rows.append([mid, rand_date(i), "professional", "02 Telehealth" if tele else "11 Office", dx,
                     rng.choice(["99213", "99214"], p=[0.6, 0.4]), rng.lognormal(np.log(140), 0.3)])
    for _ in range(n_ed[i]):
        dx = rng.choice(cdx) if cdx and rng.random() < 0.3 else rng.choice(["R07.9", "R10.9", "S93.401A", "J06.9", "R55"])
        rows.append([mid, rand_date(i), "outpatient", "23 Emergency Room", dx,
                     rng.choice(["99283", "99284", "99285"], p=[0.35, 0.45, 0.20]), rng.lognormal(np.log(1700), 0.5)])
    for _ in range(n_ip[i]):
        dx = rng.choice(cdx) if cdx and rng.random() < 0.5 else rng.choice(["I21.4", "J18.9", "N39.0", "A41.9"])
        rows.append([mid, rand_date(i), "inpatient", "21 Inpatient Hospital", dx, "DRG", rng.lognormal(np.log(16000), 0.6)])
    # pharmacy: monthly fills for chronic meds
    meds = []
    if diabetes[i]: meds.append(("metformin", 12))
    if glp1[i]: meds.append(("GLP-1 RA", 950))
    if hypert[i]: meds.append(("ACE inhibitor", 10))
    if dep_sev[i] >= 2 and rng.random() < 0.6: meds.append(("SSRI", 15))
    if asthma[i]: meds.append(("inhaled corticosteroid", 45))
    for drug, cost in meds:
        adherence = rng.uniform(0.5, 1.0)
        for mo in range(int(mm[i])):
            if rng.random() < adherence:
                d = m.at[i, "enroll_start"] + pd.DateOffset(months=mo) + pd.Timedelta(days=int(rng.integers(0, 27)))
                rows.append([mid, d, "pharmacy", "Pharmacy", None, drug, rng.lognormal(np.log(cost), 0.15)])

claims = pd.DataFrame(rows, columns=["member_id", "service_date", "claim_type", "place_of_service",
                                     "dx1", "procedure_or_drug", "allowed_amt"])
claims = claims.sort_values(["service_date", "member_id"]).reset_index(drop=True)
claims["allowed_amt"] = claims["allowed_amt"].round(2)
claims["paid_amt"] = (claims["allowed_amt"] * rng.uniform(0.70, 0.95, len(claims))).round(2)
claims.insert(0, "claim_id", [f"C{2000000 + i}" for i in range(len(claims))])
claims["claim_status"] = "paid"

# gotcha: ~1.5% of claims were reversed and re-submitted -> reversal line with negative dollars
rev = claims.sample(frac=0.015, random_state=1).copy()
rev["allowed_amt"] *= -1
rev["paid_amt"] *= -1
rev["claim_status"] = "reversed"
claims = pd.concat([claims, rev]).sort_values(["service_date", "claim_id"]).reset_index(drop=True)

# ---------------------------------------------------------------- EHR (only in-network patients)
in_ehr = rng.random(N) < np.where(m["zip"].isin(["84321", "84341", "84302"]), 0.85, 0.55)
xwalk = pd.DataFrame({"mrn": [f"E{rng.integers(10**6, 10**7)}" for _ in range(N)],
                      "member_id": m["member_id"]})[in_ehr]

true_bmi = np.where(age >= 18, rng.normal(27 + 7 * obesity + 1.5 * diabetes, 3.5), rng.normal(19, 3, N))
ehr = []
for i in np.where(in_ehr)[0]:
    mrn = xwalk.loc[i, "mrn"]
    for _ in range(max(1, rng.poisson(2.5))):
        d = pd.Timestamp(f"{YEAR}-01-01") + pd.Timedelta(days=int(rng.integers(0, 365)))
        bmi = true_bmi[i] + rng.normal(0, 0.6)
        if rng.random() < 0.012: bmi *= rng.choice([0.1, 10])   # unit / keying errors
        sbp = rng.normal(118 + 0.35 * max(age[i] - 30, 0) + 14 * hypert[i], 11)
        a1c = rng.normal(7.6 if diabetes[i] else 5.3, 0.9 if diabetes[i] else 0.3) if (diabetes[i] or rng.random() < 0.2) and age[i] >= 18 else np.nan
        phq9 = np.clip(rng.normal([2, 7, 13, 21][dep_sev[i]], 2.5), 0, 27).round() if age[i] >= 12 and rng.random() < 0.45 else np.nan
        ehr.append([mrn, d, rng.choice(["Primary care", "Specialty", "Urgent care"], p=[0.7, 0.2, 0.1]),
                    round(bmi, 1) if age[i] >= 2 else np.nan, round(sbp), round(a1c, 1) if a1c == a1c else np.nan, phq9])
ehr = pd.DataFrame(ehr, columns=["mrn", "encounter_date", "encounter_type", "bmi", "sbp", "a1c", "phq9"])
ehr = ehr.sort_values(["mrn", "encounter_date"]).reset_index(drop=True)

# ---------------------------------------------------------------- vendor (third-party SDOH / consumer data)
matched = rng.random(N) < 0.83
vendor = pd.DataFrame({
    "member_id": m["member_id"],
    "match_confidence": np.round(rng.beta(8, 2, N), 2),
    "food_insecurity_index": np.round(np.clip(food_insec + rng.normal(0, 8, N), 0, 100)).astype(int),
    "housing_instability": (rng.random(N) < lin(-3 + 0.035 * food_insec)).astype(int),
    "transportation_barrier": (rng.random(N) < lin(-2.6 + 0.025 * food_insec + 0.8 * (m["plan_type"] == "Medicaid"))).astype(int),
    "est_household_income": rng.choice(["<35k", "35-75k", "75-125k", "125k+"], N, p=[0.22, 0.33, 0.28, 0.17]),
})[matched]

# ---------------------------------------------------------------- write
m.drop(columns="svi").to_csv(OUT / "members.csv", index=False)
claims.to_csv(OUT / "claims.csv", index=False)
ehr.to_csv(OUT / "ehr_encounters.csv", index=False)
xwalk.to_csv(OUT / "mrn_crosswalk.csv", index=False)
zips.to_csv(OUT / "census_zip.csv", index=False)
vendor.to_csv(OUT / "vendor_sdoh.csv", index=False)

for f in ["members", "claims", "ehr_encounters", "mrn_crosswalk", "census_zip", "vendor_sdoh"]:
    print(f"{f:16s}", pd.read_csv(OUT / f"{f}.csv").shape)
