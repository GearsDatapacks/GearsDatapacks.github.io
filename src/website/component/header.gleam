import gleam/list
import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg

type PageRoute {
  PageRoute(name: String, url: String)
}

const pages = [
  PageRoute("About", "/about"),
  PageRoute("Projects", "/projects"),
  PageRoute("Commissions", "/commissions"),
  PageRoute("Contact me", "/contact"),
]

pub fn view(page: String) -> Element(a) {
  html.header([attribute.class("bg-purple-700 flex w-full select-none fixed")], [
    html.nav(
      [
        attribute.class(
          "flex h-16 grow items-center justify-between gap-4 px-4 text-white",
        ),
      ],
      [
        html.a([attribute.class("heading"), attribute.href("/")], [
          html.figure(
            [attribute.class("flex flex-shrink-0 items-center space-x-1")],
            [
              html.img([
                attribute.style([
                  #("image-rendering", "optimizeSpeed"),
                  #("image-rendering", "pixelated"),
                ]),
                attribute.width(64),
                attribute.height(64),
                attribute.src("/images/logo.svg"),
                attribute.class("max-w-none"),
                attribute.alt("Gears logo"),
              ]),
              html.figcaption(
                [
                  attribute.class(
                    "text-4xl font-bold font-celandine hidden md:block",
                  ),
                ],
                [
                  svg.svg([], [
                    svg.path([
                      attribute("d", logo_svg),
                      attribute.class("animate-write"),
                      attribute.style([
                        #("fill", "none"),
                        #("stroke", "#ffffff"),
                        #("stroke-width", "1px"),
                        #("stroke-dasharray", "330"),
                        #("stroke-dashoffset", "330"),
                      ]),
                    ]),
                  ]),
                ],
              ),
            ],
          ),
        ]),
        nav_bar(page),
      ],
    ),
  ])
}

fn nav_bar(current_page: String) -> Element(a) {
  html.ul(
    [attribute.class("flex space-x-4")],
    list.map(pages, fn(page) {
      let default_style = "text-xl font-bold border-2 p-2"
      let element = case page.name == current_page {
        True ->
          html.span(
            [
              attribute.class(
                default_style
                <> " cursor-default border-gray-400 text-gray-400 text-xs lg:text-xl",
              ),
            ],
            [element.text(page.name)],
          )
        False ->
          html.a(
            [
              attribute.class(
                default_style
                <> " border-cyan-500 text-cyan-300 ease-linear duration-75 hover:underline text-xs lg:text-xl hover:text-xl hover:lg:text-2xl",
              ),
              attribute.style([#("transition-property", "font-size")]),
              attribute.href(page.url),
            ],
            [element.text(page.name)],
          )
      }
      html.li([], [element])
    }),
  )
}

const logo_svg = "m 46.655648,87.273021 c 0.08105,4.602277 0.692125,6.832404 4.69733,4.361206 l 1.696146,2.728148 -14.225762,9.638735 c -2.121146,-1.55607 -3.838276,-4.0442 -4.678364,-7.342384 -3.390161,3.734254 -7.562386,6.271464 -13.082724,5.788494 C 10.581627,101.53029 2.8720353,90.133692 1.4418114,77.915968 0.26959238,64.592176 8.4519982,56.762609 16.647423,50.627146 c 6.709353,-4.814367 12.185664,-6.592535 16.425926,-6.221561 10.400636,0.909937 10.2848,16.055858 17.661218,12.831577 l 1.369105,2.78015 -13.921761,7.085583 C 29.896397,65.974923 28.524127,49.408937 19.629655,55.241389 c -4.548238,3.149245 -6.106269,8.978614 -4.24704,19.057204 1.461159,6.335369 5.770507,14.209799 12.214927,17.030887 2.403158,1.097035 4.205262,0.770993 6.046357,-0.922122 l 0.08399,-0.960053 0.300983,-3.440212 c -4.7513,-0.980005 -7.300468,-2.251058 -10.07761,0.0051 L 22.053124,83.749873 33.3637,74.259168 c 9.7606,0.853945 14.332923,4.801125 19.271184,0.879838 l 1.905129,2.18211 -7.907394,7.450543 c -0.0043,0.967047 0.07203,1.94111 0.02303,2.501151 z m 27.106123,0.967939 c 3.255101,3.879267 7.924879,5.594901 14.610274,2.013462 L 89.84759,92.997687 71.511182,104.62772 C 62.371276,103.58301 53.002118,82.748534 59.5709,73.029912 61.983775,69.728218 72.927415,59.493724 79.332135,60.054064 85.49365,60.593125 92.577447,70.199104 92.109323,75.549881 Z M 70.902742,68.629587 c -3.536763,2.141364 -1.750046,9.73174 1.253752,15.549655 L 79.558343,78.94493 C 78.612783,73.878931 74.248977,66.798328 70.902742,68.629587 Z m 62.806708,23.029124 1.74528,2.221251 -13.08952,10.709588 c -2.6179,0 -5.2358,-4.839141 -5.71178,-8.567661 l -11.7409,8.567661 c -6.505075,-0.0794 -10.709601,-7.61571 -9.916305,-13.24816 1.269292,-8.250355 9.123005,-13.010178 19.832605,-16.104062 -3.49054,-5.553124 -13.08951,-4.997811 -19.0393,-1.348612 l -1.586601,-2.459244 14.993441,-10.78893 c 9.28166,0 19.19795,1.665941 19.43593,14.438129 l 0.0794,12.375534 c -0.0794,4.125169 1.26928,6.901741 4.99782,4.204506 z m -22.60914,3.490534 4.99781,-3.252544 -0.0794,-12.930849 c -10.23362,3.728531 -10.70961,12.930849 -4.91847,16.183393 z m 51.19467,-16.075266 c -2.21157,-3.712255 -5.13397,-8.846224 -8.45131,-5.765843 l -0.47391,0.473911 v 1.184756 l 0.079,12.795432 c -0.079,4.028194 1.18475,6.555693 4.897,3.949214 l 1.81664,2.448509 -13.0324,10.504892 c -3.55428,-2.21157 -6.23973,-6.792636 -6.16074,-13.664255 V 78.679058 c -0.15797,-4.818028 -1.97461,-6.397712 -6.63468,-3.396316 L 132.99186,72.755248 147.13,60.907625 c 3.08039,2.290541 4.89704,4.423114 5.68687,7.740447 l 8.05639,-7.740447 c 6.00279,0 11.68966,9.636068 11.68966,9.636068 z m 19.14678,-9.156439 c 4.4536,7.601839 23.80372,5.375035 23.80372,20.962647 0,10.442913 -10.13577,13.207223 -19.5037,13.207223 -7.14112,0 -13.8983,-2.45716 -16.12512,-6.757188 l 11.36438,-10.596498 1.84287,1.45894 c -2.91787,2.841084 11.134,6.987545 15.05009,6.987545 0.46073,-6.296472 -26.33768,-10.058994 -26.33768,-19.580489 0,-8.369699 13.89831,-14.05188 13.89831,-14.05188 7.83221,0 16.2019,4.4536 21.11622,1.61251 l 1.22858,1.689298 -12.90008,10.289358 c -4.99112,0 -11.44115,-8.292917 -13.43759,-5.221466 z"
