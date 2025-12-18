import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import website/component
import website/data/blog

fn index() {
  component.text_page("Hello and welcome to my website!", [
    html.p(
      [
        attribute.class("big-p"),
      ],
      [
        html.text(
          "My name is Surya, known online as Gears. I'm an amateur software developer, investigating functional programming, compilers and Minecraft datapacks.",
        ),
        html.br([]),
        html.text("I am currently part of the core team developing the "),
        html.a(
          [
            attribute.target("_blank"),
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
            attribute.href("https://youtube.com/@Gearsdatapacks"),
          ],
          [html.text("YouTube channel")],
        ),
        html.text(
          ", where you can watch my old videos on Minecraft datapacks, as well as videos covering changes to Gleam.",
        ),
        html.br([]),
        html.br([]),
        html.text("If you like what I do and want to support my work, you can "),
        html.a(
          [
            attribute.target("_blank"),
            attribute.href("https://github.com/sponsors/GearsDatapacks"),
          ],
          [html.text("sponsor me on GitHub")],
        ),
        html.text("."),
      ],
    ),
  ])
}

pub fn view(posts: List(blog.Post(_))) -> Element(_) {
  component.page("Home", [index(), my_stuff(posts)])
}

pub fn my_stuff(posts: List(blog.Post(_))) -> component.Section(_) {
  component.text_page(
    "My Stuff",
    list.flatten([
      [
        html.h2([], [
          element.text("Links"),
        ]),
        html.p([], list.map(socials, social)),
        html.h2([], [
          element.text("Posts"),
        ]),
      ],
      list.map(posts, post),
      [
        html.h2([], [
          element.text("Talks"),
        ]),
      ],
      list.map(talks, talk),
    ]),
  )
}

fn post(post: blog.Post(_)) -> element.Element(_) {
  html.div([], [
    html.a(
      [
        attribute.href("/blog/" <> post.slug),
        attribute.class("big-link"),
      ],
      [html.text(post.title)],
    ),
    html.br([]),
    html.span([attribute.class("bold")], [html.text(post.human_date)]),
    html.text(" - " <> post.description),
  ])
}

const talks = [
  Talk(
    description: "Optimising the hell out of Gleam (Upcoming)",
    url: "https://gleamgathering.com/#speakers",
    date: "21 February, 2026",
    conference: "Gleam Gathering",
    location: "Origin Workspace, Bristol",
  ),
  Talk(
    description: "Panel: Chat with Gleam core team (Upcoming)",
    url: "https://gleamgathering.com/#speakers",
    date: "21 February, 2026",
    conference: "Gleam Gathering",
    location: "Origin Workspace, Bristol",
  ),
  Talk(
    description: "Six to Sixteen: A Child's Programming Journey (Recording)",
    url: "https://www.youtube.com/watch?v=anF9c2zq1BM",
    date: "14 November, 2025",
    conference: "FFConf 2025",
    location: "Duke of York's Cinema, Brighton",
  ),
]

type Social {
  Social(icon: String, name: String, url: String, description: String)
}

const socials = [
  Social(
    icon: "youtube.png",
    name: "YouTube",
    url: "https://youtube.com/@GearsDatapacks",
    description: "Videos on Minecraft Datapacks and Gleam",
  ),
  Social(
    icon: "github.png",
    name: "Github",
    url: "https://github.com/GearsDatapacks",
    description: "All my projects",
  ),
  Social(
    icon: "bluesky.svg",
    name: "Bluesky",
    url: "https://bsky.app/profile/gearsco.de",
    description: "Random social media posting",
  ),
  Social(
    icon: "twitch.png",
    name: "Twitch",
    url: "https://twitch.tv/gearsdatapacks",
    description: "Occasional programming livestreams",
  ),
  Social(
    icon: "modrinth.svg",
    name: "Modrinth",
    url: "https://modrinth.com/user/GearsDatapacks",
    description: "Minecraft datapacks",
  ),
  Social(
    icon: "discord.png",
    name: "Discord",
    url: "https://discord.gg/fmPKDqf9ze",
    description: "Discord Server",
  ),
  Social(
    icon: "hex.png",
    name: "Hex",
    url: "https://hex.pm/users/Gears",
    description: "Gleam libraries",
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

fn talk(talk: Talk) -> Element(_) {
  html.p([attribute.class("talk")], [
    html.a(
      [
        attribute.href(talk.url),
        attribute.target("_blank"),
        attribute.class("big-link"),
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
  ])
}

fn social(social: Social) -> Element(_) {
  html.a(
    [
      attribute.href(social.url),
      attribute.target("_blank"),
      attribute.class("social"),
    ],
    [
      html.img([
        attribute.src("/images/" <> social.icon),
        attribute.alt(social.name),
        attribute.title(social.name),
        attribute.width(48),
      ]),
      element.text(social.description),
      html.br([]),
    ],
  )
}
