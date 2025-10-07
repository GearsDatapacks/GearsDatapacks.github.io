import gleam/io
import lustre/ssg
import website/page/index

pub fn main() {
  let build =
    ssg.new("./priv")
    |> ssg.add_static_route("/", index.view())
    |> ssg.add_static_dir("./static")
    |> ssg.build

  case build {
    Ok(_) -> io.println("Build succeeded!")
    Error(e) -> {
      echo e
      io.println("Build failed!")
    }
  }
}
