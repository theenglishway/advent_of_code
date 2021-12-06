defmodule AdventOfCode.Day6.Fish do
  def to_next_day(list) when is_list(list) do
    {updated, tail} =
      list
      |> Enum.reduce({[], []}, fn
        0, {current, new_tail} -> {current ++ [6], new_tail ++ [8]}
        element, {current, new_tail} -> {current ++ [element - 1], new_tail}
      end)

    updated ++ tail
  end
end

defmodule AdventOfCode.Day6 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_06.txt"
  alias AdventOfCode.Day6.Fish

  defmodule FirstHalf do
    @doc """

      iex> AdventOfCode.Day6.FirstHalf.get_number_of_fishes([3,4,3,1,2], 18)
      26
    """
    def get_number_of_fishes(fishes_day0, nb_days) do
      1..nb_days
      |> Enum.reduce(fishes_day0, fn elem, acc ->
        Fish.to_next_day(acc) |> IO.inspect(label: elem)
      end)
      |> Enum.count()
    end
  end

  defmodule SecondHalf do
    def get_number_of_fishes(fishes_day0, nb_days) do
    end
  end

  @impl true
  def run(input, 1), do: input |> FirstHalf.get_number_of_fishes(80)

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
