defmodule Slugger do
  @moduledoc """
  Calcualtes a 'slug' for a given string.
  Such a slug can be used for reading URLs or Search Engine Optimization.
  """

  @doc """
  Return a string in form of a slug for a given string.
  
  ## Examples
    iex> Slugger.slugify(" Hi # there ")
    "hi-there"
    
    iex> Slugger.slugify("Über den Wölkchen draußen im Tore")
    "ueber-den-woelkchen-draussen-im-tore"
    
    iex> Slugger.slugify("Wikipedia Style", ?_)
    "wikipedia_style"
    
    iex> Slugger.slugify("_trimming_and___removing_inside___")
    "trimming-and-removing-inside"
  """
  def slugify(text, separator \\ ?-) do
    text
    |> replace_special_chars
    |> normalize
    |> replace_unwanted_chars(separator)
  end

  defp normalize(text) do
    text
    |> String.downcase
  end

  defp replace_unwanted_chars(text, separator) do
    text
    |> String.replace(~r/([^a-z0-9])+/, to_string([separator])) 
    |> String.strip(separator)
  end
  
  defp replace_special_chars(text) do
    text |> to_char_list |> replace_chars |> to_string
  end
  
  #-- Generated function `replace_chars` below --- 
  
  # Generate replacement functions using pattern matching.   
  {replacements, _} = Code.eval_file("replacements.exs", __DIR__)  
  for {search, replace} <- replacements do
    defp replace_chars([unquote(search)|t]), do: unquote(replace) ++ replace_chars(t)
  end

  # A unmatched char will be kept.
  defp replace_chars([h|t]), do: [h] ++ replace_chars(t)

  # String has come to an end, stop recursion here.
  defp replace_chars([]), do: []

end
