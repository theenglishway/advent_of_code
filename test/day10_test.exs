defmodule AdventOfCodeDay10Test do
  use ExUnit.Case
  alias AdventOfCode.Day10

  @input """
  [({(<(())[]>[[{[]{<()<>>
  [(()[<>])]({[<{<<[]>>(
  {([(<{}[<>[]}>{[]{[(<()>
  (((({<>}<{<{<>}{[]{[]{}
  [[<[([]))<([[{}[[()]]]
  [{[{({}]{}}([{[{{{}}([]
  {<[[]]>}<{[{[{[]{()[[[]
  [<(<(<(<{}))><([]([]()
  <{([([[(<>()){}]>(<<{{
  <{([{{}}[<[[[<>{}]]]>[]]
  """

  test "should work on first half" do
    assert @input |> Day10.format_input() |> Day10.get_syntax_errors() |> Enum.sort() ==
             ~W") ) > ] }"a
  end
end
