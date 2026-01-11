#import "@preview/hydra:0.6.1": hydra
#import "@preview/linguify:0.4.2": *

#let in-outline = state("in-outline", false)
#let lang-database = state("linguify-db", none)

/// Simple document template for projects, reports, and notes
/// Lightweight alternative to the formal thesis template
#let simple-doc(
  /// Type of document: "project", "report", or "notes"
  doc-type: "project",
  /// Document title
  title: "Document Title",
  /// Author(s) - can be a string or array of strings
  author: "Author Name",
  /// Date of the document - set to none to hide
  date: datetime.today(),
  /// Language for the document (influences hyphenation and some labels)
  lang: "en",
  /// Course or project name (optional)
  course: none,
  /// Instructor/supervisor name (optional)
  instructor: none,
  /// Show table of contents
  show-toc: true,
  /// Show outline of figures
  show-figures: false,
  /// Show outline of tables
  show-tables: false,
  /// Draft mode - shows colored links and draft watermark
  draft: false,
  /// Custom header text (optional)
  header-text: none,
  /// Show page numbers
  show-page-numbers: true,
  /// Font for the document
  font: "New Computer Modern",
  /// Font size
  font-size: 11pt,
  /// Logo (set to true to use default)
  logo: none,
  body,
) = {
  // Validate doc-type
  assert(
    doc-type in ("project", "report", "notes"),
    message: "doc-type must be 'project', 'report', or 'notes'"
  )
  
  // Load language database
  let linguify-database = toml("lang.toml")
  lang-database.update(linguify-database)
  
  // Document type specific settings
  let is-notes = doc-type == "notes"
  let is-formal = doc-type in ("project", "report")
  
  // Global text settings
  set text(
    lang: lang,
    weight: "regular",
    font: font,
    size: font-size,
  )
  
  set text(ligatures: false)
  show footnote: set text(size: 9pt)
  show raw: set block(breakable: false)
  
  // Line spacing and paragraph settings
  let par-indent = if is-notes { 0cm } else { 0.5cm }
  set par(
    leading: if is-notes { .6em } else { .8em },
    first-line-indent: par-indent,
    justify: not is-notes
  )
  
  set document(author: author, title: title)
  
  // Page layout
  let page-margin = if is-notes { 20mm } else { 25mm }
  
  set page(
    numbering: if show-page-numbers { "1" } else { none },
    margin: page-margin,
    header: context {
      let header-content = if header-text != none {
        header-text
      } else if is-notes {
        none
      } else {
        emph(hydra(1))
      }
      
      if header-content != none {
        let stroke = if measure(header-content).width > measure([1]).width { .3pt + black } else { none }
        block(width: 100%, outset: 4pt, stroke: (bottom: stroke), {
          set align(center)
          if draft [
            #place(left, box(outset: 3pt, fill: red, text(
              fill: black,
              weight: "black",
              size: 8pt,
            )[DRAFT]))
          ]
          header-content
        })
      } else if draft {
        align(left, box(outset: 3pt, fill: red, text(
          fill: black,
          weight: "black",
          size: 8pt,
        )[DRAFT]))
      }
    },
    footer: if show-page-numbers {
      context {
        align(center)[#counter(page).display("1")]
      }
    } else {
      none
    },
  )
  
  // Title page section
  {
    set align(center)
    if logo != none and logo != false {
      if logo == true {
            image("../assets/logo_wut.svg", width: 25mm)
        } else {
            logo
        }
        v(1.5em)
    }
    // Document type heading
    if is-formal {
      let type-label = if doc-type == "project" {
        if lang == "pl" { "Projekt" } else { "Project" }
      } else {
        if lang == "pl" { "Raport" } else { "Report" }
      }
      text(size: font-size*1.5, weight: "semibold")[#type-label]
      v(0.5em)
    }
    
    // Course/project name
    if course != none {
      text(size: font-size * 1.1)[#course]
      v(0.3em)
    }
    
    // Title
    text(size: if is-formal { font-size * 1.5 } else { font-size * 1.4 }, weight: "bold")[#title]
    v(1em)
    
    // Author(s)
    if type(author) == array {
      for a in author {
        text(size: font-size * 1.1)[#a]
        linebreak()
      }
    } else {
      text(size: font-size * 1.1)[#author]
    }
    v(0.5em)
    
    // Instructor
    if instructor != none {
      text(size: font-size, style: "italic")[
        #if lang == "pl" { "Prowadzący: " } else { "Instructor: " }#instructor
      ]
      v(0.3em)
    }
    
    // Date
    if date != none {
      v(0.5em)
      if type(date) == datetime {
        text(size: font-size)[#date.display("[day] [month repr:long] [year]")]
      } else {
        text(size: font-size)[#date]
      }
    }
    
    v(1.5em)
  }
  
  // Table of contents
  if show-toc and not is-notes {
    pagebreak(weak: true)
    show outline.entry.where(level: 1): set text(weight: "bold")
    outline(indent: 2em, depth: 3)
    pagebreak(weak: true)
  } else if show-toc and is-notes {
    v(1em)
    show outline.entry.where(level: 1): set text(weight: "bold")
    outline(indent: 2em, depth: 2)
    v(1em)
  }
  
  // Reset page counter after front matter
  if is-formal {
    counter(page).update(1)
  }
  
  // Heading numbering
  set heading(numbering: if is-notes { none } else { "1.1" })
  
  // Equation numbering
  set math.equation(numbering: "(1)")
  
  // Heading sizes and spacing
  show heading.where(level: 1): set text(size: if is-notes { 1.4em } else { 1.5em })
  show heading.where(level: 2): set text(size: if is-notes { 1.2em } else { 1.3em })
  show heading.where(level: 3): set text(size: if is-notes { 1.1em } else { 1.15em })
  show heading.where(level: 4): set text(size: 1.05em)
  
  // Heading spacing
  if is-notes {
    show heading.where(level: 1): set block(above: 1.2em, below: 0.6em)
    show heading.where(level: 2): set block(above: 1em, below: 0.5em)
    show heading.where(level: 3): set block(above: 0.8em, below: 0.4em)
  } else {
    show heading.where(level: 1): set block(above: 1.8em, below: 1em)
    show heading.where(level: 2): set block(above: 1.6em, below: 0.8em)
    show heading.where(level: 3): set block(above: 1.4em, below: 0.7em)
  }
  
  // Pagebreak after level 1 headings for formal documents
  if is-formal {
    show heading.where(level: 1): it => {
      if not state("in-outline", false).get() {
        pagebreak(weak: true)
      }
      it
    }
  }
  
  // Figure settings
  show figure: set text(size: 0.9em)
  show figure: set block(spacing: if is-notes { 1.5em } else { 2em })
  show figure.caption: set text(size: 10pt)
  
  // Table captions on top
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: raw): set figure.caption(position: top)
  
  // Table styling
  set table(stroke: 0.5pt + black)
  
  // Caption styling
  show figure.caption: it => {
    align(
      box(align(
        [#text(weight: "bold")[#it.supplement~#context it.counter.display(it.numbering).~]#it.body],
        left,
      )),
      center,
    )
  }
  
  // Link colors
  show link: it => {
    if type(it.dest) == str {
      text(fill: if draft { blue } else { rgb("#0099A1") }, it)
    } else {
      it
    }
  }
  show ref: set text(fill: rgb("#823C84"))
  show cite: set text(fill: rgb("#D58A16"))
  
  body
  
  // Outlines at the end
  if show-figures or show-tables {
    pagebreak(weak: true)
  }
  
  if show-figures {
    outline(
      title: if lang == "pl" { "Spis rysunków" } else { "List of Figures" },
      target: figure.where(kind: image),
    )
  }
  
  if show-tables {
    if show-figures { v(2em) } // Add space if both are shown
    outline(
      title: if lang == "pl" { "Spis tabel" } else { "List of Tables" },
      target: figure.where(kind: table),
    )
  }
}

/// Helper function for code listings
#let code-listing(
  content,
  caption: none,
  lang: none,
) = {
  figure(
    rect(
      stroke: (y: 1pt + black),
      align(left, {
        if type(content) == str {
          raw(block: true, lang: lang, content)
        } else {
          content
        }
      }),
    ),
    caption: caption,
    kind: raw,
  )
}

/// Helper function to load code from file
#let code-from-file(
  filename,
  caption: none,
  listings-dir: "listings/",
) = {
  let extension = filename.split(".").last()
  code-listing(
    read(listings-dir + filename),
    caption: caption,
    lang: extension,
  )
}

/// Helper for callout boxes (info, warning, note)
#let callout(
  body,
  title: none,
  type: "note",
) = {
  let colors = (
    note: (border: blue, bg: blue.lighten(90%)),
    info: (border: rgb("#0099A1"), bg: rgb("#0099A1").lighten(90%)),
    warning: (border: orange, bg: orange.lighten(90%)),
    important: (border: red, bg: red.lighten(90%)),
  )
  
  let color-scheme = colors.at(type, default: colors.note)
  
  rect(
    width: 100%,
    inset: 1em,
    radius: 0.3em,
    stroke: 2pt + color-scheme.border,
    fill: color-scheme.bg,
  )[
    #if title != none [
      *#title*
      
    ]
    #body
  ]
}
