import website/page/contact
import website/page/commissions
import gleam/io
import lustre/ssg
import website/page/about
import website/page/index

pub fn main() {
  // let posts =
  //   dict.from_list({
  //     use post <- list.map(posts.all())
  //     #(post.id, post)
  //   })

  let build =
    ssg.new("./priv")
    |> ssg.add_static_route("/", index.view())
    |> ssg.add_static_route("/about", about.view())
    |> ssg.add_static_route("/commissions", commissions.view())
    |> ssg.add_static_route("/contact", contact.view())
    |> ssg.add_static_dir("./static")
    // |> ssg.add_static_route("/blog", blog.view(posts.all()))
    // |> ssg.add_dynamic_route("/blog", posts, post.view)
    |> ssg.build

  case build {
    Ok(_) -> io.println("Build succeeded!")
    Error(e) -> {
      io.debug(e)
      io.println("Build failed!")
    }
  }
}
