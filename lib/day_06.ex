defmodule AdventOfCode.Day6.Fish do
  def to_next_day(list) when is_list(list) do
    new_ = list |> new_fishes()
    (list |> update_list()) ++ new_
  end

  defp into_map(list) do
    list |> Enum.group_by(& &1) |> Map.new(fn {k, v} -> {k, v |> Enum.count()})
  end

  defp update_list(current) do
    current
    |> Enum.map(fn
      0 -> 6
      element -> element - 1
    end)
  end

  defp new_fishes(current) do
    nb = current |> Enum.count(&(&1 == 0))
    Stream.cycle([8]) |> Enum.take(nb)
  end

  def to_next_day(list) when is_list(list) do
    {updated, tail} =
      list
      |> Enum.reduce({[], []}, fn
        0, {current, new_tail} -> {[6 | current], [8 | new_tail]}
        element, {current, new_tail} -> {[element - 1 | current], new_tail}
      end)

    (updated |> Enum.reverse()) ++ tail
  end
end

defmodule AdventOfCode.Day6 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_06.txt"
  alias AdventOfCode.Day6.Fish

  @doc """

    iex> AdventOfCode.Day6.get_number_of_fishes([3,4,3,1,2], 18)
    26
    iex> AdventOfCode.Day6.get_number_of_fishes([3,4,3,1,2], 256)
    26984457539
  """
  def get_number_of_fishes(fishes_day0, nb_days) do
    1..nb_days
    |> Enum.reduce(fishes_day0, fn elem, acc ->
      Fish.to_next_day(acc) |> IO.inspect(label: elem)
    end)
    |> Enum.count()
  end

  @impl true
  def run(input, 1), do: input |> get_number_of_fishes(80)
  def run(input, 2), do: input |> get_number_of_fishes(256)

  @impl true
  def get_input() do
    with {:ok, data} <- File.read(@input),
         do: data |> into_fishes_list
  end

  defp into_fishes_list(string),
    do: string |> String.split(~r"\W", trim: true) |> Enum.map(&String.to_integer(&1))

  @impl true
  def do_output(out), do: inspect(out)
end
