import lustre/attribute
import lustre/element/html
import website/component

pub fn view() {
  component.text_page("Home", "Hello and welcome to my website!", [
    html.text(
      "I am Gears, an amateur software developer, investigating functional programming, compilers and Minecraft datapacks.",
    ),
    html.br([]),
    html.text("More about me in the "),
    html.a([attribute.href("/about/"), attribute.class("underline font-bold")], [
      html.text("about"),
    ]),
    html.text(" section."),
    html.br([]),
    html.text("You can check out my finished and ongoing projects in "),
    html.a(
      [attribute.href("/projects/"), attribute.class("underline font-bold")],
      [html.text("projects")],
    ),
    html.text("."),
    html.br([]),
    html.text("If you have more questions, you can "),
    html.a(
      [attribute.href("/contact/"), attribute.class("underline font-bold")],
      [html.text("contact me")],
    ),
    html.text("."),
  ])
}
