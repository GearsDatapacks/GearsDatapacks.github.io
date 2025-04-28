import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import gleam/string
import lustre/element
import lustre/ssg/djot
import simplifile
import tom.{type Toml}

pub type Category(a) {
  Category(title: String, path: String, projects: Dict(String, Project(a)))
}

fn categories() -> List(Category(a)) {
  let assert Ok(contents) = simplifile.read("projects/projects.toml")
  let assert Ok(toml) = tom.parse(contents)
  let assert Ok(categories) = tom.get_array(toml, ["categories"])
  use category <- list.map(categories)
  let assert tom.InlineTable(category) = category
  let assert Ok(title) = tom.get_string(category, ["title"])
  let assert Ok(path) = tom.get_string(category, ["path"])
  Category(title:, path:, projects: dict.new())
}

pub fn all() -> List(Category(a)) {
  use category <- list.map(categories())
  let assert Ok(files) = simplifile.read_directory("projects/" <> category.path)
  let projects =
    list.fold(files, category.projects, fn(projects, file) {
      use <- bool.guard(!string.ends_with(file, ".djot"), projects)
      let file_path = "projects/" <> category.path <> "/" <> file
      let assert Ok(contents) = simplifile.read(file_path)

      let assert Ok(metadata) = djot.metadata(contents)
      let contents = djot.render(contents, djot.default_renderer())

      let title = get_string_key(metadata, "title")
      let download = get_string_key(metadata, "download")
      let youtube = get_string_key(metadata, "youtube")
      // Remove .djot suffix
      let project_name = string.drop_end(file, 5)

      dict.insert(
        projects,
        project_name,
        Project(title:, download:, youtube:, contents:),
      )
    })
  Category(..category, projects:)
}

fn get_string_key(toml: Dict(String, Toml), key: String) -> String {
  let assert Ok(value) = dict.get(toml, key)
  let assert tom.String(value) = value
  value
}

pub type Project(a) {
  Project(
    title: String,
    download: String,
    youtube: String,
    contents: List(element.Element(a)),
  )
}
