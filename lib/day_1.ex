defmodule AdventOfCode.Day1 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_1.txt"

  @doc """
    iex> AdventOfCode.Day1.count_increases([199,200,208,210,200,207,240,269,260,263])
    7
  """
  def count_increases(integers_list) when is_list(integers_list),
    do:
      integers_list
      |> Enum.reduce({nil, 0}, fn
        current, {nil, acc} -> {current, acc}
        current, {prev, acc} when current > prev -> {current, acc + 1}
        current, {_prev, acc} -> {current, acc}
      end)
      |> elem(1)

  @doc """
    iex> AdventOfCode.Day1.count_increases_sliding_window([199,200,208,210,200,207,240,269,260,263])
    5
  """
  def count_increases_sliding_window(integers_list) when is_list(integers_list),
    do:
      integers_list
      |> Enum.reduce({new_window(), 0}, fn
        element, {current_window, acc} ->
          new_window = current_window |> update_window(element)
          new_acc = if has_increased?(current_window, new_window), do: acc + 1, else: acc
          {new_window, new_acc}
      end)
      |> elem(1)

  defp new_window(), do: {nil, nil, nil}
  defp update_window({_el1, el2, el3}, new), do: {el2, el3, new}

  defp has_increased?(window1, window2) do
    cond do
      window1 |> Tuple.to_list() |> Enum.any?(&is_nil/1) -> false
      true -> Tuple.sum(window2) > Tuple.sum(window1)
    end
  end

  @impl true
  def run(input, 1), do: input |> count_increases()
  def run(input, 2), do: input |> count_increases_sliding_window()

  @impl true
  def get_input() do
    with {:ok, data} <- File.read(@input),
         do: data |> String.split() |> Enum.map(&String.to_integer/1)
  end

  @impl true
  def do_output(res), do: res
end
