defmodule AdventOfCode.Day5 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_05.txt"

  defmodule FirstHalf do
    def get_number_of_overlaps(vents) do
      vents
    end
  end

  @impl true
  def run(input, 1), do: input |> FirstHalf.get_number_of_overlaps()

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
