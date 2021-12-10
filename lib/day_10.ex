defmodule AdventOfCode.Day10 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_10.txt"
  @characters [
    {:"{", :"}"},
    {:"[", :"]"},
    {:"(", :")"},
    {:<, :>}
  ]
  @opening_to_closing @characters |> Map.new()
  @opening_characters @characters |> Enum.map(&elem(&1, 0))
  @syntax_error_scores %{")": 3, "]": 57, "}": 1_197, >: 25_137}
  @completion_scores %{")": 1, "]": 2, "}": 3, >: 4}

  def get_syntax_errors(list_of_lines) do
    list_of_lines
    |> Stream.map(&parse_line/1)
    |> Stream.filter(fn
      {:error, {:unexpected_closing, _}} -> true
      _ -> false
    end)
    |> Enum.map(fn {:error, {:unexpected_closing, char}} -> char end)
  end

  def parse_line(line) do
    line
    |> Enum.reduce_while(%{opening_lifo: []}, fn
      char, %{opening_lifo: []} ->
        if char in @opening_characters,
          do: {:cont, %{opening_lifo: [char]}},
          else: {:halt, {:error, {:closing_without_opening, char}}}

      char, %{opening_lifo: lifo = [last_opening | tail]} ->
        cond do
          char in @opening_characters -> {:cont, %{opening_lifo: [char] ++ lifo}}
          char == @opening_to_closing |> Map.get(last_opening) -> {:cont, %{opening_lifo: tail}}
          true -> {:halt, {:error, {:unexpected_closing, char}}}
        end
    end)
  end

  def get_completion(list_of_lines) do
    list_of_lines
    |> Stream.map(&parse_line/1)
    |> Stream.filter(fn
      %{opening_lifo: lifo} when lifo != [] -> true
      _ -> false
    end)
    |> Stream.map(&get_line_completion/1)
    |> Enum.to_list()
  end

  def get_line_completion(%{opening_lifo: list}) do
    list |> Enum.map(&(@opening_to_closing |> Map.get(&1)))
  end

  @impl true
  def run(input, 1),
    do:
      input
      |> get_syntax_errors()
      |> Stream.map(&(@syntax_error_scores |> Map.get(&1)))
      |> Enum.sum()

  def run(input, 2),
    do: input |> get_completion() |> into_score()

  def into_score(output),
    do: output |> Stream.map(&into_line_score/1) |> Enum.sort() |> take_median()

  def into_line_score(line, score \\ 0)
  def into_line_score([], score), do: score

  def into_line_score([head | tail], score),
    do: tail |> into_line_score(score * 5 + (@completion_scores |> Map.get(head)))

  defp take_median(list) do
    count = Enum.count(list)
    list |> Enum.at(div(count, 2))
  end

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
