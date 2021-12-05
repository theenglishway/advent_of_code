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
         do: data
  end

  @impl true
  def do_output(out), do: inspect(out)
end
