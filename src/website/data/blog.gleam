import frontmatter
import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import gleam/option
import gleam/string
import gleam/time/calendar
import lustre/element
import simplifile
import tom.{type Toml}
import website/markdown

pub fn posts() -> List(Post(_)) {
  let assert Ok(files) = simplifile.read_directory("blog/")
  list.filter_map(files, fn(file) {
    use <- bool.guard(!string.ends_with(file, ".md"), Error(Nil))
    let file_path = "blog/" <> file
    let assert Ok(contents) = simplifile.read(file_path)

    let extracted = frontmatter.extract(contents)
    let assert Ok(metadata) =
      tom.parse(option.unwrap(extracted.frontmatter, ""))
    let contents = markdown.render(extracted.content)

    let title = get_string_key(metadata, "title")
    let description = get_string_key(metadata, "description")
    let assert Ok(date) = tom.get_date(metadata, ["date"])

    // Remove .md suffix
    let slug = string.drop_end(file, 3)

    Ok(Post(title:, slug:, date:, contents:, description:))
  })
  |> list.sort(fn(a, b) { calendar.naive_date_compare(b.date, a.date) })
}

fn get_string_key(toml: Dict(String, Toml), key: String) -> String {
  let assert Ok(value) = tom.get_string(toml, [key])
  value
}

pub type Post(a) {
  Post(
    title: String,
    slug: String,
    date: calendar.Date,
    description: String,
    contents: List(element.Element(a)),
  )
}
