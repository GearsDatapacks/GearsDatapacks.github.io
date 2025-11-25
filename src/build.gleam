import gleam/io
import gleam/list
import lustre/element
import lustre/ssg
import website/data/blog
import website/page/blog_home
import website/page/blog_post
import website/page/index

pub fn main() {
  let posts = blog.posts()

  let build =
    ssg.new("./priv")
    |> ssg.add_static_route("/", index.view())
    |> ssg.add_static_dir("./static")
    |> ssg.add_static_route("/blog/index", blog_home.view(posts))
    |> add_dynamic_routes(
      "/blog",
      posts,
      fn(post) { post.slug },
      blog_post.view,
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
  config: ssg.Config(ssg.HasStaticRoutes, a, b),
  path: String,
  list: List(data),
  slug: fn(data) -> String,
  view: fn(data) -> element.Element(msg),
) -> ssg.Config(ssg.HasStaticRoutes, a, b) {
  list.fold(list, config, fn(config, data) {
    ssg.add_static_route(
      config,
      path <> "/" <> slug(data) <> "/index",
      view(data),
    )
  })
}
