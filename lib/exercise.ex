defmodule AdventOfCode.Exercise do
  @callback get_input() :: any()
  @callback run(any(), integer) :: any()
  @callback do_output(any()) :: any()

  def run(day, half) when is_integer(day) and half in [1, 2] do
    module = Module.concat(AdventOfCode, "Day#{day}")

    module.get_input()
    |> module.run(half)
    |> module.do_output()
  end
end
