defmodule AdventOfCode.Day6.Fish do
  def to_next_day(list) when is_list(list), do: list |> into_map |> to_next_day()

  def to_next_day(map) when is_map(map),
    do:
      map
      |> Map.drop([0, 7])
      |> Map.new(fn {k, v} when k != 0 and k != 7 -> {k - 1, v} end)
      |> Map.put(6, (map |> Map.get(7, 0)) + (map |> Map.get(0, 0)))
      |> Map.put(8, map |> Map.get(0, 0))

  def into_map(list),
    do: list |> Enum.group_by(& &1) |> Map.new(fn {k, v} -> {k, v |> Enum.count()} end)
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
    |> Enum.reduce(fishes_day0, fn _elem, acc -> Fish.to_next_day(acc) end)
    |> Map.values()
    |> Enum.sum()
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
