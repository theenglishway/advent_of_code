defmodule Mix.Tasks.Runner do
  @moduledoc "A simple runner for the exercises"
  use Mix.Task
  alias AdventOfCode.Exercise

  @shortdoc "Run exercise from day `day`"
  @impl Mix.Task
  def run([day, half]) do
    Exercise.run(day |> String.to_integer(), half |> String.to_integer())
    |> inspect
    |> Mix.shell().info()
  end
end
