defmodule AdventOfCode2025.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code_2025,
      version: "0.1.0",
      elixir: "1.15.5",
      deps: deps(),
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end


  defp deps do
    [
      {:libgraph, "0.16.0"}
    ]
  end
end
