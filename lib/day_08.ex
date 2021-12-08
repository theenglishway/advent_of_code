defmodule AdventOfCode.Day8 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_07.txt"
  @doc """

    iex> AdventOfCode.Day8.do_stuff([16,1,2,0,4,2,7,1,2,14])
    nil
  """
  def do_stuff(input) do
    input
  end

  @impl true
  def run(input, 1), do: input |> do_stuff()

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
