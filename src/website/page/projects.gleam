import gleam/dict
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import website/component
import website/data/projects.{type Category, type Project}

pub fn view(categories: List(Category(a))) -> Element(a) {
  component.text_page(
    "Projects",
    "My Projects",
    list.flat_map(categories, fn(category) {
      [
        html.h1([attribute.class("text-4xl font-bold text-center p-4 pb-8")], [
          html.text(category.title),
        ]),
        html.div(
          [
            attribute.class(
              "grid grid-cols-1 tab:grid-cols-2 lg:grid-cols-3 2xl:grid-cols-4 hd:grid-cols-5 gap-96",
            ),
          ],
          category.projects
            |> dict.to_list
            |> list.map(fn(pair) {
              format_project(category.path, pair.0, pair.1)
            }),
        ),
      ]
    }),
  )
}

fn format_project(
  category: String,
  id: String,
  project: Project(a),
) -> Element(a) {
  html.a([attribute.href("/projects/" <> category <> "/" <> id)], [
    html.div(
      [
        attribute.class(
          "w-64 h-64 xs:w-80 xs:h-80 bg-blue-900 rounded-3xl overflow-hidden transition-transform duration-200 hover:scale-105 hover:shadow-2xl shadow-black",
        ),
      ],
      [
        html.img([
          attribute.class("max-h-56"),
          attribute.alt(project.title),
          attribute.src("/images/projects/" <> id <> ".png"),
        ]),
        html.p([attribute.class("text-center py-1.5 text-3xl font-bold")], [
          html.text(project.title),
        ]),
      ],
    ),
  ])
}
