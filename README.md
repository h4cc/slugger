# Slugger

[![Build Status](https://travis-ci.org/h4cc/slugger.svg?branch=master)](https://travis-ci.org/h4cc/slugger)
[![Module Version](https://img.shields.io/hexpm/v/slugger.svg)](https://hex.pm/packages/slugger)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/slugger/)
[![Total Download](https://img.shields.io/hexpm/dt/slugger.svg)](https://hex.pm/packages/slugger)
[![License](https://img.shields.io/hexpm/l/slugger.svg)](https://github.com/h4cc/slugger/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/h4cc/slugger.svg)](https://github.com/h4cc/slugger/commits/master)

This package provides a library and a protocol to create [slugs](http://en.wikipedia.org/wiki/Semantic_URL#Slug) for given strings.

By default, a slug will be containing _only_ chars `A-Za-z0-9` and the default separator `-`.

Want to use this library with Ecto? Have a look at [sobolevn/ecto_autoslug_field](https://github.com/sobolevn/ecto_autoslug_field).

## Installation

Add `slugger` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:slugger, "~> 0.3"},
  ]
end
```

## Configuration

The following options can be set in your `config.exs` and will be used at __next compile__!

```elixir
# Char used as separator between words.
config :slugger, separator_char: ?-

# Path to the file containing replacements.
config :slugger, replacement_file: "lib/replacements.exs"
```

## Library

Using the library is straightforward, check out a few examples:

```elixir
iex(1)> Slugger.slugify " A b C "
"A-b-C"

iex(2)> Slugger.slugify_downcase " A b C "
"a-b-c"

iex(3)> Slugger.slugify "A cool title of a blog post"
"A-cool-title-of-a-blog-post"

iex(4)> Slugger.slugify_downcase("Kluski Śląskie @ Jalapeño Bilingüe")
"kluski-slaskie-at-jalapeno-bilinguee"

iex(5)> Slugger.slugify "Wikipedia Style", ?_
"Wikipedia_Style"

iex(6)> Slugger.truncate_slug "A-to-long-slug-that-should-be-truncated", 16
"A-to-long-slug"
```

## Protocol

<!--MPROTO !-->

Next to the library, a protocol is provided to ease creating slugs for own data structures.
By default, the protocol will try to run `Slugger.slugify(Kernel.to_string(your_data))`, so if `your_data` implements `String.Chars`, the returned string will be slugified.
If you want to provide your own way to create a slug, check out the following example:

```elixir
iex(10)> defmodule User do
...(10)>   defstruct name: "Julius Beckmann"
...(10)> end

iex(11)> defimpl Slugify, for: User do
...(11)>   def slugify(user), do: Slugger.slugify(user.name)
...(11)> end

iex(12)> Slugify.slugify %User{}
"Julius-Beckmann"
```
<!--MPROTO !-->

## Replacements

Special chars like `äöüéáÁÉ` will be replaced by rules given in the file [lib/replacements.exs](https://github.com/h4cc/slugger/blob/master/lib/replacements.exs).

Copy that file if you need have own replacement rules, change the config value and __recompile__.

## License

MIT. Copyright (c) 2015-current Julius Beckmann
