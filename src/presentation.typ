#import "@preview/touying:0.6.1": *

#let slide(title: auto, ..args) = touying-slide-wrapper(self => {
  if title != auto {
    self.store.title = title
  }
  let header(self) = {
    set align(top)
    grid(
      rows: (auto, auto),
      row-gutter: 3mm,
      if self.store.progress-bar {
        components.progress-bar(
          height: 2pt,
          self.colors.primary,
          self.colors.tertiary,
        )
      },
      block(
        inset: (x: .5em),
        components.left-and-right(
          text(
            fill: self.colors.primary,
            weight: "bold",
            size: 1.2em,
            if self.store.title != none {
              utils.call-or-display(self, self.store.title)
            } else {
              utils.display-current-heading(level: 2)
            }
          ),
          text(
            fill: self.colors.primary.lighten(65%),
            if self.info.logo != none {
              set image(height: 1.5em)
              self.info.logo
            }
          ),
        ),
      ),
    )
  }
  let footer(self) = {
    set align(center + bottom)
    set text(size: .4em)
    {
      let cell(..args, it) = components.cell(
        ..args,
        inset: 1mm,
        align(horizon, text(fill: white, it)),
      )
      show: block.with(width: 100%, height: auto)
      grid(
        columns: self.store.footer-columns,
        rows: 1.5em,
        cell(fill: self.colors.primary, utils.call-or-display(self, self.store.footer-a)),
        cell(fill: self.colors.secondary, utils.call-or-display(self, self.store.footer-b)),
        cell(fill: self.colors.tertiary, utils.call-or-display(self, self.store.footer-c)),
      )
    }
  }
  self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      footer: footer,
    ),
  )
  touying-slide(self: self, ..args)
})

#let title-slide(..args) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(margin: 0em),
  )
  let info = self.info + args.named()
  info.authors = {
    let authors = if "authors" in info {
      info.authors
    } else {
      info.author
    }
    if type(authors) == array {
      authors
    } else {
      (authors,)
    }
  }
  let body = {
    // Colorful vertical slices background
    place(
      top + left,
      grid(
        columns: (70%, 25%, 5%),
        rows: 100%,
        block(width: 100%, height: 100%, fill: self.colors.primary,
          // Main content
          align(
            center + horizon,
            {
              block(
                inset: 2em,
                breakable: false,
                {
                  text(size: 2em, fill: self.colors.neutral-lightest, weight: "bold", info.title)
                  if info.subtitle != none {
                    parbreak()
                    text(size: 1.2em, fill: self.colors.neutral-lightest.darken(10%), info.subtitle)
                  }
                },
              )
              set text(size: .8em, fill: self.colors.neutral-lightest)
              grid(
                columns: (1fr,) * calc.min(info.authors.len(), 3),
                column-gutter: 1em,
                row-gutter: 1em,
                ..info.authors.map(author => text(fill: self.colors.neutral-lightest, author))
              )
              v(1em)
              if info.institution != none {
                parbreak()
                text(size: .9em, fill: self.colors.neutral-lightest, info.institution)
              }
              if info.date != none {
                parbreak()
                text(size: .8em, fill: self.colors.neutral-lightest.darken(15%), utils.display-info-date(self))
              }
            },
          )
        ),
        block(width: 100%, height: 100%, fill: self.colors.secondary,
          {
            if info.logo != none and info.logo.source == "../assets/logo_wut.svg" {
              place(top + center,dy: 1em, text(fill: self.colors.neutral-lightest, stroke: self.colors.neutral-lightest, image("../assets/logo_wut_white.svg")))
            } else if info.logo != none {
              place(top + center,dy: 1em, text(fill: self.colors.neutral-lightest, stroke: self.colors.neutral-lightest, info.logo))
            }
          }
        ),
        block(width: 100%, height: 100%, fill: self.colors.tertiary),
      )
    )
    // Logo in top right
    
    
  }
  touying-slide(self: self, body)
})

#let focus-slide(body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(
      fill: self.colors.primary,
      margin: 1em,
    ),
  )
  set text(fill: self.colors.neutral-lightest, weight: "bold", size: 2em)
  touying-slide(self: self, align(horizon + center, body))
})

#let wut-presentation(
  aspect-ratio: "16-9",
  progress-bar: true,
  footer-columns: (70%, 25%, 5%),
  footer-a: self => {
    grid(columns: (1fr, 2fr),
      self.info.author,
      {
        if self.info.short-title == auto {
          self.info.title
        } else {
          self.info.short-title
        }
      }
    )

  },
  footer-b: self => utils.display-info-date(self),
  footer-c: self => {
    context utils.slide-counter.display() + " / " + utils.last-slide-number
  },
  font: "New Computer Modern",
  ..args,
  body,
) = {
  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      header-ascent: 0em,
      footer-descent: 0em,
      margin: (top: 2.5em, bottom: 1.25em, x: 2em),
    ),
    config-common(
      slide-fn: slide,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(size: 20pt, font: font)
        show heading.where(level: 3): set text(fill: self.colors.primary)
        show heading.where(level: 4): set text(fill: self.colors.primary)
        body
      },
      alert: utils.alert-with-primary-color,
    ),
    config-colors(
      primary: rgb("#006872"),
      secondary: rgb("#004a6c"),
      tertiary: rgb("#e63312"),
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#000000"),
    ),
    config-store(
      title: none,
      progress-bar: progress-bar,
      footer-columns: footer-columns,
      footer-a: footer-a,
      footer-b: footer-b,
      footer-c: footer-c,
      font: font,
    ),
    config-info(
      logo: image("../assets/logo_wut.svg"),
    ),
    ..args,
  )
  body
}
