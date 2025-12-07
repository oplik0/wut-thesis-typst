#import "@preview/touying:0.6.1": config-info
#import "../src/lib.typ": wut-presentation, title-slide, focus-slide

#show: wut-presentation.with(
  config-info(
    title: [My Thesis Presentation],
    subtitle: [An Example Presentation],
    author: [Student Name],
    date: datetime.today(),
    institution: [Warsaw University of Technology],
  ),
)

#title-slide()

= Introduction

== Background

- This is the first point.
- This is the second point.
- And a third one.

== Motivation

#lorem(20)

= Methodology

== Approach

We used the following approach:
1. Step 1
2. Step 2
3. Step 3

#focus-slide[
  This is a very important point!
]

= Conclusion

== Summary

- We did this.
- We found that.

== Future Work

- More research.
- More implementation.
