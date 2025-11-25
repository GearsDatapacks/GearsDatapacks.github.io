import gleam/list
import lustre/attribute
import lustre/element
import lustre/element/html
import website/component
import website/data/blog

pub fn view(posts: List(blog.Post(_))) -> element.Element(_) {
  component.page("Blog", [
    component.text_page("My Blog", list.map(posts, post)),
  ])
}

fn post(post: blog.Post(_)) -> element.Element(_) {
  html.div([], [
    html.a(
      [attribute.href("/blog/" <> post.slug), attribute.class("underline")],
      [
        html.h2([attribute.class("text-xl font-bold")], [
          element.text(post.title),
        ]),
      ],
    ),
    html.span([attribute.class("text-sm")], [element.text(post.date)]),
    html.p([attribute.class("text-lg")], [element.text(post.description)]),
  ])
}
