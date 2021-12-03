defmodule AdventOfCode.Day1 do
  @input "lib/day_1.txt"

  def run() do
    with {:ok, data} <- File.read(@input),
         as_integer_list <- data |> String.split() |> Enum.map(&String.to_integer/1),
         do:
           as_integer_list
           |> Enum.reduce({nil, 0}, fn current, {prev, acc} ->
             {current, if(current > prev, do: acc + 1, else: acc)}
           end)
           |> elem(1)
  end
end
