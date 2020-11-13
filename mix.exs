defmodule Slugger.Mixfile do
  use Mix.Project

  @source_url "https://github.com/h4cc/slugger"

  def project do
    [
      app: :slugger,
      name: "Slugger",
      version: "0.3.0",
      elixir: "~> 1.3",
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  defp description do
    """
    The Slugger library can generate slugs from given strings that can be used
    in URLs or file names.
    """
  end

  defp package do
    [
      files: ["config", "test", "lib", "bench", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Julius Beckmann"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  def application do
    [
      applications: [],
      env: [
        # Change these values using `config :slugger, separator_char: ?-` in
        # your config.exs file.
        replacement_file: "lib/replacements.exs",
        separator_char: ?-
      ]
    ]
  end

  defp deps do
    [
      {:benchfella, "~> 0.3.0", only: :dev},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:poison, "~> 3.0", only: [:dev, :test]}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
