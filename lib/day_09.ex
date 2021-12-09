defmodule AdventOfCode.Day9 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_09.txt"

  def get_low_points(input) do
    input
    |> Stream.filter(fn {{x0, y0}, _} -> is_lower_than_neighbours?(input, x0, y0) end)
    |> Enum.map(fn {_, height} -> height + 1 end)
  end

  defp is_lower_than_neighbours?(full_map, x0, y0) do
    height0 = full_map |> Map.get({x0, y0})

    full_map
    |> Stream.filter(fn {{x, y}, _} ->
      (x == x0 and abs(y - y0) == 1) or (abs(x - x0) == 1 and y == y0)
    end)
    |> Enum.all?(fn {_, height} -> height > height0 end)
  end

  @impl true
  def run(input, 1), do: input |> get_low_points()

  @impl true
  def get_input() do
    with {:ok, data} <- File.read(@input),
         do: data |> format_input
  end

  def format_input(string),
    do:
      string
      |> String.split("\n", trim: true)
      |> Stream.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.codepoints()
        |> Stream.with_index()
        |> Stream.map(fn {val, x} -> %{x: x, y: y, height: val |> String.to_integer()} end)
      end)
      |> Map.new(fn %{x: x, y: y, height: val} -> {{x, y}, val} end)

  @impl true
  def do_output(list), do: list |> Enum.sum()
end
