defmodule Friendly.Mixfile do
  use Mix.Project

  def project do
    [app: :friendly,
     version: "1.0.0",
     description: "HTML and XML parser with the most friendly API in Elixir land. CSS selector in, list of elements out.",
     elixir: "~> 1.2",
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def package do
    [
     maintainers: ["Piotr Włodarek"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/qertoip/friendly/",
              "Docs" => "https://github.com/qertoip/friendly/"}
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:floki, "~> 0.7"}
    ]
  end
end
