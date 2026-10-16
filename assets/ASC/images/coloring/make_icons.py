"""Line-art (colorable) SVGs for the ASC handout."""
import math, sys
from pathlib import Path
OUT = Path(sys.argv[1])
S = 'fill="white" stroke="#111" stroke-width="{w}" stroke-linejoin="round" stroke-linecap="round"'
def svg(body, vb="0 0 100 100", w=3):
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{vb}"><g {S.format(w=w)}>{body}</g></svg>'

# ---- small icon bodies drawn in a 100x100 box --------------------------------
heart = '<path d="M50 84 C22 64 12 50 12 34 C12 22 21 14 32 14 C41 14 47 20 50 27 C53 20 59 14 68 14 C79 14 88 22 88 34 C88 50 78 64 50 84 Z"/>'
people = ('<circle cx="37" cy="33" r="12"/><path d="M14 82 C14 62 24 52 37 52 C50 52 60 62 60 82 Z"/>'
          '<circle cx="66" cy="38" r="10"/><path d="M52 60 C56 55 61 53 66 53 C78 53 87 62 87 80 L62 80"/>')
costs = ('<circle cx="40" cy="40" r="26"/>'
         '<path d="M48 30 C46 26 42 25 39 25 C33 25 30 29 30 33 C30 43 50 37 50 47 C50 52 46 55 40 55 C35 55 31 53 30 49" fill="none"/>'
         '<path d="M40 20 L40 60" fill="none"/>'
         '<path d="M58 62 L72 76 L86 62 L80 62 L80 44 L64 44 L64 62 Z"/>')
shield = ('<path d="M50 10 L84 22 L84 48 C84 68 70 82 50 90 C30 82 16 68 16 48 L16 22 Z"/>'
          '<path d="M50 66 C36 56 31 50 31 42 C31 36 35 32 41 32 C45 32 48 35 50 38 C52 35 55 32 59 32 C65 32 69 36 69 42 C69 50 64 56 50 66 Z"/>')
scales = ('<rect x="46" y="18" width="8" height="62" rx="2"/><rect x="28" y="80" width="44" height="8" rx="3"/>'
          '<rect x="14" y="22" width="72" height="6" rx="3"/><circle cx="50" cy="16" r="5"/>'
          '<path d="M20 28 L8 56 M20 28 L32 56 M80 28 L68 56 M80 28 L92 56" fill="none"/>'
          '<path d="M6 56 L34 56 C34 66 28 70 20 70 C12 70 6 66 6 56 Z"/>'
          '<path d="M66 56 L94 56 C94 66 88 70 80 70 C72 70 66 66 66 56 Z"/>')

# ---- healthcare / data icons -------------------------------------------------
hospital = ('<rect x="14" y="30" width="72" height="58"/><rect x="34" y="12" width="32" height="22"/>'
            '<path d="M46 16 L54 16 L54 20 L58 20 L58 28 L54 28 L54 32 L46 32 L46 28 L42 28 L42 20 L46 20 Z"/>'
            '<rect x="22" y="40" width="12" height="10"/><rect x="44" y="40" width="12" height="10"/><rect x="66" y="40" width="12" height="10"/>'
            '<rect x="22" y="58" width="12" height="10"/><rect x="66" y="58" width="12" height="10"/><rect x="42" y="64" width="16" height="24"/>')
pill = ('<g transform="rotate(-40 50 50)"><path d="M50 30 L30 30 A20 20 0 0 0 30 70 L50 70 Z"/>'
        '<path d="M50 30 L70 30 A20 20 0 0 1 70 70 L50 70 Z"/></g>'
        '<circle cx="82" cy="78" r="9"/><path d="M76 84 L88 72" fill="none"/>')
stetho = ('<path d="M26 12 L26 40 C26 56 38 64 50 64 C62 64 74 56 74 40 L74 12" fill="none" stroke-width="5"/>'
          '<rect x="20" y="8" width="12" height="8" rx="3"/><rect x="68" y="8" width="12" height="8" rx="3"/>'
          '<path d="M50 64 L50 74 C50 86 62 90 70 84" fill="none" stroke-width="5"/><circle cx="78" cy="76" r="12"/><circle cx="78" cy="76" r="5"/>')
clipboard = ('<rect x="18" y="16" width="64" height="76" rx="6"/><rect x="34" y="8" width="32" height="14" rx="4"/>'
             '<path d="M28 40 L72 40 M28 52 L72 52 M28 64 L56 64" fill="none"/>'
             '<path d="M58 74 L64 80 L76 66" fill="none" stroke-width="4"/>')
database = ('<path d="M18 22 L18 78 C18 86 34 92 50 92 C66 92 82 86 82 78 L82 22"/>'
            '<ellipse cx="50" cy="22" rx="32" ry="12"/>'
            '<path d="M18 41 C18 49 34 55 50 55 C66 55 82 49 82 41 M18 60 C18 68 34 74 50 74 C66 74 82 68 82 60" fill="none"/>')
chart = ('<path d="M10 88 L90 88" fill="none"/><rect x="16" y="56" width="14" height="32"/><rect x="36" y="40" width="14" height="48"/>'
         '<rect x="56" y="62" width="14" height="26"/><circle cx="70" cy="32" r="16"/><path d="M81 43 L94 56" fill="none" stroke-width="7"/>')
