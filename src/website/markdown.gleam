import gleam/dict
import gleam/list
import gleam/regexp
import gleam/string
import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html
import mork
import mork/document
import website/component

pub fn render(string: String) -> List(Element(_)) {
  let document = mork.parse(string)

  list.map(document.blocks, render_block)
}

fn render_block(block: document.Block) -> Element(_) {
  case block {
    document.BlockQuote(blocks:) ->
      html.blockquote([], list.map(blocks, render_block))
    document.BulletList(pack: _, items:) ->
      html.ul(
        [],
        list.map(items, fn(item) {
          html.li([], list.map(item.blocks, render_block))
        }),
      )
    document.Code(lang:, text:) -> component.code_block(lang, text)
    document.Newline | document.Empty -> element.none()
    document.Heading(level:, id:, raw: _, inlines:) ->
      render_heading(level, id, inlines)
    document.HtmlBlock(raw:) -> component.raw_html(raw)
    document.OrderedList(pack: _, items:, start: _) ->
      html.ol(
        [],
        list.map(items, fn(item) {
          html.li([], list.map(item.blocks, render_block))
        }),
      )
    document.Paragraph(raw: _, inlines:) ->
      html.p([], list.map(inlines, render_inline))
    document.Table(..) -> panic as "Tables not yet supported"
    document.ThematicBreak -> html.hr([])
  }
}

fn render_heading(
  level: Int,
  id: String,
  inlines: List(document.Inline),
) -> Element(a) {
  let heading = case level {
    1 -> html.h1
    2 -> html.h2
    3 -> html.h3
    4 -> html.h4
    5 -> html.h5
    _ -> html.h6
  }

  let id = case id {
    "" ->
      case inlines {
        [document.Text(text)] -> to_id(text)
        _ -> ""
      }
    _ -> id
  }

  heading([attribute.id(id)], list.map(inlines, render_inline))
}

fn to_id(text: String) -> String {
  let assert Ok(regex) =
    regexp.compile(
      "[^a-zA-Z0-9-]",
      regexp.Options(case_insensitive: True, multi_line: False),
    )
  text
  |> string.lowercase
  |> string.replace(" ", "-")
  |> regexp.replace(regex, _, "")
}

fn render_inline(inline: document.Inline) -> Element(a) {
  case inline {
    document.Autolink(uri:) -> anchor([html.text(uri)], uri)
    document.CodeSpan(code) -> html.code([], [html.text(code)])
    document.EmailAutolink(mail:) -> anchor([html.text(mail)], mail)
    document.Emphasis(inlines) -> html.em([], list.map(inlines, render_inline))
    document.Footnote(..) -> panic as "Footnotes not yet supported"
    document.FullImage(..) -> panic as "Images not yet supported"
    document.FullLink(text:, data:) ->
      anchor(list.map(text, render_inline), case data.dest {
        document.Absolute(uri:) | document.Relative(uri:) -> uri
        document.Anchor(id:) -> "#" <> id
      })
    document.HardBreak -> html.br([])
    document.Highlight(inlines) ->
      html.mark([], list.map(inlines, render_inline))
    document.InlineFootnote(..) -> panic as "Inline footnotes not yet supported"
    document.InlineHtml(tag:, attrs:, children:) ->
      element.element(
        tag,
        dict.fold(attrs, [], fn(attrs, name, value) {
          [attribute(name, value), ..attrs]
        }),
        list.map(children, render_inline),
      )
    document.RawHtml(raw) -> component.raw_html(raw)
    document.RefImage(..) -> panic as "Images not yet supported"
    document.RefLink(..) -> panic as "Reference links not yet supported"
    document.SoftBreak -> html.text("\n")
    document.Strikethrough(inlines) ->
      html.span(
        [attribute.class("line-through")],
        list.map(inlines, render_inline),
      )
    document.Strong(inlines) ->
      html.strong([], list.map(inlines, render_inline))
    document.Text(text) -> html.text(text)
    document.Checkbox(..) -> panic as "Checkboxes not yet supported"
    document.Delim(..) -> panic as "Delimiters not yet supported"
  }
}

fn anchor(children: List(Element(a)), href: String) -> Element(a) {
  let target = case href {
    "http://" <> _ | "https://" <> _ -> "_blank"
    _ -> ""
  }
  html.a(
    [
      attribute.href(href),
      attribute.target(target),
      attribute.class("underline"),
    ],
    children,
  )
}
