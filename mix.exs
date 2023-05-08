defmodule Styler.Examples.MixProject do
  use Mix.Project

  def project do
    [
      app: :examples_styler,
      version: "0.2.0",
      description: "Style code examples with mix format",
      source_url: "https://github.com/peake100/examples-styler-ex",
      elixir: "~> 1.14",
      test_coverage: [tool: :covertool],
      docs: [
        # The main page in the docs
        main: "readme",
        extras: ["README.md"]
      ],
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      dialyzer: [plt_add_apps: [:mix]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Test dependencies
      {:covertool, "~> 2.0", only: [:test]},
      {:stream_data, "~> 0.5.0", only: [:test]},
      {:junit_formatter, "~> 3.1", only: [:test]},
      {:elixir_uuid, "~> 1.2", only: [:test]},

      # Dev dependencies
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: [:dev, :test], runtime: false},
      {:styler, "~> 0.6", only: [:dev, :test], runtime: false}
    ]
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "examples_styler",
      # These are the default files included in the package
      files: ~w(lib mix.exs README.md* LICENSE*),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/peake100/examples-styler-ex"}
    ]
  end
end
