import lustre/element.{type Element}
import website/component
import website/data/projects.{type Category, type Project}

pub fn view(categories: List(Category)) -> Element(a) {
  component.page("Projects", [])
}
