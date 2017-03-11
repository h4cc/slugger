defmodule Slugger do

  # Default char separating
  @separator_char Application.get_env(:slugger, :separator_char, ?-)

  # File that contains the char replacements.
  @replacement_file Application.get_env(:slugger, :replacement_file, "lib/replacements.exs")

  # Telling Mix to recompile this file, if the replacement file changed.
  @external_resource @replacement_file

  @truncation_defaults [separator: @separator_char, hard: false]

  @moduledoc """
  Calcualtes a 'slug' for a given string.
  Such a slug can be used for reading URLs or Search Engine Optimization.
  """

  @doc """
  Return a string in form of a slug for a given string.
  
  ## Examples
      
      iex> Slugger.slugify(" Hi # there ")
      "Hi-there"
      
      iex> Slugger.slugify("Über den Wölkchen draußen im Tore")
      "Ueber-den-Woelkchen-draussen-im-Tore"
      
      iex> Slugger.slugify("Wikipedia Style", ?_)
      "Wikipedia_Style"
      
      iex> Slugger.slugify("_Trimming_and___Removing_inside___")
      "Trimming-and-Removing-inside"
    
  """
  @spec slugify(text :: any, separator :: char) :: String.t
  def slugify(text, separator \\ @separator_char) do
    text
    |> replace_special_chars
    |> remove_unwanted_chars(separator, ~r/([^A-Za-z0-9])+/)
  end
  
  @doc """
  Return a string in form of a lowercase slug for a given string.
  
  ## Examples
      
      iex> Slugger.slugify_downcase(" Hi # there ")
      "hi-there"
      
      iex> Slugger.slugify_downcase("Über den Wölkchen draußen im Tore")
      "ueber-den-woelkchen-draussen-im-tore"
      
      iex> Slugger.slugify_downcase("Wikipedia Style", ?_)
      "wikipedia_style"
      
      iex> Slugger.slugify_downcase("_trimming_and___removing_inside___")
      "trimming-and-removing-inside"
      
  """
  @spec slugify_downcase(text :: any, separator :: char) :: String.t
  def slugify_downcase(text, separator \\ @separator_char) do
    text
    |> replace_special_chars
    |> String.downcase
    |> remove_unwanted_chars(separator, ~r/([^a-z0-9])+/)
  end
  
  @spec remove_unwanted_chars(text :: String.t, separator :: char, pattern :: Regex.t) :: String.t
  defp remove_unwanted_chars(text, separator, pattern) do
    text
    |> String.replace(pattern, to_string([separator])) 
    |> String.strip(separator)
  end
  
  @spec replace_special_chars(text :: any) :: String.t
  defp replace_special_chars(text) do
    text |> to_char_list |> replace_chars |> to_string
  end
  
  #-- Generated function `replace_chars` below --- 
  
  # Generate replacement functions using pattern matching.
  @spec replace_chars(char_list) :: char_list
  {replacements, _} = Code.eval_file(@replacement_file)
  for {search, replace} <- replacements do
    if search != @separator_char do
      defp replace_chars([unquote(search)|t]), do: unquote(replace) ++ replace_chars(t)
    end
  end

  # A unmatched char will be kept.
  defp replace_chars([h|t]), do: [h] ++ replace_chars(t)

  # String has come to an end, stop recursion here.
  defp replace_chars([]), do: []

  @doc """
  Truncate a slug at a given maximum length.

  Tries to cut off before the last separator instead of breaking inside of a word,
  unless you set the `hard` option to true.

  ## Examples
    iex> Slugger.truncate_slug("hello-world", 7)
    "hello"

    iex> Slugger.truncate_slug("hello-world", 7, [hard: true])
    "hello-w"
  """
  def truncate_slug(slug, max_length, options \\ []) do
    options = Keyword.merge(@truncation_defaults, options)
    slug
    |> to_char_list
    |> truncate_charlist(max_length, {options[:hard], options[:separator]})
    |> to_string
  end

  defp truncate_charlist(slug, max_length, _) when length(slug) <= max_length,
  do: slug

  defp truncate_charlist(slug, max_length, {true, _}) do
    slug |> Enum.take(max_length)
  end

  defp truncate_charlist(slug, max_length, {_, separator}) do
    if has_separator(slug, max_length, separator) do
      slug
      |> Enum.take(max_length + 1)
      |> Enum.reverse
      |> Enum.drop_while(&(&1 != separator))
      |> Enum.drop(1)
      |> Enum.reverse
    else
      slug |> Enum.take(max_length)
    end
  end

  defp has_separator(slug, range, separator) do
      slug
      |> Enum.take(range)
      |> Enum.any?(&(&1 == separator))
  end
end
