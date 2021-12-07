defmodule AdventOfCode.Day7 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_07.txt"

  def do_stuff(input) do
    input
  end

  @impl true
  def run(input, 1), do: input |> do_stuff()

  @impl true
  def get_input() do
    with {:ok, data} <- File.read(@input),
         do: data
  end

  @impl true
  def do_output(out), do: inspect(out)
end
