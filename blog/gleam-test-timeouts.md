---
title = "Test Timeouts in Gleam"
date = 2025-11-25
description = "By default, Gleam tests come with a timeout of 5 seconds. It's not as easy as you might think to remove it."
---

If you don't care about the backstory and just want to know the answer, you can
[skip there](#how-do-i-configure-my-test-timeout).

## How Gleam tests work

When you create a new Gleam project, there are two dependencies that are added
automatically by the build tool. These are [`gleam_stdlib`](https://hexdocs.pm/gleam_stdlib),
the Gleam standard library, and [`gleeunit`](https://hexdocs.pm/gleeunit), the
default test runner for Gleam. Both of these dependencies are technically optional,
but they are added by default to make it easier to start a new project, since
most projects use them.

See, when you run `gleam test` in the terminal, while it may seem like the Gleam
build tool finds all your test functions magically, all it's really doing is calling
the `main` function of the module named `$PROJECT_test`, which by default calls
out to `gleeunit`, the code that's really in charge of running your tests.

## What is gleeunit?

On the Erlang target, the `gleeunit` library is a thin wrapper for
[`EUnit`](https://www.erlang.org/doc/apps/eunit/chapter.html), which is a test
runner built into OTP. On JavaScript, `gleeunit` implements a custom test runner
that has similar (but not identical) features to EUnit. Somewhat unfortunately,
EUnit comes with a default timeout of 5 seconds, and seemingly
[no way to globally adjust it](https://github.com/lpil/gleeunit/issues/51),
so if any test runs for longer than that it is immediately terminated.

EUnit has a somewhat unconventional API. As the default Gleam project explains,
it runs all public functions whose names end in `_test`. But there's a second
more obscure API, in the form of **test generators**.

Test generators are another kind of EUnit test. Test generator functions end
in `_test_` (note the trailing underscore), and they have the ability to configure
various parts of how EUnit runs. It's detailed in the EUnit documentation,
but here we will just cover the most commonly used one, which is the timeout.

## How do I configure my test timeout?

EUnit test generators allow returning extra values along with a function to call
in order to configure it. In Erlang syntax, here is how you would configure the
timeout for your test, to be 60 seconds instead of 5:

```erlang
something_test_() ->
  {timeout, 60, fun () -> 
    ... % The actual body of your test 
  }.
```

So, what does this translate to Gleam? Well, there are actually two ways to do it.
The first is to use the `atom.create` function from the [`gleam_erlang`](https://hexdocs.pm/gleam_erlang)
library. This creates basically the same as the Erlang code:

```gleam
import gleam/erlang/atom

pub fn something_test_() {
  #(atom.create("timeout"), 60, fn() {
    ... // The actual body of your test
  })
}
```

This works, but it has a couple of drawbacks. Firstly, you need to pull in a new
library just to create this one atom, and secondly it just doesn't look very nice.
My preferred solution takes advantage of the way that custom types are represented
in Gleam.

When Gleam compiles to Erlang, Gleam custom types become an Erlang tuple tagged
with an atom. So the Gleam value `Ok(10)` becomes the Erlang `{ok, 10}`. This is
perfect for what we need, because it's the exact same format as what EUnit expects.
Using that knowledge we can define a custom type to represent the timeout tuple:

```gleam
pub type Timeout(a) {
  Timeout(time: Int, function: fn() -> a)
}
```

You can use `Float` instead for `time` here, but I find I rarely need to set my
timeout to a fraction of a second, so `Int` is more convenient. Now, we can take
advantage of Gleam's [`use` syntax](https://tour.gleam.run/advanced-features/use/),
which allows us to turn a call to a higher order function — where we pass an anonymous
function, like we did in the previous example — into a flattened statement.
We now get a much nicer looking test:

```gleam
pub type Timeout(a) {
  Timeout(time: Int, function: fn() -> a)
}

pub fn something_test_() {
  use <- Timeout(60)
  ... // The actual body of your test
}
```

Great! We've successfully worked around EUnit's annoying timeout. Job done! But
wait...

## Multi-target tests

Remember when I mentioned earlier about how `gleeunit` works differently on the
JavaScript target? Well, the good news is that it doesn't have a timeout like on
the Erlang target, but the bad news is that it doesn't support test generators.
So if all your tests are called `*_test_`, none of them are going to run on
the JavaScript target.

The only real way to get around this is to write a bit of extra boilerplate for
all of your tests. You need to write a test that runs only on JavaScript, that
calls the same code as the Erlang test. There's only really one way achieve this,
with the `@target` attribute, and it's not pretty. Here's an example:

```gleam
// This runs on Erlang
pub fn something_test_() {
  use <- Timeout(60)
  ... // The actual body of your test
}

// This runs on JavaScript
@target(javascript)
pub fn something_test() {
  something_test_().function()
}
```

The `@target` attribute is deprecated, and you shouldn't use it really, but there
isn't any alternative for this specific case. Hopefully soon we will have an
alternative, both to `@target`, and to this problem of different behaviour in the
test runner across targets.

## Conclusion

If you want to change the timeout of a test that only runs on Erlang, it's not
very hard. If you want to have tests that run on both targets for longer than 5
seconds, it gets messy.
Hopefully there will be a better way to do it in the near future.
