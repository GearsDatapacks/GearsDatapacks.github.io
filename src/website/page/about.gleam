import lustre/attribute
import lustre/element/html
import website/component

pub fn view() {
  component.text_page("About", "About me", [
    html.span([attribute.class("font-bold")], [
      html.text("I'm Gears, an amateur software developer, and general nerd."),
    ]),
    html.br([]),
    html.text(
      "I love programming languages. I am currently part of the core team developing the ",
    ),
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
    html.text(
      "Projects I've made include a programming language with Minecraft datapacks, and a Datapack Package Manager.",
    ),
    html.br([]),
    html.text("More information on the "),
    html.a(
      [
        attribute.class("font-bold hover:underline"),
        attribute.href("/projects/"),
      ],
      [html.text("projects")],
    ),
    html.text(" page."),
  ])
}
