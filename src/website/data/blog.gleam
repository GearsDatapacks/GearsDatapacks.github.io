import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import gleam/string
import lustre/element
import lustre/ssg/djot
import simplifile
import tom.{type Toml}

pub fn posts() -> List(Post(a)) {
  let assert Ok(files) = simplifile.read_directory("blog/")

  list.filter_map(files, fn(file) {
    use <- bool.guard(!string.ends_with(file, ".djot"), Error(Nil))
    let file_path = "blog/" <> file
    let assert Ok(contents) = simplifile.read(file_path)

    let assert Ok(metadata) = djot.metadata(contents)
    let contents = djot.render(contents, djot.default_renderer())

    let title = get_string_key(metadata, "title")
    let description = get_string_key(metadata, "description")
    let date = get_string_key(metadata, "date")
    // Remove .djot suffix
    let slug = string.drop_end(file, 5)

    Ok(Post(title:, slug:, date:, contents:, description:))
  })
}

fn get_string_key(toml: Dict(String, Toml), key: String) -> String {
  let assert Ok(value) = dict.get(toml, key)
  let assert tom.String(value) = value
  value
}

pub type Post(a) {
  Post(
    title: String,
    slug: String,
    date: String,
    description: String,
    contents: List(element.Element(a)),
  )
}
