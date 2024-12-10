import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

type Social {
  Social(icon: String, name: String, url: String)
}

const socials = [
  Social(icon: "youtube.png", name: "YouTube", url: "https://youtube.com/@GearsDatapacks"),
  Social(icon: "github.png", name: "Github", url: "https://github.com/GearsDatapacks"),
  Social(icon: "bluesky.svg", name: "Bluesky", url: "https://bsky.app/profile/gearsco.de"),
  Social(icon: "modrinth.svg", name: "Modrinth", url: "https://modrinth.com/user/GearsDatapacks"),
  Social(icon: "discord.png", name: "Discord", url: "https://discord.gg/fmPKDqf9ze"),
]

pub fn view() -> Element(a) {
  html.footer(
    [
      attribute.class(
        "right-3 bottom-3 fixed h-16 bg-blue-900 p-3.5 flex flex-row gap-4 items-center overflow-hidden rounded-full",
      ),
    ],
    list.map(socials, fn(social) {
      html.a(
        [
          attribute.href(social.url),
          attribute.target("_blank"),
          attribute.class("shrink-0"),
        ],
        [
          html.img([
            attribute.src("/images/" <> social.icon),
            attribute.alt(social.name),
            attribute.title(social.name),
            attribute.class("w-icon"),
          ]),
        ],
      )
    }),
  )
}
