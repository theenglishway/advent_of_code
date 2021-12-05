defmodule AdventOfCodeDay5Test do
  use ExUnit.Case
  alias AdventOfCode.Day5
  alias AdventOfCode.Day5.{FirstHalf, SecondHalf}
  doctest FirstHalf

  @input """
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
  """

  test "should work on first half" do
    assert @input |> Day5.into_vents_lines() |> FirstHalf.get_number_of_overlaps() == 5
  end

  test "should work on second half" do
    assert @input |> Day5.into_vents_lines() |> SecondHalf.get_number_of_overlaps() == 12
  end
end
