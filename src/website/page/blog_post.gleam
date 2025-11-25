import lustre/attribute
import lustre/element
import lustre/element/html
import website/component
import website/data/blog

pub fn view(post: blog.Post(a)) -> element.Element(a) {
  component.page(post.title, [
    component.text_page(post.title, [
      html.h2([attribute.class("text-xl font-bold text-center m-0")], [
        element.text(post.date),
      ]),
      ..post.contents
    ]),
  ])
}
