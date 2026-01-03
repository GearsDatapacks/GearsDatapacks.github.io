import birl
import filepath as path
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import lustre/element
import simplifile as file
import webls/rss
import website/data/blog
import website/page/blog_post
import website/page/index

const out_dir = "./priv"

pub fn main() {
  let posts = blog.posts()

  case file.is_directory(out_dir) {
    Ok(True) -> {
      let assert Ok(Nil) = file.delete(out_dir)
      Nil
    }
    Ok(False) -> Nil
    Error(_) -> panic
  }
  let assert Ok(Nil) = file.copy_directory("./static", out_dir)
  create_page("/", index.view(posts))
  list.each(posts, fn(post) {
    create_page("blog/" <> post.slug, blog_post.view(post))
  })

  let channel =
    rss.channel(
      "Gears' Blog",
      "Blog about programming and Gleam",
      "https://gearsco.de",
    )
    |> rss.with_channel_language("en-gb")
    |> rss.with_channel_docs
    |> rss.with_channel_items(
      list.map(posts, fn(post) {
        let assert [year, month, day] =
          post.date |> string.split("-") |> list.filter_map(int.parse)

        rss.item(post.title, post.description)
        |> rss.with_item_link("https://gearsco.de/blog/" <> post.slug)
        |> rss.with_item_pub_date(
          birl.from_erlang_universal_datetime(
            #(#(year, month, day), #(0, 0, 0)),
          ),
        )
      }),
    )

  write_file(
    write: rss.to_string([channel]),
    to: path.join(out_dir, "blog.xml"),
  )

  io.println("Build succeeded!")
}

fn create_page(path: String, element: element.Element(a)) -> Nil {
  let path = case path {
    "/" <> path -> path
    _ -> path
  }
  let path = out_dir |> path.join(path) |> path.join("index.html")
  write_file(path, element.to_document_string(element))
}

fn write_file(to path: String, write contents: String) -> Nil {
  let assert Ok(Nil) = file.create_directory_all(path.directory_name(path))
  let assert Ok(Nil) = file.write(contents, to: path)
  Nil
}
