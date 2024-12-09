import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html

pub fn head(page: String) -> Element(a) {
  html.head([], [
    html.meta([attribute("charset", "UTF-8")]),
    html.title([], "Gears | " <> page),
    html.link([attribute.href("/style.css"), attribute.rel("stylesheet")]),
    html.link([attribute.href("https://rsms.me/"), attribute.rel("preconnect")]),
    html.link([
      attribute.href("https://rsms.me/inter/inter.css"),
      attribute.rel("stylesheet"),
    ]),
    html.link([
      attribute.type_("image/svg+xml"),
      attribute.href("/favicon.svg"),
      attribute.rel("icon"),
    ]),
    html.link([
      attribute("sizes", "48x48"),
      attribute.type_("image/png"),
      attribute.href("/favicon.ico"),
      attribute.rel("alternate icon"),
    ]),
    html.link([
      attribute("sizes", "192x192"),
      attribute.href("/apple-touch-icon.png"),
      attribute.rel("apple-touch-icon"),
    ]),
  ])
}

pub fn page(name: String, body: List(Element(a))) -> Element(a) {
  html.html([attribute("lang", "en")], [head(name), html.body([], body)])
}
