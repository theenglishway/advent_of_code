defmodule AdventOfCode.Day8 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_08.txt"

  defp count_digits_with_unique_repr({_, output}) do
    output
    |> Enum.count(& (&1 |> MapSet.size) in [2, 3, 4, 7])
  end

  def get_simple_digits_count(input) do
    input
    |> Enum.map(& count_digits_with_unique_repr/1)
    |> Enum.sum()
  end

  @impl true
  def run(input, 1), do: input |> get_simple_digits_count()

  @impl true
  def get_input() do
    with {:ok, data} <- File.read(@input),
         do: data |> format_input
  end

  def format_input(string),
    do: string |> String.split("\n", trim: true) |> Enum.map(&format_line/1)

  defp format_line(string) do
    [signal, output] = string |> String.split("|")
    {signal |> format_block, output |> format_block}
  end

  defp format_block(string),
    do:
      string
      |> String.trim()
      |> String.split(" ", trim: true)
      |> Enum.map(&(&1 |> String.codepoints() |> MapSet.new()))

  @impl true
  def do_output(out), do: inspect(out)
end
