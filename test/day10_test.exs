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

  test "should work on second half" do
    completion = @input |> Day10.format_input() |> Day10.get_completion()

    assert completion ==
             [
               ~W"} } ] ] ) } ) ]"a,
               ~W") } > ] } )"a,
               ~W"} } > } > ) ) ) )"a,
               ~W"] ] } } ] } ] } >"a,
               ~W"] ) } >"a
             ]

    assert completion |> Day10.into_score() == 288_957
  end
end
