defmodule TakeANumber.MixProject do
  use Mix.Project

  def project do
    [
      app: :take_a_number,
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
       {:mix_test_watch, "~> 1.0", only: [:dev], runtime: false}
    ]
  end
end
