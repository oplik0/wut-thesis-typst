#import "@preview/touying:0.6.1": *

#let slide(title: auto, ..args) = touying-slide-wrapper(self => {
  if title != auto {
    self.store.title = title
  }
  let header(self) = {
    set align(top)
    if self.store.progress-bar {
      utils.touying-progress(ratio => {
        line(length: 100% * ratio, stroke: 4pt + self.colors.primary)
      })
    }
    grid(
      columns: (1fr, auto),
      align: (left, right),
      inset: (top: 1em, bottom: 0.5em),
      text(
        fill: self.colors.primary,
        size: 1.2em,
        if self.store.title != none {
          utils.call-or-display(self, self.store.title)
        } else {
          utils.display-current-heading(level: 2)
        }
      ),
      if self.info.logo != none {
        set image(height: 2em)
        self.info.logo
      }
    )
    line(length: 100%, stroke: self.colors.primary + 2pt)
  }
  let footer(self) = {
    set align(bottom)
    set text(size: 0.8em)
    pad(
      top: 0.5em,
      bottom: 0.5em,
      grid(
        columns: (1fr, 1fr, 1fr),
        align: (left, center, right),
        self.info.author,
        self.info.title,
        {
          if self.info.date != none {
             utils.display-info-date(self)
             h(1em)
          }
          context utils.slide-counter.display() + " / " + utils.last-slide-number
        }
      )
    )
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
  let info = self.info + args.named()
  let body = {
    set align(center + horizon)
    block(
      width: 100%,
      inset: 2em,
      {
        if info.logo != none {
          set image(height: 3em)
          place(top + right, info.logo)
        }
        v(1fr)
        text(size: 2.5em, fill: self.colors.primary, weight: "bold", info.title)
        if info.subtitle != none {
          linebreak()
          text(size: 1.5em, fill: self.colors.secondary, weight: "bold", info.subtitle)
        }
        v(2em)
        text(size: 1.2em, info.author)
        if info.institution != none {
          linebreak()
          text(size: 1em, style: "italic", info.institution)
        }
        if info.date != none {
          linebreak()
          text(size: 1em, utils.display-info-date(self))
        }
        v(1fr)
      }
    )
  }
  touying-slide(self: self, body)
})

#let focus-slide(body) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-page(
      fill: self.colors.primary,
      margin: 2em,
    ),
  )
  set text(fill: self.colors.neutral-lightest, size: 2em)
  touying-slide(self: self, align(horizon + center, body))
})

#let wut-presentation(
  aspect-ratio: "16-9",
  progress-bar: true,
  ..args,
  body,
) = {
  set text(size: 20pt, font: "New Computer Modern")

  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      margin: (top: 3.5em, bottom: 2em, x: 2em),
    ),
    config-common(
      slide-fn: slide,
    ),
    config-colors(
      primary: rgb("#006872"),
      secondary: rgb("#823C84"),
      tertiary: rgb("#D58A16"),
      neutral-lightest: rgb("#ffffff"),
      neutral-darkest: rgb("#000000"),
    ),
    config-store(
      title: none,
      progress-bar: progress-bar,
    ),
    config-info(
      logo: image("../assets/logo_wut.svg"),
    ),
    ..args,
  )
  body
}
