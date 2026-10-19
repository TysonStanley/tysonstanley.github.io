// ---------------------------------------------------------------------------
// CV template (Quarto template partial: typst-template.typ)
// All layout lives here; CV-typst.qmd only supplies content and data.
// ---------------------------------------------------------------------------

// Colors ------------------------------------------------------------------
#let money-color   = rgb("#1E8449")
#let divider-color = rgb("#D6DBDF")
#let link-color    = rgb("#1F3A60")   // subtle navy so links are findable
#let money(body) = text(fill: money-color, body)

// Layout constants --------------------------------------------------------
#let body-inset = 0.15in   // how far entries sit to the right of section rules
#let hang       = 0.3in   // hanging indent for reference-style entries

// Anything matching this is bolded automatically, everywhere in the CV.
// No need to wrap your name in ** ** or \textbf{} in the source/spreadsheet.
#let me = regex("Barrett, T\.\s?(S\.)?(\s\((Co-I|Consultant)\))?")

// Main document function ---------------------------------------------------
#let cv(title: none, body) = {
  set document(title: title, author: "Tyson S. Barrett")
  set page(
    paper: "us-letter",
    // left margin includes body-inset so entries sit inside the section rules
    margin: (left: 1in + body-inset, right: 1in, top: 0.9in, bottom: 0.9in),
    // Running header from page 2 on: name left, "Curriculum Vitae" right,
    // with a light hairline. The negative pad aligns it with the section rules.
    header: context {
      if here().page() > 1 {
        set text(size: 8.5pt, fill: luma(100))
        set par(hanging-indent: 0pt)
        pad(left: -body-inset, block(width: 100% + body-inset, {
          grid(columns: (1fr, auto), align: (left, right),
            smallcaps[Tyson S. Barrett, PhD], [Curriculum Vitae])
          v(-5pt)
          line(length: 100%, stroke: 0.4pt + luma(175))
        }))
      }
    },
    // Footer: "3 of 15", centered on the page text width
    footer: context {
      set text(size: 8.5pt, fill: luma(100))
      pad(left: -body-inset, align(center,
        [#counter(page).display() of #counter(page).final().first()]))
    },
  )
  set text(font: "New Computer Modern", size: 10pt, lang: "en")
  set par(justify: true, leading: 0.52em, spacing: 0.8em, hanging-indent: hang)

  show me: strong
  show link: set text(fill: link-color)
  show raw: set text(font: "DejaVu Sans Mono", size: 0.85em, fill: black)

  // Section headings: bold caps with a full-width rule underneath.
  // The negative pad pulls headings back to the margin while entries
  // stay inset by `body-inset`.
  show heading.where(level: 1): it => {
    set par(hanging-indent: 0pt, justify: false)
    v(20pt, weak: true)   // space above section headings
    pad(left: -body-inset, block(width: 100% + body-inset, sticky: true, {
      stack(spacing: 4pt,
        text(size: 14pt, weight: "bold", it.body),
        line(length: 100%, stroke: 0.6pt))
    }))
    v(2pt)
  }
  show heading.where(level: 2): it => {
    set par(hanging-indent: 0pt)
    v(8pt, weak: true)
    block(sticky: true, text(size: 11pt, weight: "bold", it.body))
    v(2pt)
  }

  body
}

// Header -------------------------------------------------------------------
#let cv-header(name: "", contacts: (), scholar: none) = {
  set par(hanging-indent: 0pt, justify: false)
  let today = datetime.today().display("[month repr:long] [day padding:none], [year]")
  pad(left: -body-inset + 0.08in, {
    grid(
      columns: (1fr, auto), align: (left + bottom, right + bottom),
      text(size: 24pt, smallcaps(name)),
      text(size: 8pt)[Updated: #today],
    )
    v(12pt)   // space between name and contact info
    let rows = contacts.map(c => (smallcaps(c.at(0) + ":"), link(c.at(1), c.at(2))))
    if scholar != none {
      rows.push((smallcaps("Citations:"), str(scholar.citations)))
      rows.push((smallcaps("H Index:"), str(scholar.h_index)))
    }
    grid(
      columns: 2, column-gutter: 0.9em, row-gutter: 0.75em,   // spacing between contact rows
      align: (right, left),
      ..rows.flatten(),
    )
  })
  v(6pt)
}

// Education ------------------------------------------------------------------
#let edu(degree, date, school, note: none) = {
  set par(hanging-indent: 0pt, justify: false)
  block(breakable: false, below: 1.1em, grid(
    columns: (2.3in, 1fr),
    inset: (x, y) => if x == 1 { (left: 0.5em) } else { 0pt },
    stroke: (x, y) => if x == 1 { (left: 0.6pt) },
    strong(degree),
    {
      emph(date); linebreak(); emph(school)
      if note != none { linebreak(); text(size: 8pt, emph(note)) }
    },
  ))
}

// Appointments ---------------------------------------------------------------
#let job(title, org, dates, details: ()) = {
  set par(hanging-indent: 0pt, justify: false)
  set text(size: 9.5pt)
  block(breakable: false, below: 0.9em, {
    grid(columns: (1fr, auto), [*#title*, #org], dates)
    v(-0.4em)
    pad(left: 0.4in, stack(spacing: 0.42em, ..details.map(emph)))
  })
}

// Teaching -----------------------------------------------------------------
#let course(code, title, level: none, terms: none, note: none) = {
  set par(hanging-indent: 1.5em, justify: false)
  set text(hyphenate: false)
  block(breakable: false, below: 0.75em, {
    grid(columns: (1fr, auto), column-gutter: 1.5em,
      par[#if code != none [*#code* #h(0.4em)]#title#if level != none [ #text(size: 9pt, style: "italic")[(#level)]]],
      if terms != none { terms })
    if note != none {
      v(-0.4em)
      pad(left: 0.4in, text(size: 9.5pt, emph(note)))
    }
  })
}

// Awards -------------------------------------------------------------------
#let award(name, org, year) = {
  set par(hanging-indent: 1.5em, justify: false)
  set text(hyphenate: false)
  block(below: 0.75em, grid(columns: (1fr, auto), column-gutter: 1.5em,
    par[*#name*, #org], year))
}

// One-line entries (interests, service) -------------------------------------
#let interest(label, body) = par(hanging-indent: 0pt)[#smallcaps(label + ":") #body]

#let service(name, url, role, dates) = {
  set par(hanging-indent: 0pt)
  block(below: 0.85em, grid(columns: (1fr, auto),
    [#link(url, strong(name)) #role], dates))
}

// Small linked icons (OSF badges, package hex stickers) ---------------------
#let icon(file, url) = box(baseline: 15%,
  link(url, image(file, height: 0.95em)))
#let osf(url, data: true, materials: true) = {
  if data { h(2pt); icon("osfdata.png", url) }
  if materials { h(1pt); icon("osfmaterials.png", url) }
}

// Two-column "label | entry" list with a continuous light divider ----------
// Used for external funding and journal articles. The R code in CV-typst.qmd
// builds `items` as ((label, entry), (label, entry), ...).
// Each entry is wrapped in an explicit `par()` so the hanging indent applies
// (Typst does not treat bare text in a grid cell as a paragraph).
#let labelled-list(label-width, label-size: 10pt, label-align: right, items) = grid(
  columns: (label-width, 1fr),
  inset: (x, y) => (
    left: if x == 1 { 0.75em } else { 0pt },
    right: if x == 0 { 0.6em } else { 0pt },
    bottom: 0.7em,
  ),
  stroke: (x, y) => if x == 1 { (left: 0.6pt + divider-color) },
  ..items.map(((label, entry)) => (
    align(label-align, par(hanging-indent: 0pt, justify: false, text(size: label-size, label))),
    par(hanging-indent: 3em, justify: true, entry),
  )).flatten(),
)
