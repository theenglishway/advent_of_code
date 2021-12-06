defmodule AdventOfCode.Day6 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_06.txt"

  defmodule FirstHalf do
    def get_number_of_fishes(fishes_day0, nb_days) do

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
         do: data
  end


  @impl true
  def do_output(out), do: inspect(out)
end
