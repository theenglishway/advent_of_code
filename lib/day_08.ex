defmodule AdventOfCode.Day8 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_08.txt"

  defp count_digits_with_unique_repr({_, output}) do
    output
    |> Enum.count(&((&1 |> MapSet.size()) in [2, 3, 4, 7]))
  end

  def get_simple_digits_count(input) when is_list(input) do
    input
    |> Enum.map(&count_digits_with_unique_repr/1)
    |> Enum.sum()
  end

  def identify_mapping(input) do
    mapping = %{}
    mapping |> identify_bef(input) |> identify_ac(input)
  end

  def identify_ac(mapping, input) do
    by_digit = input |> get_unique_digits_mapping()

    [c] =
      by_digit
      |> Map.get(1)
      |> MapSet.difference(
        MapSet.new([mapping |> Enum.find_value(fn {k, v} -> if v == "f", do: k end)])
      )
      |> Enum.to_list()

    mapping
    |> Map.put(c, "c")
  end

  def identify_bef(mapping, input) do
    count_by_segment = count_segment_apparitions(input)

    mapping
    |> Map.put(count_by_segment |> find_in_count(6), "b")
    |> Map.put(count_by_segment |> find_in_count(4), "e")
    |> Map.put(count_by_segment |> find_in_count(9), "f")
  end

  defp find_in_count(count_by_segment, count),
    do: count_by_segment |> Enum.find_value(fn {k, v} -> if v == count, do: k end)

  def count_segment_apparitions({patterns, _}),
    do:
      patterns
      |> Enum.flat_map(&(&1 |> MapSet.to_list()))
      |> Enum.group_by(& &1)
      |> Map.new(fn {k, v} -> {k, v |> Enum.count()} end)

  def get_unique_digits_mapping({patterns, _}) do
    patterns
    |> Map.new(&{&1, MapSet.size(&1)})
    |> Enum.filter(fn {_, v} -> v in [2, 3, 4, 7] end)
    |> Map.new(fn
      {k, 2} -> {1, k}
      {k, 3} -> {7, k}
      {k, 4} -> {4, k}
      {k, 7} -> {8, k}
    end)
  end

  def get_actual_representation(input) when is_list(input) do
    input
    |> Enum.take(1)
    |> Enum.map(&identify_mapping/1)
  end

  @impl true
  def run(input, 1), do: input |> get_simple_digits_count()
  def run(input, 2), do: input |> get_actual_representation()

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
