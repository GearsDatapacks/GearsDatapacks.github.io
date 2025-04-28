import gleam/dict.{type Dict}
import gleam/io
import gleam/list
import lustre/element.{type Element}
import lustre/ssg
import website/data/projects
import website/page/about
import website/page/contact
import website/page/index
import website/page/project
import website/page/projects as projects_page

pub fn main() {
  let categories = projects.all()

  let build =
    ssg.new("./priv")
    |> ssg.add_static_route("/", index.view())
    |> add_static_route("/about", about.view())
    |> add_static_route("/contact", contact.view())
    |> ssg.add_static_dir("./static")
    |> add_static_route("/projects", projects_page.view(categories))
    |> add_dynamic_routes(
      categories,
      project.view,
      fn(category: projects.Category(a)) {
        #("/projects/" <> category.path, category.projects)
      },
    )
    |> ssg.build

  case build {
    Ok(_) -> io.println("Build succeeded!")
    Error(e) -> {
      echo e
      io.println("Build failed!")
    }
  }
}

fn add_dynamic_routes(
  config: ssg.Config(a, b, c),
  list: List(d),
  view: fn(e) -> Element(f),
  map_fn: fn(d) -> #(String, Dict(String, e)),
) -> ssg.Config(a, b, c) {
  use config, element <- list.fold(list, config)
  let #(base, dict) = map_fn(element)
  ssg.add_dynamic_route(config, base, dict, view)
}

fn add_static_route(
  config: ssg.Config(a, b, c),
  route: String,
  view: Element(d),
) -> ssg.Config(ssg.HasStaticRoutes, b, c) {
  ssg.add_static_route(config, route <> "/index", view)
}
