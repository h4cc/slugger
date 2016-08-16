defmodule Slugger.Mixfile do
  use Mix.Project

  def project do
    [app: :slugger,
     name: "Slugger",
     source_url: "https://github.com/h4cc/slugger",
     version: "0.1.0",
     elixir: "~> 1.0",
     description: description,
     package: package,
     deps: deps]
  end

  defp description do
    """
    The library Slugger can generate slugs from given strings that can be used in URLs or file names.
    """
  end

  defp package do
    [# These are the default files included in the package
     files: ["config", "test", "lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
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
        replacement_file: "replacements.exs",
        separator_char: ?-,
      ],
    ]
  end

  defp deps() do
    [
      {:earmark, "~> 0.1.17", only: :dev},
      {:ex_doc, "~> 0.6", only: :dev},
      {:benchfella, "~> 0.3.0", only: :dev},
    ]
  end
end
