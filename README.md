# Slugger

This package provides a library and a protocol to create [slugs](http://en.wikipedia.org/wiki/Semantic_URL#Slug) for given strings.

By default, a slug will be containing _only_ chars `a-z0-9` and the default seperator `-`.

## Library

Using the library is straightforward, check out a few examples:

```elixir
iex(1)> Slugger.slugify " a b c "
"a-b-c"

iex(2)> Slugger.slugify "A cool title of a blog post"
"a-cool-title-of-a-blog-post"

iex(3)> Slugger.slugify "A cool title of a blog post, wikipedia style", ?_
"a_cool_title_of_a_blog_post_wikipedia_style"
```

## Protocol

Next to the library, a protocol is provided to ease creating slugs for own data structures.
By default, the protocol will try to run `Slugger.slugify(Kernel.to_string(your_data))`, so if your_data implents `String.Chars` that returned string will be slugified.
If you want to provide a own way to create a slug, check out the following example:

```elixir
iex(4)> defmodule User do
...(4)>   defstruct name: "Julius Beckmann"
...(4)> end

iex(5)> defimpl Slugify, for: User do   
...(5)>   def slugify(user), do: Slugger.slugify(user.name)
...(5)> end

iex(6)> Slugify.slugify %User{}                          
"julius-beckmann"
```

## Replacements

Special chars like `äöüéáÁÉ` will be replaced by rules given in the file [lib/replacements.exs](lib/replacements.exs).

Modify that file if you need have own replacement rules and __recompile__.
