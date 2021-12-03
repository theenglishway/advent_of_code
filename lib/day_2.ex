defmodule AdventOfCode.Day2 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_2.txt"

  defmodule FirstHalf do
    @doc """
      iex> AdventOfCode.Day2.FirstHalf.get_position_and_depth(["forward 5","down 5","forward 8","up 3","down 8","forward 2"])
      {15, 10}
    """
    def get_position_and_depth(list_of_instructions) when is_list(list_of_instructions) do
      list_of_instructions
      |> Enum.map(&decode/1)
      |> Enum.reduce({0, 0}, &apply_instruction(&2, &1))
    end

    defp decode(raw_instruction) do
      with [instruction, value] <- raw_instruction |> String.split(),
           do: {instruction |> String.to_atom(), value |> String.to_integer()}
    end

    defp apply_instruction({pos, depth}, {:forward, val}), do: {pos + val, depth}
    defp apply_instruction({pos, depth}, {:down, val}), do: {pos, depth + val}
    defp apply_instruction({pos, depth}, {:up, val}), do: {pos, depth - val}
  end

  defmodule SecondHalf do
    @doc """
      iex> AdventOfCode.Day2.SecondHalf.get_position_and_depth(["forward 5","down 5","forward 8","up 3","down 8","forward 2"])
      {15, 60}
    """
    def get_position_and_depth(list_of_instructions) when is_list(list_of_instructions) do
      {pos, depth, _} =
        list_of_instructions
        |> Enum.map(&decode/1)
        |> Enum.reduce({0, 0, 0}, &apply_instruction(&2, &1))

      {pos, depth}
    end

    defp decode(raw_instruction) do
      with [instruction, value] <- raw_instruction |> String.split(),
           do: {instruction |> String.to_atom(), value |> String.to_integer()}
    end

    defp apply_instruction({pos, depth, aim}, {:forward, val}),
      do: {pos + val, depth + val * aim, aim}

    defp apply_instruction({pos, depth, aim}, {:down, val}), do: {pos, depth, aim + val}
    defp apply_instruction({pos, depth, aim}, {:up, val}), do: {pos, depth, aim - val}
  end

  @impl true
  def run(input, 1), do: input |> FirstHalf.get_position_and_depth()
  def run(input, 2), do: input |> SecondHalf.get_position_and_depth()

  @impl true
  def get_input() do
    with {:ok, data} <- File.read(@input),
         do: data |> String.split("\n", trim: true)
  end

  @impl true
  def do_output({pos, depth}), do: pos * depth
end
