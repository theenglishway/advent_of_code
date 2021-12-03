defmodule Mix.Tasks.Runner do
  @moduledoc "A simple runner for the exercises"

  use Mix.Task
  alias AdventOfCode.Exercise
  @all_days 1..3

  @impl Mix.Task
  def run([day, half]) do
    print_exercise({day |> String.to_integer(), half |> String.to_integer()})
  end

  def run([]) do
    for(day <- @all_days, half <- 1..2, do: {day, half})
    |> Enum.each(&print_exercise/1)
  end

  defp print_exercise({day, half}) do
    result = Exercise.run(day, half)

    Mix.shell().info("Day #{day} / Half #{half} : #{result}")
  end
end
