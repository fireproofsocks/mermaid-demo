defmodule Foo.MixProject do
  use Mix.Project

  @version "1.2.3"

  def project do
    [
      app: :foo,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        source_ref: "v#{@version}",
        main: "README",
        logo: "docs/logo.png",
        extras: [
          "README.md",
          "CHANGELOG.md"
        ],
        before_closing_body_tag: fn
          :html ->
            """
            <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
            <script>mermaid.initialize({startOnLoad: true})</script>
            """

          _ ->
            ""
        end
      ],
      releases: releases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Foo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dotenvy, "~> 0.3.0"},
      {:dialyxir, "~> 1.1", only: [:dev], runtime: false},
      {:phoenix_pubsub, "~> 2.0"},
      {:ex_doc, "~> 0.24.2", only: [:dev], runtime: false}
    ]
  end

  defp releases do
    [
      foo: [
        include_executables_for: [:unix],
        steps: [:assemble, :tar],
        overlays: ["envs/"],
        path: "_build/rel"
      ]
    ]
  end
end
