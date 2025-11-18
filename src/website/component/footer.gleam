import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn view() -> Element(a) {
  html.footer(
    [
      attribute.class("right-5 bottom-4 fixed"),
    ],
    [
      element.text("Made with "),
      html.a(
        [
          attribute.href("https://lustre.build"),
          attribute.target("_blank"),
          attribute.class("underline"),
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
          attribute.class("underline"),
        ],
        [
          element.text("Gleam"),
        ],
      ),
    ],
  )
}