ambulance = ('<path d="M6 30 L60 30 L60 74 L6 74 Z"/><path d="M60 42 L80 42 L94 58 L94 74 L60 74 Z"/><path d="M66 48 L78 48 L86 58 L66 58 Z"/>'
             '<circle cx="24" cy="76" r="9"/><circle cx="76" cy="76" r="9"/>'
             '<path d="M29 40 L37 40 L37 48 L45 48 L45 56 L37 56 L37 64 L29 64 L29 56 L21 56 L21 48 L29 48 Z"/>')
dna = ''.join(
    f'<path d="M{30+20*math.sin(i/4)} {8+i*6} L{70-20*math.sin(i/4)} {8+i*6}" fill="none"/>' for i in range(1, 14, 2)
) + ('<path d="' + 'M' + ' L'.join(f'{50+22*math.sin(t/6):.1f} {8+t*3:.1f}' for t in range(0, 29)) + '" fill="none" stroke-width="5"/>'
     '<path d="' + 'M' + ' L'.join(f'{50-22*math.sin(t/6):.1f} {8+t*3:.1f}' for t in range(0, 29)) + '" fill="none" stroke-width="5"/>')

receipt = ('<path d="M22 8 L78 8 L78 92 L71 86 L64 92 L57 86 L50 92 L43 86 L36 92 L29 86 L22 92 Z"/>'
           '<path d="M32 24 L60 24 M32 36 L68 36 M32 48 L52 48" fill="none"/>'
           '<circle cx="62" cy="66" r="11"/>'
           '<path d="M66 61 C65 59 63 58 61.5 58 C58.5 58 57 60 57 62 C57 66.5 67 64 67 69 C67 71.5 65 73 62 73 C59.5 73 57.5 72 57 70 M62 55 L62 77" fill="none" stroke-width="2.4"/>')
homes = ('<path d="M6 54 L26 36 L46 54 L46 88 L6 88 Z"/><rect x="20" y="66" width="12" height="22"/>'
         '<path d="M40 44 L64 22 L88 44 L88 88 L40 88 Z"/><rect x="56" y="62" width="16" height="26"/>'
         '<rect x="50" y="42" width="10" height="10"/><rect x="68" y="42" width="10" height="10"/>'
         '<path d="M2 88 L98 88" fill="none"/>')
icons = dict(receipt=receipt, homes=homes, heart=heart, people=people, costs=costs, shield=shield, scales=scales,
             hospital=hospital, pill=pill, stethoscope=stetho, clipboard=clipboard,
             database=database, chart=chart, ambulance=ambulance)
for k, v in icons.items():
    (OUT / f"{k}.svg").write_text(svg(v))

# ---- Quintuple Aim coloring page ---------------------------------------------
C = 0; R = 215; r_node = 66; r_core = 105
labels = [("Patient Experience", heart), ("Population Health", people), ("Reducing Costs", costs),
          ("Care Team Well-being", shield), ("Health Equity", scales)]
F = 'font-family="Helvetica, Arial, sans-serif"'
parts = [f'<circle cx="0" cy="0" r="{R+10}" fill="none"/>', f'<circle cx="0" cy="0" r="{R-10}" fill="none"/>',
         f'<circle cx="0" cy="0" r="{r_core}" stroke-width="5"/>', f'<circle cx="0" cy="0" r="{r_core-14}"/>',
         '<text x="0" y="-42" text-anchor="middle" font-family="Georgia, serif" font-style="italic" font-size="24" stroke="none" fill="#111">Improving</text>',
         '<text x="0" y="-2" text-anchor="middle" font-family="Georgia, serif" font-size="38" stroke-width="1.3">Health</text>',
         '<text x="0" y="36" text-anchor="middle" font-family="Georgia, serif" font-size="38" stroke-width="1.3">Care</text>',
         f'<text x="0" y="62" text-anchor="middle" {F} font-size="12" letter-spacing="3" stroke="none" fill="#111">FOR EVERYONE</text>']
for i, (lab, body) in enumerate(labels):
    a = math.radians(-90 + i * 72)
    x, y = R * math.cos(a), R * math.sin(a)
    parts.append(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{r_node}" stroke-width="5"/>')
    sc = 0.78
    parts.append(f'<g transform="translate({x-50*sc:.1f},{y-50*sc:.1f}) scale({sc})">{body}</g>')
    if i == 0:   lx, ly = x, y - r_node - 18
    elif i == 1: lx, ly = x + 20, y - r_node - 26
    elif i == 4: lx, ly = x - 20, y - r_node - 26
    elif i == 2: lx, ly = x + 40, y + r_node + 34
    else:        lx, ly = x - 40, y + r_node + 34
    anc = "middle"
    parts.append(f'<text x="{lx:.1f}" y="{ly:.1f}" text-anchor="{anc}" {F} font-weight="bold" font-size="24" stroke-width="1.3">{lab}</text>')
    parts.append(f'<text x="{x:.1f}" y="{y - r_node - 46 if i == 0 else y + r_node + 10:.1f}" text-anchor="middle" {F} font-size="0" stroke="none"></text>')
(OUT / "quintuple_aim_coloring.svg").write_text(svg("".join(parts), vb="-360 -330 720 640", w=3))
print("wrote", len(icons) + 1, "svgs")
