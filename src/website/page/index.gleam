import lustre/attribute.{attribute}
import lustre/element/html
import website/component

pub fn view() {
  component.page("Home", [
    html.div([attribute.class("mx-auto max-w-3xl")], [
      html.h1(
        [attribute.class("text-3xl font-bold leading-tight text-center")],
        [html.text("Hello and welcome to my website!")],
      ),
    ]),
    html.div(
      [attribute.class("mx-auto max-w-4xl py-8 leading-8")],
      [
        html.p([attribute.class("text-xl")], [
          html.text("I am Gears, a software developer and Minecraft YouTuber."),
          html.br([]),
          html.text("More about me in the "),
          html.a(
            [attribute.href("/about/"), attribute.class("underline font-bold")],
            [html.text("about")],
          ),
          html.text(" section."),
          html.br([]),
          html.text("You can check out my finished and ongoing projects in "),
          html.a(
            [
              attribute.href("/projects/"),
              attribute.class("underline font-bold"),
            ],
            [html.text("projects")],
          ),
          html.text("."),
          html.br([]),
          html.text("For information on Minecraft datapack commissions, see "),
          html.a(
            [
              attribute.href("/commissions/"),
              attribute.class("underline font-bold"),
            ],
            [html.text("commissions")],
          ),
          html.text("."),
          html.br([]),
          html.text("If you have more questions, you can "),
          html.a(
            [
              attribute.href("/contact/"),
              attribute.class("underline font-bold"),
            ],
            [html.text("contact me")],
          ),
          html.text("."),
        ]),
      ],
    ),
  ])
}
