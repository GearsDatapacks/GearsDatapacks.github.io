import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import website/component
import website/component/footer

fn index() {
  component.text_page("Hello and welcome to my website!", [
    html.text(
      "My name is Surya, known online as Gears. I'm an amateur software developer, investigating functional programming, compilers and Minecraft datapacks.",
    ),
    html.br([]),
    html.text("I am currently part of the core team developing the "),
    html.a(
      [
        attribute.target("_blank"),
        attribute.class("font-bold hover:underline"),
        attribute.href("https://gleam.run"),
      ],
      [html.text("Gleam programming language")],
    ),
    html.text("."),
    html.br([]),
    html.text("I also have a "),
    html.a(
      [
        attribute.target("_blank"),
        attribute.class("font-bold hover:underline"),
        attribute.href("https://youtube.com/@Gearsdatapacks"),
      ],
      [html.text("YouTube channel")],
    ),
    html.text(
      ", where I you can watch my old videos on Minecraft datapacks, as well as videos covering changes to Gleam.",
    ),
    html.br([]),
    html.br([]),
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
        attribute.class("font-bold hover:underline"),
        attribute.href("https://discord.gg/fmPKDqf9ze"),
      ],
      [html.text("Discord server")],
    ),
    html.text("."),
  ])
}

pub fn view() -> Element(a) {
  component.page("Home", [index(), my_stuff()])
}

pub fn my_stuff() {
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
