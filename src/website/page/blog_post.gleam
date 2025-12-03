import lustre/attribute
import lustre/element
import lustre/element/html
import website/component
import website/data/blog

pub fn view(post: blog.Post(a)) -> element.Element(a) {
  component.page(post.title, [
    component.text_page(post.title, [
      html.h2([attribute.class("date")], [
        element.text(post.human_date),
      ]),
      ..post.contents
    ]),
  ])
}
