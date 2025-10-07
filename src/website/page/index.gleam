import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import website/component
import website/page/about
import website/page/contact
import website/page/stuff

fn section() {
  component.text_page("Hello and welcome to my website!", [
    html.text(
      "My name is Surya, known online as Gears. I'm an amateur software developer, investigating functional programming, compilers and Minecraft datapacks.",
    ),
    html.br([]),
    html.text("More about me in the "),
    html.a([attribute.href("#about"), attribute.class("underline font-bold")], [
      html.text("about"),
    ]),
    html.text(" section."),
    html.br([]),
    html.text("You can check out my finished and ongoing projects in "),
    html.a(
      [attribute.href("#projects"), attribute.class("underline font-bold")],
      [html.text("projects")],
    ),
    html.text("."),
    html.br([]),
    html.text("If you have more questions, you can "),
    html.a(
      [attribute.href("#contact"), attribute.class("underline font-bold")],
      [html.text("contact me")],
    ),
    html.text("."),
  ])
}

pub fn view() -> Element(a) {
  component.page("Home", [section(), about.view(), contact.view(), stuff.view()])
}
