import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import website/component
import website/component/footer

pub fn view() {
  component.text_page("My Stuff", [
    html.h2([attribute.class("text-2xl font-bold leading-tight")], [
      element.text("Links"),
    ]),
    html.p([], list.map(footer.socials, social)),
  ])
}

fn social(social: footer.Social) -> Element(a) {
  html.a([attribute.href(social.url), attribute.target("_blank")], [
    html.img([
      attribute.src("/images/" <> social.icon),
      attribute.alt(social.name),
      attribute.title(social.name),
      attribute.class("w-icon inline m-1"),
    ]),
    element.text(social.description),
    html.br([]),
  ])
}
