defmodule AdventOfCode.Day5.Grid do
  alias AdventOfCode.Day5.VentLine
  alias __MODULE__
  defstruct [:max_x, :max_y, points_coverage: %{}]

  def new(list_of_vent_lines) when is_list(list_of_vent_lines) do
    {_, {_, max_x, _}, _} =
      list_of_vent_lines
      |> Enum.max_by(fn {:vent_line, {:coord, start_x, _}, {:coord, end_x, _}} ->
        max(start_x, end_x)
      end)

    {_, {_, _, max_y}, _} =
      list_of_vent_lines
      |> Enum.max_by(fn {:vent_line, {:coord, _, start_y}, {:coord, _, end_y}} ->
        max(start_y, end_y)
      end)

    {:grid, max_x, max_y}
    %Grid{max_x: max_x, max_y: max_y}
  end

  def cover_with_line(grid, vent_line) do
    covered = VentLine.points_covered(vent_line)

    grid
    |> Map.update!(:points_coverage, fn current ->
      covered
      |> Enum.reduce(current, &add_point_coverage(&2, &1))
    end)
  end

  defp add_point_coverage(current, point) do
    current |> Map.update(point, 1, &(&1 + 1))
  end

  def number_of_points_with_coverage_over(%{points_coverage: coverage}, n) do
    coverage |> Map.values() |> Enum.count(&(&1 >= n))
  end
end

defmodule AdventOfCode.Day5.VentLine do
  def is_vertical?({:vent_line, {_, x1, _}, {_, x2, _}}), do: x1 == x2
  def is_horizontal?({:vent_line, {_, _, y1}, {_, _, y2}}), do: y1 == y2
  def is_diagonal?({:vent_line, {_, x1, y1}, {_, x2, y2}}), do: abs(x2 - x1) == abs(y2 - y1)
  def is_straight?(line), do: is_vertical?(line) or is_horizontal?(line)

  def points_covered(line = {:vent_line, {_, x1, y1}, {_, x2, y2}}) do
    cond do
      is_horizontal?(line) -> for x <- x1..x2, do: {x, y1}
      is_vertical?(line) -> for y <- y1..y2, do: {x1, y}
      is_diagonal?(line) -> for x <- x1..x2, y <- y1..y2, abs(x - x1) == abs(y - y1), do: {x, y}
      true -> raise "Can not get coverage for non-straight line"
    end
  end
end

defmodule AdventOfCode.Day5 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_05.txt"

  defmodule FirstHalf do
    alias AdventOfCode.Day5.{Grid, VentLine}

    def get_number_of_overlaps(vent_lines) do
      grid = vent_lines |> Grid.new()

      covered_grid =
        vent_lines
        |> Enum.filter(&VentLine.is_straight?/1)
        |> Enum.reduce(grid, &Grid.cover_with_line(&2, &1))

      covered_grid |> Grid.number_of_points_with_coverage_over(2)
    end
  end

  defmodule SecondHalf do
    alias AdventOfCode.Day5.{Grid, VentLine}

    def get_number_of_overlaps(vent_lines) do
      grid = vent_lines |> Grid.new()

      covered_grid =
        vent_lines
        |> Enum.filter(&(VentLine.is_straight?(&1) or VentLine.is_diagonal?(&1)))
        |> Enum.reduce(grid, &Grid.cover_with_line(&2, &1))

      covered_grid |> Grid.number_of_points_with_coverage_over(2)
    end
  end

  @impl true
  def run(input, 1), do: input |> FirstHalf.get_number_of_overlaps()
  def run(input, 2), do: input |> SecondHalf.get_number_of_overlaps()

  @impl true
  def get_input() do
    with {:ok, data} <- File.read(@input),
         do: data |> into_vents_lines()
  end

  def into_vents_lines(string) when is_binary(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      with [start_, end_] <- line |> String.trim() |> String.split(" -> "),
           list_of_coords <-
             [start_ |> String.split(","), end_ |> String.split(",")] |> Enum.concat(),
           [start_x, start_y, end_x, end_y] <- list_of_coords |> Enum.map(&String.to_integer/1),
           do: {:vent_line, {:coord, start_x, start_y}, {:coord, end_x, end_y}}
    end)
  end

  @impl true
  def do_output(out), do: inspect(out)
end
