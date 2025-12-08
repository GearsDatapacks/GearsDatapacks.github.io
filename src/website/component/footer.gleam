import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn view() -> Element(_) {
  html.footer([], [
    element.text("Made with "),
    html.a(
      [
        attribute.href("https://lustre.build"),
        attribute.target("_blank"),
      ],
      [
        element.text("Lustre"),
      ],
    ),
    element.text(" and "),
    html.a(
      [
        attribute.href("https://gleam.run"),
        attribute.target("_blank"),
      ],
      [
        element.text("Gleam"),
      ],
    ),
    html.br([]),
    element.text("Source: "),
    html.a(
      [
        attribute.href(
          "https://github.com/GearsDatapacks/GearsDatapacks.github.io",
        ),
        attribute.target("_blank"),
      ],
      [
        element.text("GitHub"),
      ],
    ),
  ])
}
