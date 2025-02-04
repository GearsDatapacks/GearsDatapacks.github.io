import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import website/component
import website/data/projects.{type Project}

pub fn view(project: Project) -> Element(a) {
  component.page(project.title, [
    html.div([attribute.class("mx-auto max-w-3xl px-4 sm:px-6 lg:px-8")], [
      html.h1(
        [attribute.class("text-3xl font-bold leading-tight text-center")],
        [html.text(project.title)],
      ),
    ]),
    html.div([attribute.class("mx-auto max-w-4xl px-4 sm:px-6 lg:px-8")], [
      html.div([attribute.class("py-8 leading-8")], [
        html.p([attribute.class("text-xl")], [
          component.dangerous_html(project.description),
        ]),
      ]),
      component.dangerous_html(project.youtube),
      html.a(
        [
          attribute.href(project.download),
          attribute.class("text-blue-700"),
          attribute.target("_blank"),
        ],
        [html.text("Download the datapack")],
      ),
    ]),
  ])
}
