import lustre/attribute.{attribute}
import lustre/element/html
import website/component

pub fn view() {
  component.text_page("Commissions", "Datapack commissions", [
    html.text(
      "Among other things, I make paid datapacks for people.
If you would like me to make you a datapack, please ",
    ),
    html.a(
      [
        attribute.class("hover:underline font-bold"),
        attribute.href("/contact/"),
      ],
      [html.text("contact me")],
    ),
    html.text("."),
    html.span([attribute.class("absolute right-10 bottom-20 text-slate-800")], [
      html.text("Hi :)"),
    ]),
  ])
}
