defmodule Slugger.Mixfile do
  use Mix.Project

  def project do
    [app: :slugger,
     name: "Slugger",
     source_url: "https://github.com/h4cc/slugger",
     version: "0.2.0",
     elixir: "~> 1.3",
     description: description(),
     package: package(),
     deps: deps()]
  end

  defp description do
    """
    The library Slugger can generate slugs from given strings that can be used in URLs or file names.
    """
  end

  defp package do
    [# These are the default files included in the package
     files: ["config", "test", "lib", "bench", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["Julius Beckmann"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/h4cc/slugger",
              "Docs" => "http://hexdocs.pm/slugger/"}]
  end

  def application do
    [
      applications: [],
      env: [
        # Change these values using `config :slugger, separator_char: ?-` in your config.exs file.
        replacement_file: "lib/replacements.exs",
        separator_char: ?-,
      ],
    ]
  end

  defp deps() do
    [
      {:ex_doc, "~> 0.16.1", only: :dev},
      {:benchfella, "~> 0.3.0", only: :dev},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:poison, "~> 3.0", only: [:dev, :test]},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false}
    ]
  end
end
