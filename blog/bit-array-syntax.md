---
title = "Making the Most of Bit Arrays"
date = 2025-12-18
description = "Gleam has a special piece of syntax that most other languages don't: Bit arrays. They are extremely powerful, but unfortunately the documentation is a little sparse."
---

Gleam has a special piece of syntax that most other languages don't: Bit arrays.
Taken from Erlang, bit array syntax allows the constructing and pattern matching
on binary data. Bit arrays are extremely powerful, but unfortunately the documentation
is [a little sparse](https://tour.gleam.run/data-types/bit-arrays/). It lists all
the possible options you can use, as well as linking to the Erlang documentation
for further reading, but the syntax isn't exactly the same as on Erlang, so there's
some ambiguity as to how it exactly works. To make it easier, I wanted to write a
comprehensive guide, to make it as easy as possible to understand how they work.

### Table of contents
---
- [The basics](#the-basics)
- [Segment types](#segment-types)
- [Segment size](#segment-size)
- [Endianness](#endianness)
- [Pattern matching](#pattern-matching)
  - [Strings](#strings)
  - [Bits and bytes](#bits-and-bytes)
  - [Signedness](#signedness)
- [JavaScript support](#javascript-support)
- [Example](#example)
---

## The basics

Bit arrays are delimited by double angle brackets (`<<` and `>>`), and contain zero
or more **segments**, separated by commas. A segment is a value which is encoded
somehow as a sequence of bits. They have no actual separation other than syntactically,
they are just a way of building up a bit array out of various different parts.

A segment consists of a value, followed by a series of options using the syntax
`value:option1-option2-option3`.

There are several different data types that can appear as the value of a bit
array segment, and each has a slightly different set of defaults, as well as
options that can be used to modify how it is encoded.

The default assumed type is `Int`, and if you want a segment that is a non-integer,
you need to specify that by using the type-specific option, unless you are using
a literal, in which case it is inferred automatically.

## Segment types

As mentioned above, the default segment type is `Int`. By default, integer
segments are encoded as an 8-bit signed integer, although this can be modified
using various options, which will be mentioned later.

The syntax for printing bit arrays with the `echo` keyword uses 8-bit unsigned
integer segments to represent the structure of the bit array, so that is what I
will be using in the rest of this article to show the encoding of various bit
arrays.

```gleam
echo <<1, 2, -3>>
// <<1, 2, 253>>
```

Bit array syntax also allows for `Float` segments. If you are not using a literal
float value, the `float` option is required for the program to type-check. By
default, floats are encoded as 64-bit [IEEE 754](https://en.wikipedia.org/wiki/IEEE_754)
floats, although the size can be changed to either 32 or 16 bit.

```gleam
echo <<3.14>>
// <<64, 9, 30, 184, 81, 235, 133, 31>>

let some_float = 1.0
echo <<some_float>>
// Error: Expected type Int, found type Float

echo <<some_float:float>>
// <<63, 240, 0, 0, 0, 0, 0, 0>>
```

Strings are another data type that can be used as a bit array segment. By default,
strings are encoded in [UTF-8](https://en.wikipedia.org/wiki/UTF-8), although this
can be changed using the `utf16` and `utf32` options. The `utf8` option can also
be used, when the value is not a literal.

```gleam
echo <<"Hello 🌍">>
// <<72, 101, 108, 108, 111, 32, 240, 159, 140, 141>>

echo <<"Hello 🌍":utf16>>
// <<0, 72, 0, 101, 0, 108, 0, 108, 0, 111, 0, 32, 216, 60, 223, 13>>

echo <<"Hello 🌍":utf32>>
// <<0, 0, 0, 72, 0, 0, 0, 101, 0, 0, 0, 108, 0, 0, 0, 108, 0, 0, 0, 111, 0, 0, 0, 32, 0, 1, 243, 13>>

let greeting = "Hello"
echo <<greeting>>
// Error: Expected type Int, found type String

echo <<greeting:utf8>>
// <<72, 101, 108, 108, 111>>
```

UTF codepoints, using the built-in `UtfCodepoint` type, are also possible to use
as bit array segments. These work similar to strings, but only represent a single
codepoint instead of multiple. Like strings, they can be encoded as UTF-8, UTF-16
or UTF-32, although they have differently named options: `utf8_codepoint`,
`utf16_codepoint` and `utf32_codepoint`. Since there are no UTF codepoint literals,
on of these options is always required.

```gleam
let assert [codepoint] = string.to_utf_codepoints("🌍")

echo <<codepoint>>
// Error: Expected type Int, found type UtfCodepoint

echo <<codepoint:utf8_codepoint>>
// <<240, 159, 140, 141>>

echo <<codepoint:utf16_codepoint>>
// <<216, 60, 223, 13>>

echo <<codepoint:utf32_codepoint>>
// <<0, 1, 243, 13>>
```

The last data type that can be used is `BitArray`. The encoding here is pretty
obvious, simply consisting of the bits inside the specified bit array. Bit array
segments must use the `bits` option.

```gleam
let bit_array = <<3, 4, 5>>

echo <<bit_array>>
// Error: Expected type Int, found type BitArray

echo <<bit_array:bits>>
// <<3, 4, 5>>

echo <<1, 2, bit_array:bits, 6>>
// <<1, 2, 3, 4, 5, 6>>
```

## Segment size

Possibly the most commonly used bit array option is `size`. The `size` option
allows you to customise the size that a particular segment has, specified in
bits.

```gleam
echo <<1024:size(16)>>
// <<4, 0>>
```

Since size is so commonly used, it even has a shorthand syntax that you can use,
where the `size` part is omitted:

```gleam
echo <<1.0:32>>
// <<63, 128, 0, 0>>
```

There is another option you can use in conjunction with `size`: `unit`. The `unit`
option allows you to specify a value that is multiplied by the size. This is most
commonly useful for specifying sizes in bytes, but can be used for any size unit.

```gleam
echo <<1024:2-unit(8)>>
// <<4, 0>>

echo <<12:3-unit(2)>>
// <<12:6>>
```

*For bit arrays which are not a whole number of bytes, the trailing bits at the
end are suffixed with the number of bits.*

There are some limitations to the `size` option though. While it is unrestricted
on integer segments, float segments only support sizes of `16`, `32` or `64`, as
other size floats are not well defined.

String and UTF codepoint segments cannot use the `size` option; they have a fixed
size based on their value.

Bit array segments can use the `size` option to truncate the bit array to a
particular size, but if the specified size is larger than the size of the bit
array, it will lead to a runtime error.

## Endianness

By default, bit array segments are [big endian](https://en.wikipedia.org/wiki/Endianness),
however it is possible to configure them to be little endian instead, using the
`little` option. There is a `big` option too, but it does nothing other than
perhaps making the intention of the code clearer. There is also `native`, which
chooses endianness based on the processor that is running the code.

Endianness is easiest to understand when it comes to integer segments, but it
also applies to `Float`s as well as UTF-16 and UTF-32 strings and codepoints.
It is not allowed for UTF-8 or bit array segments.

Endianness usually doesn't matter when using bit arrays internally; it is often
only useful when it comes to interacting with a predefined API.

## Pattern matching

The syntax shown until now has been for constructing bit arrays, but as mentioned
at the beginning, bit array syntax can also used to pattern match on binary data
and extract information from it. The syntax is largely the same, but there are
some limitations and additional features when it comes to pattern matching.

In general, most of the syntax that can be used when constructing bit arrays can
be used in the same way when pattern matching. You can either match on a specific
literal, or assign the value to a variable.

One thing to note is that segment information is not stored in the bit array, so
for example a `Float` segment can be matched on as an `Int`, and vice versa.

```gleam
let assert <<x, y, z>> = <<1, 2, 3>>
echo #(x, y, z)
// #(1, 2, 3)

let assert <<1, a, 3>> = <<1, 2, 3>>
echo a
// 2

let assert <<x, y>> = <<3.14:16>>
echo #(x, y)
// #(66, 72)

let assert <<float:float-size(16)>> = <<60, 0>>
echo float
// 1.0
```

### Strings

One restriction to note is that arbitrary length strings cannot be matched on in
this way. The following is an error:

```gleam
let assert <<message:size(5)>> = <<"Hello">>
```

Because UTF-8 is variable sized, there's no guarantee that any given sequence
of bytes is valid UTF-8. You can still match on UTF codepoints though, as well
as string literals.

```gleam
let assert <<"Hello", last_char>> = <<"Hello!">>
echo last_char
// 33

let assert <<first:utf8_codepoint>> = <<81>>
echo first
// utfcodepoint(Q)
```

### Bits and bytes

For matching on bit arrays, there are two options: The `bits` option that is used
in construction, and a second `bytes` option, which only matches whole numbers of
bytes. If given an explicit size, that number of bits/bytes is matched. If the
`size` option is not used, they match everything remaining in the bit array.

**Note**: When using the `bytes` option, size is measured in bytes, and the `unit`
option cannot be used. This is currently a bug in Gleam, you can track its status
[here](https://github.com/gleam-lang/gleam/issues/5208).

```gleam
let assert <<_, bits:bits-size(12), _:size(4)>> = <<1, 2, 3>>
echo bits
// <<2, 0:4>>

let assert <<_, bytes:bytes-size(3), _>> = <<1, 2, 3, 4, 5>>
echo bits
// <<2, 3, 4>>

let assert <<first:4, rest:bits>> = <<1, 2, 3>>
echo rest
// <<16, 32, 3:4>>

let assert <<_, _, rest:bytes>> = <<1, 2, 3, 4, 5, 6>>
echo rest
// <<3, 4, 5, 6>>

let assert <<value:bytes>> = <<1, 2:2, 3>>
// Error: Pattern match failed
```

### Signedness

When matching on integers, they are treated by default as unsigned. If you want
to match on a signed integer, the `signed` option can be used, and the number is
interpreted using [two's complement](https://en.wikipedia.org/wiki/Two%27s_complement).
The `unsigned` option also exists for consistency, but like `big`, it does
nothing. Signedness only applies to integers and cannot be used with any other
type of segment.

```gleam
let assert <<x>> = <<-1>>
echo x
// 255

let assert <<x:signed>> = <<255>>
echo x
// -1
```

## JavaScript support

Bit arrays are a feature of Erlang, built in to the BEAM virtual machine. This
is what inspired the Gleam feature, and it means we get all this behaviour for
free on the Erlang target. But on JavaScript, all features need to be implemented
from scratch. While most of the Erlang behaviour already exists, a few features
are still lacking. At the time of writing the two missing features are the
`native` option, and pattern matching on UTF codepoints. You can check the
[tracking issue](https://github.com/gleam-lang/gleam/issues/3842) to see if any
progress has been made since.

## Example

Now that we know about all the features of bit arrays, we can use them. Here is
an example of a basic en/decoder for Minecraft's [NBT](https://minecraft.wiki/w/NBT_format)
format, using bit arrays.

First, we define our type to represent the NBT data:

```gleam
pub type Nbt {
  Byte(Int)
  Short(Int)
  Int(Int)
  Long(Int)
  Float(Float)
  Double(Float)
  ByteArray(List(Int))
  IntArray(List(Int))
  LongArray(List(Int))
  String(String)
  List(List(Nbt))
  Compound(Dict(String, Nbt))
}
```

Next, we can create a `decode` function to turn a bit array into NBT:

```gleam
pub fn decode(bits: BitArray) -> Nbt {
  // The first byte tells us what kind of data the value is
  case bits {
    <<1, byte:8-signed, _:bits>> -> Byte(byte)
    <<2, short:16-signed, _:bits>> -> Short(short)
    <<3, int:32-signed, _:bits>> -> Int(int)
    <<4, long:64-signed, _:bits>> -> Long(long)
    <<5, float:32-float, _:bits>> -> Float(float)
    <<6, double:64-float, _:bits>> -> Double(double)

    <<8, length:32, bytes:bytes-size(length), _:bits>> -> {
      // We can't match on arbitrary UTF-8 so we must extract the bytes then
      // convert it to a string.
      let assert Ok(string) = bit_array.to_string(bytes)
      String(string)
    }

    <<7, length:32-signed, bytes:bytes-size(length), _:bits>> ->
      ByteArray(bytes_to_list(bytes, 8, []))

    <<11, length:32-signed, bytes:bytes-size(length * 4), _:bits>> ->
      IntArray(bytes_to_list(bytes, 32, []))

    <<12, length:32-signed, bytes:bytes-size(length * 8), _:bits>> ->
      LongArray(bytes_to_list(bytes, 64, []))

    // Omitted for brevity
    <<9, _:bits>> -> todo
    <<10, _:bits>> -> todo
    // For the sake of this example, we will just crash the program here
    _ -> panic as "Invalid NBT"
  }
}
```

The `bytes_to_list` splits a bit array into n-bit chunks:

```gleam
fn bytes_to_list(bytes: BitArray, chunk_size: Int, out: List(Int)) -> List(Int) {
  case bytes {
    <<first:size(chunk_size)-signed, rest:bytes>> ->
      bytes_to_list(rest, chunk_size, [first, ..out])
    _ -> list.reverse(out)
  }
}
```

Finally, an `encode` function to turn the NBT back into binary:

```gleam
pub fn encode(nbt: Nbt) -> BitArray {
  case nbt {
    Byte(byte) -> <<1, byte:8>>
    Short(short) -> <<2, short:16>>
    Int(int) -> <<3, int:32>>
    Long(long) -> <<4, long:64>>
    Float(float) -> <<5, float:float-32>>
    Double(double) -> <<6, double:float-64>>

    // Append the tag (7), followed by each byte in the list
    ByteArray(bytes) ->
      list.fold(bytes, <<7>>, fn(out, byte) { <<out:bits, byte:8>> })
    IntArray(ints) ->
      list.fold(ints, <<11>>, fn(out, int) { <<out:bits, int:32>> })
    LongArray(longs) ->
      list.fold(longs, <<12>>, fn(out, long) { <<out:bits, long:64>> })

    String(string) -> <<8, string:utf8>>

    // Omitted for brevity
    List(_) -> todo
    Compound(_) -> todo
  }
}
```
