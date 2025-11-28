import filepath as path
import gleam/io
import gleam/list
import lustre/element
import simplifile as file
import website/data/blog
import website/page/blog_post
import website/page/index

const out_dir = "./priv"

pub fn main() {
  let posts = blog.posts()

  let assert Ok(Nil) = file.delete(out_dir)
  let assert Ok(Nil) = file.copy_directory("./static", out_dir)
  create_page("/", index.view(posts))
  list.each(posts, fn(post) {
    create_page("blog/" <> post.slug, blog_post.view(post))
  })

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
