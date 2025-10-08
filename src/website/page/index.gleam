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
    html.text("If you like what I do and want to support my work, you can "),
    html.a(
      [
        attribute.target("_blank"),
        attribute.class("font-bold hover:underline"),
        attribute.href("https://github.com/sponsors/GearsDatapacks"),
      ],
      [html.text("sponsor me on GitHub")],
    ),
    html.text("."),
  ])
}

pub fn view() -> Element(a) {
  component.page("Home", [index(), my_stuff()])
}

pub fn my_stuff() {
  component.text_page("My Stuff", [
    html.h2([attribute.class("text-2xl font-bold leading-tight my-2")], [
      element.text("Links"),
    ]),
    html.p([], list.map(footer.socials, social)),
    html.h2([attribute.class("text-2xl font-bold leading-tight my-2")], [
      element.text("Talks"),
    ]),
    html.p([], list.flat_map(talks, talk)),
  ])
}

const talks = [
  Talk(
    description: "Six to Sixteen: A Child's Programming Journey (Upcoming)",
    url: "https://2025.ffconf.org/surya",
    date: "14 November, 2025",
    conference: "FFConf 2025",
    location: "Duke of York's Cinema, Brighton",
  ),
  Talk(
    description: "Gleam core team panel (Upcoming)",
    url: "https://gleamgathering.com/#speakers",
    date: "21 February, 2026",
    conference: "Gleam Gathering",
    location: "Origin Workspace, Bristol",
  ),
]

type Talk {
  Talk(
    description: String,
    url: String,
    date: String,
    conference: String,
    location: String,
  )
}

fn talk(talk: Talk) -> List(Element(a)) {
  [
    html.a(
      [
        attribute.href(talk.url),
        attribute.target("_blank"),
        attribute.class("font-bold hover:underline text-xl"),
      ],
      [
        element.text(talk.description),
      ],
    ),
    html.br([]),
    element.text(
      talk.date <> " - " <> talk.conference <> " - " <> talk.location,
    ),
    html.br([]),
  ]
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
