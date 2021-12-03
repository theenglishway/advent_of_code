defmodule AdventOfCode.Exercise do
  @callback run(integer) :: any()

  def run(day, half) when is_integer(day) and half in [1, 2] do
    module = Module.concat(AdventOfCode, "Day#{day}")
    module.run(half)
  end
end
