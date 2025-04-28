import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html
import website/component/footer
import website/component/header

pub fn head(page: String) -> Element(a) {
  html.head([], [
    html.meta([attribute("charset", "UTF-8")]),
    html.title([], page <> " | Gears"),
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

pub fn page(name: String, content: List(Element(a))) -> Element(a) {
  html.html([attribute("lang", "en")], [
    head(name),
    html.body([attribute.class("min-h-screen bg-slate-800 text-white")], [
      header.view(name),
      html.main([attribute.class("py-24")], content),
      footer.view(),
    ]),
  ])
}

pub fn text_page(
  title: String,
  header: String,
  content: List(Element(a)),
) -> Element(a) {
  page(title, [
    html.div([attribute.class("mx-auto max-w-3xl")], [
      html.h1(
        [attribute.class("text-3xl font-bold leading-tight text-center")],
        [html.text(header)],
      ),
    ]),
    html.div([attribute.class("mx-auto max-w-4xl py-8 leading-8")], [
      html.p([attribute.class("text-xl")], content),
    ]),
  ])
}

pub fn dangerous_html(html: String) -> Element(a) {
  element.unsafe_raw_html("", "span", [], html)
}
