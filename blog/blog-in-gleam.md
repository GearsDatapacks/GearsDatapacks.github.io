---
title = "Building a Blog in Gleam"
date = 2026-01-20
description = """2026 is the year of blog posts, or so I hear. The thing is, there are so many
options that you can use to make your blog, many of which are very complicated
and feature rich — and sometimes you just want to start writing, and not have to
deal with all that complexity."""
---

2026 is the year of blog posts, or so I hear. The thing is, there are so many
options that you can use to make your blog, many of which are very complicated
and feature rich — and sometimes you just want to start writing, and not have to
deal with all that complexity.

That's what this is — an alternative to all the complicated frameworks out there,
a nice simple starting point which you can expand to your heart's desire, or
leave as is. Written in Gleam.

The code demonstrated in this article is a simplified version of what is
[powering the blog you are reading right now](https://github.com/GearsDatapacks/GearsDatapacks.github.io).

This article assumes a [basic knowledge of Gleam](https://tour.gleam.run).

## Table of contents
- [Setting up the project](#setting-up-the-project)
- [Hooking up blog posts](#hooking-up-blog-posts)
- [Linking to our posts](#linking-to-our-posts)
- [Adding styling and images](#adding-styling-and-images)
- [Adding an RSS feed](#adding-an-rss-feed)
- [Deploying](#deploying)
- [Conclusion](#conclusion)
---

## Setting up the project

Let's get started by setting up a project. We'll add a few dependencies to begin:
[`lustre`](https://hexdocs.pm/lustre), [`simplifile`](https://hexdocs.pm/simplifile)
and [`filepath`](https://hexdocs.pm/filepath). We'll add more dependencies later.

```shell
$ gleam new blog
$ cd blog
$ gleam add lustre simplifile filepath
```

**Note**: You can also use [`lustre_ssg`](https://hexdocs.pm/lustre_ssg) for
this, as I did when I started out. I ended up switching to a custom build
system as it gave me more flexibility, and it's about the same amount of code so
I decided to show that here instead.

Since we're building a static website, our Gleam code only gets run at build time.
Once we're viewing it in browser, it's just static HTML, CSS and other files.

`blog.gleam` will be our entrypoint, and that's where we'll implement our build
script. Let's start off with a baseline:

```gleam
import filepath
import gleam/io
import lustre/element
import lustre/element/html
import simplifile

// Where to output the built website. This can be anywhere you like.
const out_directory = "./out"

// View for our home page.
fn index() -> element.Element(_) {
  html.h1([], [html.text("Hello, and welcome to my blog!")])
}

pub fn main() -> Nil {
  let index_page = element.to_document_string(index())

  // Ensure our output directory exists. Since this is a build script, crashing
  // on an error is probably fine.
  let assert Ok(Nil) = simplifile.create_directory_all(out_directory)

  // Write the index page to our file system.
  let assert Ok(Nil) =
    simplifile.write(filepath.join(out_directory, "index.html"), index_page)

  io.println("Build succeeded!")
}
```

If we run this, we should see a `Build succeeded!` message in the terminal, and
an `out` directory should appear, with a single `index.html` file in it. If we
open it, we get a nice greeting as we specified.

## Hooking up blog posts

Now we have our main page, we can work on creating blog posts. We will have a
directory containing our blog files, and our build script will convert those to
HTML and put it into our site. I like to use Markdown for writing blog posts, but
you could use [Djot](https://djot.net/) instead.

Let's start by creating our first blog post. I'm going to put it in a directory
called `blog`, but you can choose whatever you want. Then, we can make a `test.md`
file, and put some content in it:

```md
# This is my first blog post!

Some content will eventually be here...
```

Now we need to set up the code to turn our blog into a page on our site. First
we need to add a new dependency: I'm using [`mork`](https://hexdocs.pm/mork) for
Markdown parsing, but use [`jot`](https://hexdocs.pm/jot) instead if you wish.

```shell
$ gleam add mork
```

Next, we can implement our blog finding function:

```gleam
import mork

// [...]

const blog_directory = "./blog"

type BlogPost {
  BlogPost(
    /// The part of the URL to identify this blog post. The URL will look
    /// something like https://blog.me/<slug>.html
    slug: String,
    /// The contents of the blog post as HTML
    contents: String,
  )
}

fn collect_blog_posts() -> List(BlogPost) {
  let assert Ok(posts) = simplifile.get_files(blog_directory)

  list.map(posts, fn(post) {
    let path = filepath.join(blog_directory, post)
    let slug = filepath.strip_extension(post)

    let assert Ok(contents) = simplifile.read(path)
    let contents_as_html = contents |> mork.parse |> mork.to_html

    BlogPost(slug:, contents: contents_as_html)
  })
}
```

Now that we have a basic function to turn our files into HTML, we need to write
that HTML to a file so it forms part of our website:

```gleam
// [...]

pub fn main() {
  // [...]

  let blog_posts = collect_blog_posts()

  list.each(blog_posts, fn(post) {
    let path = filepath.join(out_directory, post.slug <> ".html")

    let html_document =
      "<!doctype html>\n<html><body>" <> post.contents <> "</body></html>"

    let assert Ok(Nil) = simplifile.write(path, html_document)
  })

  io.println("Build succeeded!")
}
```

The `element.to_document_string` function gives us a full HTML document, but
`mork.to_html` doesn't, so we need to add on the `doctype` etc. ourselves.

Running this, we should see a new file in our `out` directory, called `test.html`.
Opening that up in a browser should show a heading and a paragraph, as in our
MD file.

**Note**: I've used `mork`'s builtin `to_html` function to convert our
Markdown to HTML. This works fine, but for more customisation you can also write
your own conversion function, like I have done for
[my website](https://github.com/GearsDatapacks/GearsDatapacks.github.io/blob/main/src/website/markdown.gleam).
It's a lot of boilerplate though, so I have omitted it in this post for brevity.

## Linking to our posts

So we have our blog post pages generated, but currently they just exist in the
aether, with no way to access them if you don't already know they are there. It
would be great if our home page kept a list of blog posts which we didn't need
to update manually. So let's do that!

First off, we will need to modify our blog post files a little. Currently they
just contain markdown content, but we will need a bit more information about the
post to display on the home page, such as the title, creation date, and a short
description of the post.

To do this, we will use **frontmatter**, which is extra info included at the
beginning of a file which is not rendered as part of the document. We will need
three more packages: [`frontmatter`](https://hexdocs.pm/frontmatter), for extracting
the frontmatter from the rest of the document, [`tom`](https://hexdocs.pm/tom),
for parsing [TOML](https://toml.io/en/), the config format that we will use, and
[`gleam_time`](https://hexdocs.pm/gleam_time) for handling date and time.

```shell
$ gleam add frontmatter tom gleam_time
```

Next, lets add some frontmatter to our test post so we can read it from our home
page script. Frontmatter is delimited by `---`:

```md
---
title = "Test post"
date = 2026-01-20
description = "A little post to test our system"
---

[...]
```

I've gone for three fields here: `title`, `date` and `description`. If we wanted
to, we could extract the title and description from the markdown itself, but I
prefer to be explicit about it. You can also add any other fields you would like,
such as the author of the post or some tags to categorise it.

Great, now we need to extract that data from the file when we are indexing our
posts. First, we need to add the new fields to our `BlogPost` type:

```diff-gleam
type BlogPost {
  BlogPost(
    /// The part of the URL to identify this blog post. The URL will look
    /// something like https://blog.me/<slug>.html
    slug: String,
    /// The contents of the blog post as HTML
    contents: String,
+    title: String,
+    description: String,
+    date: calendar.Date,
  )
}
```

Next, we need to use the `frontmatter` and `tom` packages to extract the metadata:

```diff-gleam
import frontmatter
import gleam/time/calendar
import tom

// [...]

fn collect_blog_posts() -> List(BlogPost) {
  let assert Ok(posts) = simplifile.get_files(blog_directory)

  list.map(posts, fn(post) {
    let slug = filepath.strip_extension(filepath.base_name(post))

    let assert Ok(contents) = simplifile.read(post)

+    let assert frontmatter.Extracted(
+      frontmatter: option.Some(frontmatter),
+      content:,
+    ) = frontmatter.extract(contents)
+    let html_content = content |> mork.parse |> mork.to_html
+
+    let assert Ok(metadata) = tom.parse(frontmatter)
+    let assert Ok(title) = tom.get_string(metadata, ["title"])
+    let assert Ok(description) = tom.get_string(metadata, ["description"])
+    let assert Ok(date) = tom.get_date(metadata, ["date"])

-    BlogPost(slug:, contents: html_content)
+    BlogPost(slug:, contents: html_content, title:, description:, date:)
  })
}
```

We also probably want to sort our blog posts by release date. I will sort them
from newest to oldest, so more recent posts appear at the top. For the other way
around, simply swap the arguments to `naive_date_compare`.

```diff-gleam
fn collect_blog_posts() -> List(BlogPost) {
  let assert Ok(posts) = simplifile.get_files(blog_directory)

  list.map(posts, fn(post) {
    // [...]
  })
+  |> list.sort(fn(a, b) { calendar.naive_date_compare(b.date, a.date) })
}
```

Now that we have the required data, we can add it to the home page:

```gleam
fn index(posts: List(BlogPost)) -> element.Element(_) {
  html.main([], [
    html.h1([], [html.text("Hello, and welcome to my blog!")]),
    ..list.map(posts, post)
  ])
}

fn post(post: BlogPost) -> element.Element(_) {
  let url = "/" <> post.slug <> ".html"
  let date =
    int.to_string(post.date.day)
    <> " "
    <> calendar.month_to_string(post.date.month)
    <> ", "
    <> int.to_string(post.date.year)

  html.div([], [
    html.h2([], [html.a([attribute.href(url)], [html.text(post.title)])]),
    html.span([], [html.text(date)]),
    html.span([], [html.text(" - ")]),
    html.span([], [html.text(post.description)]),
  ])
}
```

Then we just need to call our `index` function with the blog post data:

```diff-gleam
pub fn main() -> Nil {
-  let index_page = element.to_document_string(index())
+  let blog_posts = collect_blog_posts()
+  let index_page = element.to_document_string(index(blog_posts))

  // Ensure our output directory exists. Since this is a build script, crashing
  // on an error is probably fine.
  let assert Ok(Nil) = simplifile.create_directory_all(out_directory)

  // Write the index page to our file system.
  let assert Ok(Nil) =
    simplifile.write(filepath.join(out_directory, "index.html"), index_page)

-  let blog_posts = collect_blog_posts()

  // [...]
}
```

And voila! We now have a list of blog posts on our home page!

## Adding styling and images

So our website is working great now, but it looks a bit dull, with absolutely
no styling. You might also want to add images, to illustrate something in a blog
post, or an icon for the website.

For styling, you have two main options: [Tailwind](https://tailwindcss.com/) and
plain ol' CSS. For Tailwind, there's nothing special you need to do for Gleam.
Simply add tailwind using `npm`, and run the CLI after adding any classes to the
page that you want. More details in the Tailwind docs.

For static CSS and images, it's even simpler: Just create a directory. I'm going
to call mine `static`. I'll create a `style.css` to put some styles in:

```css
body {
  background-color: rgb(30 41 59);
  color: white;
}

a {
  font-weight: bold;
  color: white;
}
```

You'll of course want more than this, but I can't include a full stylesheet here.

Now let's make sure all our static assets get copied to the output directory:

```diff-gleam
// [...]

// Where to output the built website. This can be anywhere you like.
const out_directory = "./out"

+// Directory containing our static assets
+const static_directory = "./static"

// [...]

pub fn main() -> Nil {
  let blog_posts = collect_blog_posts()
  let index_page = element.to_document_string(index(blog_posts))

+  // Delete old output directory to ensure no files are left over
+  let _ = simplifile.delete(out_directory)
+  // Copy all our static assets to the output directory
+  let assert Ok(Nil) =
+    simplifile.copy_directory(static_directory, out_directory)

-  // Ensure our output directory exists. Since this is a build script, crashing
-  // on an error is probably fine.
-  let assert Ok(Nil) = simplifile.create_directory_all(out_directory)

  // Write the index page to our file system.
  let assert Ok(Nil) =
    simplifile.write(filepath.join(out_directory, "index.html"), index_page)

  // [...]
}
```

Now, when we `gleam run`, there should be a new `style.css` file in our `out`
directory! We just need to reference it from our pages.

```diff-gleam
pub fn main() -> Nil {
  let blog_posts = collect_blog_posts()
-  let index_page = element.to_string(index(blog_posts))
+  let index_page = page(element.to_string(index(blog_posts)))

  // [...]

  list.each(blog_posts, fn(post) {
    let path = filepath.join(out_directory, post.slug <> ".html")

-    let html_document =
-      "<!doctype html>\n<html><body>" <> post.contents <> "</body></html>"
-    let assert Ok(Nil) = simplifile.write(path, html_document)
+    let assert Ok(Nil) = simplifile.write(path, page(post.contents))
  })

  io.println("Build succeeded!")
}

fn page(contents: String) -> String {
  "<!doctype html><html>
<head><link rel=\"stylesheet\" href=\"/style.css\" /></head>
<body>" <> contents <> "</body>
</html>"
}
```

And now, all our pages will follow our stylesheet. If you like, you can customise
this more, so that, for example, you have a different style for your posts as the
home page.

Any images you want to add can simply be put in the `static` directory, and
referenced normally from any part of the website.

## Adding an RSS feed

The last feature we need for our blog is an [RSS feed](https://en.wikipedia.org/wiki/RSS),
so that people using [RSS readers](https://en.wikipedia.org/wiki/News_aggregator)
can read our blog. This is entirely optional, but a nice feature for our readers.

We need one final library to build the RSS feed, [`webls`](https://hexdocs.pm/webls):

```shell
$ gleam add webls
```

```diff-gleam
import webls/rss

// [...]

pub fn main() -> Nil {
  // [...]

+  let feed = build_feed(blog_posts)
+  let assert Ok(Nil) = simplifile.write("feed.xml", rss.to_string([feed]))

  io.println("Build succeeded!")
}

fn build_feed(blog_posts: List(BlogPost)) -> rss.RssChannel {
  let items =
    list.map(blog_posts, fn(post) {
      let url = "https://blog.me/" <> post.slug <> ".html"

      rss.item(post.title, post.description)
      |> rss.with_item_link(url)
      |> rss.with_item_pub_date(timestamp.from_calendar(
        post.date,
        // If you want to add more precise timings to publishing dates you can,
        // but I since our `date` field only contains the day, we just assume
        // midnight.
        calendar.TimeOfDay(0, 0, 0, 0),
        calendar.utc_offset,
      ))
    })

  rss.channel("My Blog", "Blog about interesting stuff", "https://blog.me")
  |> rss.with_channel_items(items)
}
```

That's it! We build the feed, and write it to a file called `feed.xml`. You can
call this anything you want, but `feed.xml` is a common name. And of course make
sure to replace `blog.me` with your actual domain.

That's it! Once your website is published, anyone can put `https://yoursite.com/feed.xml`
into their RSS reader and get your updates from your blog.

There are more fields you can add to both the `Channel` and `Item`, what is given
here is just the bare minimum. See the [RSS specification](http://rssboard.org/rss-specification)
for more information.

## Deploying

That's it! We now have our fully functional website. The last thing we need to
do is deploy it to the internet so that other people can see it! There are many
options on how to do this, and I won't go into them all here.

Since our website just builds static HTML, it's really easy to upload basically
anywhere. You just need some kind of script that runs the Gleam program, and
copies the output files to wherever they need to go.

For example, [here's](https://github.com/GearsDatapacks/GearsDatapacks.github.io/blob/main/.github/workflows/publish.yml)
the script I use to deploy this website to GitHub Pages.

## Conclusion

Yes! It's that simple to make your own website with a data driven blog, custom
styling and an RSS feed. And here's all it took:

```shell
$ tree .
.
├── blog
│   └── test.md
├── gleam.toml
├── manifest.toml
├── src
│   └── blog.gleam
└── static
    └── style.css

$ cloc .
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Gleam                            1             24             12            103
TOML                             2              5             12             44
YAML                             1              2              1             20
CSS                              1              1              0              8
Markdown                         1              2              0              7
-------------------------------------------------------------------------------
SUM:                             6             34             25            182
-------------------------------------------------------------------------------
```

Just 182 lines of code!

Of course, this is just a starting point. You can add other non-blog pages very
easily, in the same way we do our `index` page. You can also change the home page
to be controlled by a Markdown file instead of Lustre HTML, which will allow you
to add new content much more easily in future. Personally, I like a more customised
layout for my home page.

Now go write some blog posts!
