defmodule AdventOfCode.Day9 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_09.txt"

  def get_low_points(input),
    do:
      input
      |> with_neighbours()
      |> Stream.filter(fn {{_, height0}, neighbours} ->
        neighbours |> Enum.all?(fn {_, height} -> height > height0 end)
      end)

  def get_low_points_heights(input),
    do:
      input
      |> get_low_points()
      |> Enum.map(fn {{_, height0}, _} -> height0 + 1 end)

  def with_neighbours(full_map),
    do:
      full_map
      |> Stream.map(fn v0 -> {v0, full_map |> get_neighbours(v0)} end)

  defp get_neighbours(full_map, {{x0, y0}, _}) do
    neighbours = [{x0 + 1, y0}, {x0 - 1, y0}, {x0, y0 + 1}, {x0, y0 - 1}]
    full_map |> Map.take(neighbours)
  end

  def get_basins(input) do
    low_points = input |> get_low_points() |> Stream.map(fn {{coords, _}, _} -> coords end)

    low_points |> Enum.map(&find_basin_from(&1, input))
  end

  def find_basin_from(low_point, full_input) do
    low_point
  end

  @impl true
  def run(input, 1), do: input |> get_low_points_heights() |> Enum.sum()
  def run(input, 2), do: input |> get_basins()

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
  def do_output(list), do: list |> inspect
end
