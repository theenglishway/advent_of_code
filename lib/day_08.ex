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

  def identify_mapping(input),
    do: %{} |> identify_bef_segments(input) |> identify_other_segments(input)

  def identify_bef_segments(mapping, input) do
    # If we count the number of times each segment of the display is
    # enabled when we try to display all the numbers from 0 to 9, we
    # have the following results :
    # a => 8, b => 6, c => 8, d => 7, e => 4, f => 9, g => 7
    # It is therefore very easy to identify segments b, e, and f since
    # they are the only ones to appear respectively 6, 4, and 9 times
    # in total.
    count_by_segment = count_segment_apparitions(input)

    mapping
    |> Map.put(count_by_segment |> find_in_count(6), {:output, "b"})
    |> Map.put(count_by_segment |> find_in_count(4), {:output, "e"})
    |> Map.put(count_by_segment |> find_in_count(9), {:output, "f"})
  end

  defp find_in_count(count_by_segment, count),
    do: count_by_segment |> Enum.find_value(fn {k, v} -> if v == count, do: k end)

  def count_segment_apparitions({patterns, _}),
    do:
      patterns
      |> Enum.flat_map(&(&1 |> MapSet.to_list()))
      |> Enum.group_by(& &1)
      |> Map.new(fn {k, v} -> {k, v |> Enum.count()} end)

  def identify_other_segments(mapping, input) do
    # At this point we have identified segments b, e, and f.
    #
    # Other segments are identified by applying some simple observations :
    #   * digit "1" is displayed using segments "c", and "f"
    #       * "f" is already known
    #       * => "c" is now identified
    #   * digit "7" is displayed with segments "a", "c", and "f"
    #       * "c" and "f" are already known
    #       * => "a" is now identified
    #   * digit "4" is displayed with segments "b", "c", "d" and "f"
    #       * "b", "c" and "f" are already known
    #       * => "d" is now identified
    #   * digit "8" is displayed with all the segments, and at this point, all
    # segments but "g" have been identified
    #
    # All those digits are easy to identify via `get_unique_digits_mapping`

    by_digit = input |> get_unique_digits_mapping()

    mapping = mapping |> Map.put(identity_extra(mapping, by_digit, 1), {:output, "c"})
    mapping = mapping |> Map.put(identity_extra(mapping, by_digit, 7), {:output, "a"})
    mapping = mapping |> Map.put(identity_extra(mapping, by_digit, 4), {:output, "d"})
    mapping = mapping |> Map.put(identity_extra(mapping, by_digit, 8), {:output, "g"})

    mapping
  end

  defp identity_extra(mapping, digits_map, digit) do
    signal_for_digit = digits_map |> Map.get({:digit, digit})
    signals_known = mapping |> Map.keys()

    [extra_signal] =
      signal_for_digit |> MapSet.difference(signals_known |> MapSet.new()) |> Enum.to_list()

    extra_signal
  end

  def get_unique_digits_mapping({patterns, _}) do
    # Digits 1, 4, 7, and 8 can be easily identified in the input because
    # they are the only ones to have, respectively, 2, 3, 4, and 7 segments enabled

    patterns
    |> Map.new(&{&1, MapSet.size(&1)})
    |> Enum.filter(fn {_, v} -> v in [2, 3, 4, 7] end)
    |> Map.new(fn
      {k, 2} -> {{:digit, 1}, k}
      {k, 3} -> {{:digit, 7}, k}
      {k, 4} -> {{:digit, 4}, k}
      {k, 7} -> {{:digit, 8}, k}
    end)
  end

  def into_numbers(input = {signals, output}) do
    mapping = input |> identify_mapping
    signals_mapping = signals |> Map.new(&{&1, signal_to_output(&1, mapping)})

    output
    |> Enum.map(&(signals_mapping |> Map.get(&1)))
    |> Integer.undigits()
  end

  defp signal_to_output(signal, mapping) do
    signal |> MapSet.new(&(mapping |> Map.get(&1))) |> as_digit()
  end

  defp as_digit(output) do
    case output |> Enum.to_list() |> Enum.map(fn {_, v} -> v end) do
      ~w[a b c e f g] -> 0
      ~w[c f] -> 1
      ~w[a c d e g] -> 2
      ~w[a c d f g] -> 3
      ~w[b c d f] -> 4
      ~w[a b d f g] -> 5
      ~w[a b d e f g] -> 6
      ~w[a c f] -> 7
      ~w[a b c d e f g] -> 8
      ~w[a b c d f g] -> 9
    end
  end

  def get_actual_representation(input) when is_list(input) do
    input
    |> Enum.map(&into_numbers/1)
  end

  @impl true
  def run(input, 1), do: input |> get_simple_digits_count()
  def run(input, 2), do: input |> get_actual_representation() |> Enum.sum()

  @impl true
  def get_input() do
    with {:ok, data} <- File.read(@input),
         do: data |> format_input
  end

  def format_input(string),
    do: string |> String.split("\n", trim: true) |> Enum.map(&format_line/1)

  defp format_line(string) do
    [signal, output] = string |> String.split("|")
    {signal |> format_block(:signal), output |> format_block(:signal)}
  end

  defp format_block(string, type),
    do:
      string
      |> String.trim()
      |> String.split(" ", trim: true)
      |> Enum.map(fn string ->
        string |> String.codepoints() |> Enum.map(&{type, &1}) |> MapSet.new()
      end)

  @impl true
  def do_output(out), do: inspect(out)
end
