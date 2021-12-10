defmodule AdventOfCode.Day10 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_10.txt"
  @characters [
    {:"{", :"}"},
    {:"[", :"]"},
    {:"(", :")"},
    {:<, :>}
  ]
  @opening_characters @characters |> Enum.map(&elem(&1, 0))
  @scores %{"}": 1197, ")": 3, "]": 57, >: 25137}

  def get_syntax_errors(list_of_lines) do
    list_of_lines
    |> Stream.map(&get_first_syntax_error/1)
    |> Stream.filter(fn
      {:error, {:unexpected_closing, _}} -> true
      _ -> false
    end)
    |> Enum.map(fn {:error, {:unexpected_closing, char}} -> char end)
  end

  def get_first_syntax_error(line) do
    opening_to_closing = @characters |> Map.new()

    line
    |> Enum.reduce_while(%{opening_lifo: []}, fn
      char, %{opening_lifo: []} ->
        if char in @opening_characters,
          do: {:cont, %{opening_lifo: [char]}},
          else: {:halt, {:error, {:closing_without_opening, char}}}

      char, %{opening_lifo: lifo = [last_opening | tail]} ->
        cond do
          char in @opening_characters -> {:cont, %{opening_lifo: [char] ++ lifo}}
          char == opening_to_closing |> Map.get(last_opening) -> {:cont, %{opening_lifo: tail}}
          true -> {:halt, {:error, {:unexpected_closing, char}}}
        end
    end)
  end

  @impl true
  def run(input, 1),
    do: input |> get_syntax_errors() |> Stream.map(&(@scores |> Map.get(&1))) |> Enum.sum()

  @impl true
  def get_input() do
    with {:ok, data} <- File.read(@input),
         do: data |> format_input
  end

  def format_input(string),
    do:
      string
      |> String.split("\n", trim: true)
      |> Enum.map(fn line -> line |> String.codepoints() |> Enum.map(&String.to_atom/1) end)

  @impl true
  def do_output(list), do: list |> inspect
end
