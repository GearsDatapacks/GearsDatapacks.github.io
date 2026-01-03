import contour
import gleam/list
import gleam/option.{type Option, Some}
import gleam/string
import global_value
import lustre/attribute
import lustre/element
import lustre/element/html
import pearl
import splitter

fn diff_splitter() -> splitter.Splitter {
  use <- global_value.create_with_unique_name("website/highlight.diff_splitter")
  splitter.new(["\n+", "\n-"])
}

pub fn highlight(code: String, language: Option(String)) -> element.Element(_) {
  case language {
    Some("diff-" <> language) ->
      highlight_diff(code, language, diff_splitter(), []) |> html.span([], _)
    Some("erlang") | Some("erl") ->
      element.unsafe_raw_html("", "span", [], pearl.highlight_html(code))
    Some("gleam") ->
      element.unsafe_raw_html("", "span", [], contour.to_html(code))
    _ -> html.text(code)
  }
}

fn highlight_diff(
  code: String,
  language: String,
  splitter: splitter.Splitter,
  list: List(element.Element(a)),
) -> List(element.Element(_)) {
  case splitter.split(splitter, code) {
    #(before, "\n+", after) -> {
      case string.split_once(after, "\n") {
        Ok(#(added, rest)) ->
          highlight_diff("\n" <> rest, language, splitter, [
            html.span([attribute.class("hl-added")], [
              html.text("\n+"),
              highlight(added, Some(language)),
            ]),
            highlight(before, Some(language)),
            ..list
          ])
        Error(Nil) ->
          list.reverse([
            html.span([attribute.class("hl-added")], [
              html.text("\n+"),
              highlight(after, Some(language)),
            ]),
            highlight(before, Some(language)),
            ..list
          ])
      }
    }
    #(before, "\n-", after) -> {
      case string.split_once(after, "\n") {
        Ok(#(removed, rest)) ->
          highlight_diff("\n" <> rest, language, splitter, [
            html.span([attribute.class("hl-removed")], [
              html.text("\n-"),
              highlight(removed, Some(language)),
            ]),
            highlight(before, Some(language)),
            ..list
          ])
        Error(Nil) ->
          list.reverse([
            html.span([attribute.class("hl-removed")], [
              html.text("\n-"),
              highlight(after, Some(language)),
            ]),
            highlight(before, Some(language)),
            ..list
          ])
      }
    }
    #(code, _, _) -> list.reverse([highlight(code, Some(language)), ..list])
  }
}
