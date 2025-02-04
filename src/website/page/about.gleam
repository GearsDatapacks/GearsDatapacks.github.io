import lustre/attribute.{attribute}
import lustre/element/html
import website/component

pub fn view() {
  component.text_page("About", "About me", [
    html.span([attribute.class("text-2xl font-bold")], [
      html.text(
        "I'm Gears; a programmer, Minecraft enthusiast, YouTuber and nerd.",
      ),
    ]),
    html.br([]),
    html.br([]),
    html.text(
      "The programming language I know most about, and therefore use the most, is JavaScript/TypeScript. However, I also know Ruby, MCFunction and Golang, and dabble in Rust and Python.",
    ),
    html.br([]),
    html.text("I make "),
    html.a(
      [
        attribute.target("_blank"),
        attribute.class("text-blue-500 underline"),
        attribute.href("https://youtube.com/@Gearsdatapacks"),
      ],
      [html.text("YouTube videos")],
    ),
    html.text(
      " about my ongoing struggle with Minecraft datapacks, as well as other fun Minecraft content.",
    ),
    html.br([]),
    html.text(
      "Projects I've made include a programming language with Minecraft datapacks (not alone), and a Datapack Package Manager.",
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
    html.text("page."),
  ])
}
