defmodule AdventOfCode.Day3 do
  @input "lib/day_3.txt"
  alias __MODULE__

  defmodule FirstHalf do
    @doc """
      iex> AdventOfCode.Day3.FirstHalf.get_gamma_and_epsilon([
      ...>  "00100","11110","10110","10111","10101","01111","00111","11100","10000","11001","00010","01010"
      ...> ])
      {22, 9}
    """
    def get_gamma_and_epsilon(report_list = [first | _]) when is_list(report_list) do
      entry_width = first |> String.length()
      nb_reports = Enum.count(report_list)
      initial_value = Stream.cycle([0]) |> Enum.take(entry_width)

      ones_count =
        report_list
        |> Day3.to_number()
        |> Enum.map(&Day3.to_binary_repr(&1, entry_width))
        |> Enum.reduce(initial_value, &Day3.pairwise_sum/2)

      gamma =
        ones_count |> Enum.map(&if &1 > nb_reports / 2, do: 1, else: 0) |> Integer.undigits(2)

      epsilon =
        ones_count |> Enum.map(&if &1 > nb_reports / 2, do: 0, else: 1) |> Integer.undigits(2)

      {gamma, epsilon}
    end
  end

  def to_number(string_list) when is_list(string_list), do: string_list |> Enum.map(&to_number/1)
  def to_number(string) when is_binary(string), do: string |> String.to_integer(2)

  def to_binary_repr(number, width) when is_integer(number),
    do: number |> Integer.digits(2) |> pad_leading(width)

  def pad_leading(list, target) when is_list(list),
    do: list |> pad_leading(target, Enum.count(list))

  def pad_leading(list, target, size) when size < target, do: ([0] ++ list) |> pad_leading(target)
  def pad_leading(list, target, size) when size == target, do: list

  def pairwise_sum(nb1, nb2), do: nb1 |> Enum.zip_with(nb2, &(&1 + &2))

  def run(1),
    do:
      get_input()
      |> FirstHalf.get_gamma_and_epsilon()
      |> to_output()

  defp get_input() do
    with {:ok, data} <- File.read(@input),
         do: data |> String.split("\n", trim: true)
  end

  defp to_output({gamma, epsilon}), do: gamma * epsilon
end
