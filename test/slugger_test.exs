defmodule SluggerTest do
  use ExUnit.Case
  doctest Slugger

  #--- slugify()

  test "string keep case" do
    assert Slugger.slugify("ABC") == "ABC"
  end

  test "removing space at beginning" do
    assert Slugger.slugify(" \t \n ABC") == "ABC"
  end

  test "removing space at ending" do
    assert Slugger.slugify("ABC \n  \t \n ") == "ABC"
  end

  test "removing space at ending and ending" do
    assert Slugger.slugify(" \n  \t \n ABC \n  \t \n ") == "ABC"
  end

  test "removing space at ending and ending with korean chars" do
    assert Slugger.slugify(" \n  \t \n ㅈㅓㅇㅅㅜㅇㅕㄴ for 정수연 \n  \t \n ") == "ㅈㅓㅇㅅㅜㅇㅕㄴ-for-정수연"
  end

  test "replace whitespace inside with seperator" do
    assert Slugger.slugify("   A B  C  ") == "A-B-C"
    assert Slugger.slugify("   A B  C  ", ?_) == "A_B_C"
  end

  test "replace multiple seperator inside and outside" do
    assert Slugger.slugify("--a--b c - - - ") == "a-b-c"
  end

  test "replace special char with expected string" do
    assert Slugger.slugify("üba") == "ueba"
    assert Slugger.slugify("büa") == "buea"
    assert Slugger.slugify("baü") == "baue"
    assert Slugger.slugify("büaü") == "bueaue"
  end

  test "removing space between possessives" do
    assert Slugger.slugify("Sheep's Milk") == "Sheeps-Milk"
  end

  test "removing unwanted unicode characters" do
    assert Slugger.slugify("abc 😀") == "abc"
  end

  #--- slugify_downcase()

  test "string to lower" do
    assert Slugger.slugify_downcase("ABC") == "abc"
  end

  test "removing space at beginning lowercase" do
    assert Slugger.slugify_downcase(" \t \n ABC") == "abc"
  end

  test "removing space at ending lowercase" do
    assert Slugger.slugify_downcase("ABC \n  \t \n ") == "abc"
  end

  test "removing space at ending and ending lowercase" do
    assert Slugger.slugify_downcase(" \n  \t \n ABC \n  \t \n ") == "abc"
  end

  test "replace whitespace inside with seperator lowercase" do
    assert Slugger.slugify_downcase("   A B  C  ") == "a-b-c"
    assert Slugger.slugify_downcase("   A B  C  ", ?_) == "a_b_c"
  end

  test "removing space between possessives lowercase" do
    assert Slugger.slugify_downcase("Sheep's Milk") == "sheeps-milk"
  end

  test "removing unwanted unicode characters lowercase" do
    assert Slugger.slugify_downcase("abc 😀") == "abc"
  end

  #--- Naughty strings

  test "naughty strings" do
    "test/big-list-of-naughty-strings/blns.json"
    |> File.read!
    |> Poison.decode!
    |> Enum.each(fn(string) ->
      assert is_binary Slugger.slugify(string)
      assert is_binary Slugger.slugify_downcase(string)
    end)
  end

  #--- Application config

  test "config defaults" do
    Application.load(:slugger)

    assert Application.get_env(:slugger, :separator_char) == ?-
    assert Application.get_env(:slugger, :replacement_file) == "lib/replacements.exs"

    assert Slugger.slugify("a ü") == "a-ue"
  end

  #--- truncate_slug()

  test "don't truncate short enough slugs" do
    assert Slugger.truncate_slug("a-b-c", 10) == "a-b-c"
    assert Slugger.truncate_slug("a-b-c", 5) == "a-b-c"
    assert Slugger.truncate_slug("a-b-c", 4) == "a-b"
    assert Slugger.truncate_slug("a-b-c", 3) == "a-b"
    assert Slugger.truncate_slug("a-b-c", 2) == "a"
    assert Slugger.truncate_slug("a-b-c", 1) == "a"
    assert Slugger.truncate_slug("a-b-c", 0) == ""
    assert Slugger.truncate_slug("a-b-c", -1) == ""
    assert Slugger.truncate_slug("a-b-c", -2) == ""
    assert Slugger.truncate_slug("a-b-c", -3) == ""
    assert Slugger.truncate_slug("a-b-c", -4) == ""
    assert Slugger.truncate_slug("a-b-c", -5) == ""
  end
  test "truncate before separator that is in range" do
    assert Slugger.truncate_slug("abc-def-ghi-jkl-mno-pqr", 8) == "abc-def"
    assert Slugger.truncate_slug("abc_def", 6, [separator: ?_]) == "abc"
  end

  test "don't truncate unimpaired last word" do
    assert Slugger.truncate_slug("abc-def-ghi", 7) == "abc-def"
  end

  test "truncate hard if unavoidable" do
    assert Slugger.truncate_slug("abcdefg", 3) == "abc"
  end

  test "truncate hard if option is set" do
    assert Slugger.truncate_slug("abc-def", 5, [hard: true]) == "abc-d"
    assert Slugger.truncate_slug("abc_def", 5, [separator: ?_, hard: true]) == "abc_d"
  end

end
