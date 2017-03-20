defmodule SimpleBench do
  use Benchfella

  bench "slugging single char" do
      Slugger.slugify ?a
  end

  bench "slugging very short string" do
      Slugger.slugify "abc"
  end

  bench "slugging normal string" do
      Slugger.slugify "abcdefghijk"
  end

  bench "slugging long string" do
      Slugger.slugify "abcdefghijkabcdefghijkabcdefghijkabcdefghijkabcdefghijk"
  end

  bench "slugging complex string" do
      Slugger.slugify "Öä!!§$%&/()=?234567890ßqwertzuiopü+asdjklöä#<yxcvbnm,.-"
  end
end