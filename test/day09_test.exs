defmodule AdventOfCodeDay9Test do
  use ExUnit.Case
  alias AdventOfCode.Day9

  @input """
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
  """

  test "should work on first half" do
    assert @input |> Day9.format_input() |> Day9.get_low_points_heights() |> Enum.sort() == [
             1,
             2,
             6,
             6
           ]
  end
  end
end
