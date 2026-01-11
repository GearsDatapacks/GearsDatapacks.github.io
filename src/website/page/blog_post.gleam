import gleam/int
import gleam/time/calendar
import lustre/attribute
import lustre/element
import lustre/element/html
import website/component
import website/data/blog

pub fn view(post: blog.Post(a)) -> element.Element(a) {
  let calendar.Date(year:, month:, day:) = post.date
  let date =
    int.to_string(day)
    <> " "
    <> calendar.month_to_string(month)
    <> ", "
    <> int.to_string(year)

  component.page(post.title, [
    component.text_page(post.title, [
      html.h2([attribute.class("date")], [
        element.text(date),
      ]),
      ..post.contents
    ]),
  ])
}
