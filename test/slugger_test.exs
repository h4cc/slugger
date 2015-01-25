defmodule SluggerTest do
  use ExUnit.Case
  doctest Slugger

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "string to lower" do
    assert Slugger.slugify("ABC") == "abc"
  end

  test "removing space at beginning" do
    assert Slugger.slugify(" \t \n ABC") == "abc"
  end

  test "removing space at ending" do
    assert Slugger.slugify("ABC \n  \t \n ") == "abc"
  end

  test "removing space at ending and ending" do
    assert Slugger.slugify(" \n  \t \n ABC \n  \t \n ") == "abc"
  end

  test "replace whitespace inside with seperator" do
    assert Slugger.slugify("   A B  C  ") == "a-b-c"
    assert Slugger.slugify("   A B  C  ", ?_) == "a_b_c"
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

end
