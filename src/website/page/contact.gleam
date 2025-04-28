import lustre/attribute
import lustre/element/html
import website/component

pub fn view() {
  component.text_page("Contact", "Contact me", [
    html.text(
      "If you have questions you want to ask, or want to reach out to me, you can send me an email at ",
    ),
    html.a(
      [
        attribute.class("font-bold text-orange-400"),
        attribute.href("mailto:gearsOfficial@proton.me"),
      ],
      [html.text("gearsOfficial@proton.me")],
    ),
    html.text(
      ",
    or join my ",
    ),
    html.a(
      [
        attribute.target("_blank"),
        attribute.class("underline text-blue-700"),
        attribute.href("https://discord.gg/fmPKDqf9ze"),
      ],
      [html.text("Discord server")],
    ),
    html.text("."),
  ])
}
