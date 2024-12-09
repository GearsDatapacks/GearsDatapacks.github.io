import lustre/attribute.{attribute}
import lustre/element/html
import website/components

pub fn view() {
  components.page("Home", [
    html.main([], [
      html.div([], [
        html.h1([], [html.text("Hello and welcome to my website!")]),
      ]),
      html.div([], [
        html.p([], [
          html.text("I am Gears, a software developer and Minecraft YouTuber."),
          html.br([]),
          html.text("More about me in the "),
          html.a([attribute.href("/about/")], [html.text("about")]),
          html.text(" section."),
          html.br([]),
          html.text("You can check out my finished and ongoing projects in "),
          html.a([attribute.href("/projects/")], [html.text("projects")]),
          html.text("."),
          html.br([]),
          html.text("For information on Minecraft datapack commissions, see "),
          html.a([attribute.href("/commissions/")], [html.text("commissions")]),
          html.text("."),
          html.br([]),
          html.text("If you have more questions, you can "),
          html.a([attribute.href("/contact/")], [html.text("contact me")]),
          html.text("."),
        ]),
      ]),
    ]),
  ])
}
