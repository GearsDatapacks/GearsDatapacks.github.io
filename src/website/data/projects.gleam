import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import gleam/string
import simplifile
import tom.{type Toml}

pub type Category {
  Category(title: String, path: String, projects: Dict(String, Project))
}

fn categories() -> List(Category) {
  let assert Ok(contents) = simplifile.read("projects/projects.toml")
  let assert Ok(toml) = tom.parse(contents)
  let assert Ok(categories) = tom.get_array(toml, ["categories"])
  use category <- list.map(categories)
  let assert tom.InlineTable(category) = category
  let assert Ok(title) = tom.get_string(category, ["title"])
  let assert Ok(path) = tom.get_string(category, ["path"])
  Category(title:, path:, projects: dict.new())
}

pub fn all() -> List(Category) {
  use category <- list.map(categories())
  let assert Ok(files) = simplifile.read_directory("projects/" <> category.path)
  let projects =
    list.fold(files, category.projects, fn(projects, file) {
      use <- bool.guard(!string.ends_with(file, ".toml"), projects)
      let file_path = "projects/" <> category.path <> "/" <> file
      let assert Ok(contents) = simplifile.read(file_path)
      let assert Ok(toml) = tom.parse(contents)

      let title = get_string_key(toml, "title")
      let download = get_string_key(toml, "download")
      let youtube = get_string_key(toml, "youtube")
      let description = get_string_key(toml, "description")
      // Remove .toml suffix
      let project_name = string.drop_end(file, 5)

      dict.insert(
        projects,
        project_name,
        Project(title:, download:, youtube:, description:),
      )
    })
  Category(..category, projects:)
}

fn get_string_key(toml: Dict(String, Toml), key: String) -> String {
  let assert Ok(value) = dict.get(toml, key)
  let assert tom.String(value) = value
  value
}

pub type Project {
  Project(title: String, download: String, youtube: String, description: String)
}
