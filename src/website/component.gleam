import gleam/list
import gleam/option.{type Option}
import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html
import website/component/footer
import website/component/header
import website/highlight

pub fn head(page: String) -> Element(_) {
  html.head([], [
    html.meta([attribute("charset", "UTF-8")]),
    html.title([], page <> " | Gears"),
    html.link([attribute.href("/main.css"), attribute.rel("stylesheet")]),
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

pub type Section(a) {
  Section(content: List(Element(a)))
}

pub fn page(name: String, sections: List(Section(a))) -> Element(_) {
  html.html([attribute("lang", "en")], [
    head(name),
    html.body([], [
      header.view(),
      html.main([], list.flat_map(sections, fn(section) { section.content })),
      footer.view(),
    ]),
  ])
}

pub fn text_page(header: String, content: List(Element(a))) -> Section(a) {
  Section([
    html.h1([], [html.text(header)]),
    html.div([], content),
  ])
}

pub fn raw_html(html: String) -> Element(_) {
  element.unsafe_raw_html("", "span", [], html)
}

pub fn code_block(language: Option(String), code_text: String) -> Element(_) {
  let code = highlight.highlight(code_text, language)

  html.div([attribute.class("codeblock")], [
    html.button(
      [
        attribute.class("copy-button"),
        attribute(
          "onclick",
          "navigator.clipboard.writeText(`" <> code_text <> "`)",
        ),
      ],
      [html.text("copy")],
    ),
    html.pre([], [
      html.code([attribute("data-lang", option.unwrap(language, "text"))], [
        code,
      ]),
    ]),
  ])
}
