defmodule AdventOfCode.Day7 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_07.txt"
  @doc """

    iex> AdventOfCode.Day7.get_position_and_fuel([16,1,2,0,4,2,7,1,2,14], :constant)
    {2, 37}
    iex> AdventOfCode.Day7.get_position_and_fuel([16,1,2,0,4,2,7,1,2,14], :linear)
    {5, 168}
  """
  def get_position_and_fuel(crabs_list, mode) do
    all_intermediate_pos = (crabs_list |> Enum.min())..(crabs_list |> Enum.max())

    {final_pos, final_list} =
      all_intermediate_pos
      |> Map.new(&{&1, crabs_list |> get_fuel_consumption_for_pos(&1, mode)})
      |> Enum.sort_by(fn {_, v} -> v |> Enum.sum() end)
      |> hd

    {final_pos, final_list |> Enum.sum()}
  end

  defp get_fuel_consumption_for_pos(crabs_list, new_pos, :constant),
    do:
      crabs_list
      |> Enum.map(&abs(&1 - new_pos))

  defp get_fuel_consumption_for_pos(crabs_list, new_pos, :linear),
    do:
      crabs_list
      |> Enum.map(fn start_pos ->
        steps = abs(start_pos - new_pos)
        (steps * (steps + 1)) |> div(2)
      end)

  @impl true
  def run(input, 1), do: input |> get_position_and_fuel(:constant)
  def run(input, 2), do: input |> get_position_and_fuel(:linear)

  @impl true
  def get_input() do
    with {:ok, data} <- File.read(@input),
         do: data |> into_crabs_list
  end

  defp into_crabs_list(string),
    do: string |> String.split(~r"\W", trim: true) |> Enum.map(&String.to_integer(&1))

  @impl true
  def do_output(out), do: inspect(out)
end
