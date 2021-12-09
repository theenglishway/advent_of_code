defmodule AdventOfCode.Day9 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_09.txt"

  def do_stuff(input) do
    input
  end

  @impl true
  def run(input, 1), do: input |> do_stuff()

  @impl true
  def get_input() do
    with {:ok, data} <- File.read(@input),
         do: data |> format_input
  end

  def format_input(string), do: string

  @impl true
  def do_output(out), do: inspect(out)
end
