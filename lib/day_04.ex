defmodule AdventOfCode.Day4.Bingo do
  defguard is_card_cell(cell)
           when is_tuple(cell) and is_integer(elem(cell, 0)) and is_boolean(elem(cell, 1))

  defguard is_card_row(row) when is_list(row) and is_card_cell(hd(row))
  defguard is_card(game) when is_list(game) and is_card_row(hd(game))
  defguard is_list_of_cards(games) when is_list(games) and is_card(hd(games))
  defguard is_ball_list(list) when is_list(list) and is_integer(hd(list))
  defguard is_bingo(bingo) when is_ball_list(hd(bingo)) and is_list_of_cards(hd(tl(bingo)))

  def play(bingo) when is_bingo(bingo) do
    case bingo |> play_round() do
      {_, [[] | [_cards]]} ->
        :empty_ball_list

      {latest_ball, bingo = [_ | [cards]]} ->
        case cards |> Enum.filter(&is_winning?/1) do
          [] -> {:new_round, bingo, latest_ball}
          [winning_card] -> {:win, bingo, latest_ball, winning_card}
        end
    end
  end

  def play_round(bingo = [ball_list | [cards]]) when is_bingo(bingo) do
    # Draw ball
    {ball, new_ball_list} = ball_list |> List.pop_at(0)

    {ball, [new_ball_list, cards |> Enum.map(&mark_cells(&1, ball))]}
  end

  def card_score(card) when is_card(card),
    do:
      card
      |> Enum.map(fn row ->
        row |> Enum.reject(&is_marked?/1) |> Enum.map(&elem(&1, 0)) |> Enum.sum()
      end)
      |> Enum.sum()

  defp mark_cells(card, ball) when is_card(card), do: card |> Enum.map(&mark_cells(&1, ball))
  defp mark_cells(row, ball) when is_card_row(row), do: row |> Enum.map(&mark_cells(&1, ball))

  defp mark_cells(cell = {number, marked?}, ball) when is_card_cell(cell),
    do: {number, marked? or number == ball}

  defp is_winning?(card) when is_card(card),
    do: card |> is_column_fully_marked? or card |> Enum.any?(&is_row_fully_marked?/1)

  defp is_column_fully_marked?(card) when is_card(card),
    do: card |> transpose |> Enum.any?(&is_row_fully_marked?/1)

  defp transpose(card) when is_card(card), do: card |> List.zip() |> Enum.map(&Tuple.to_list/1)
  defp is_row_fully_marked?(row) when is_card_row(row), do: row |> Enum.all?(&is_marked?/1)
  defp is_marked?(cell = {_, marked?}) when is_card_cell(cell), do: marked?
end

defmodule AdventOfCode.Day4 do
  @behaviour AdventOfCode.Exercise
  @input "lib/day_04.txt"
  require AdventOfCode.Day4.Bingo
  alias AdventOfCode.Day4.Bingo

  defmodule FirstHalf do
    require AdventOfCode.Day4.Bingo
    alias AdventOfCode.Day4.Bingo

    def get_sum_and_latest(bingo) when Bingo.is_bingo(bingo) do
      case bingo |> Bingo.play() do
        {:new_round, bingo, _} ->
          bingo |> get_sum_and_latest()

        {:win, _bingo, latest_ball, winning_card} ->
          {winning_card |> Bingo.card_score(), latest_ball}
      end
    end

    def get_sum_and_latest(_bingo = [ball_list | [cards]]) do
      bingo =
        [ball_list] ++
          [
            cards
            |> Enum.map(fn card ->
              card |> Enum.map(fn row -> row |> Enum.map(fn cell -> {cell, false} end) end)
            end)
          ]

      bingo |> get_sum_and_latest()
    end
  end

  @impl true
  def run(input, 1), do: input |> FirstHalf.get_sum_and_latest()

  @impl true
  def get_input() do
    with {:ok, data} <- File.read(@input),
         [raw_balls | raw_list_of_cards] <-
           data |> String.split("\n\n", trim: true),
         balls <- raw_balls |> String.split(",") |> Enum.map(&String.to_integer/1),
         list_of_cards <-
           raw_list_of_cards
           |> Enum.map(&String.split(&1, "\n", trim: true))
           |> Enum.map(fn list ->
             list
             |> Enum.map(&String.split(&1, " ", trim: true))
             |> Enum.map(fn list -> list |> Enum.map(&{String.to_integer(&1), false}) end)
           end),
         do: [balls, list_of_cards]
  end

  @impl true
  def do_output({sum, latest}), do: sum * latest
end
