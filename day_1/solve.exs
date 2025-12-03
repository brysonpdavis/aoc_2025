defmodule Day1.Part1 do
  defp parse_line(line) do
    {dir, num} = line
    |> String.split_at(1)

    case dir do
      "L" -> String.to_integer(num) * -1
      "R" -> String.to_integer(num)
    end
  end

  def read_file() do
    File.read!("day_1/input.txt")
  end

  def parse_input(input) when is_binary(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def loop(delta, {cur_x, zero_hits}) when is_integer(delta) and is_integer(cur_x) and is_integer(zero_hits) do
    new_x = cur_x + delta
    zero_hits = if rem(new_x, 100) == 0, do: zero_hits + 1, else: zero_hits

    {new_x, zero_hits}
  end

  def solve do
    read_file()
    |> parse_input()
    |> Enum.reduce({50, 0}, &loop/2)
    |> elem(1)
    |> IO.inspect()
  end
end

defmodule Day1.Part2 do
  import Day1.Part1

  def loop_2(delta, {cur_x, zero_hits}) when is_integer(delta) and is_integer(cur_x) and is_integer(zero_hits) do
    new_x = cur_x + delta
    ints_between = tl(Range.to_list(cur_x..new_x))
    zero_hits = zero_hits + Enum.sum(for x <- ints_between, do: (if rem(x, 100) == 0, do: 1, else: 0))

    {new_x, zero_hits}
  end

  def solve do
    read_file()
    |> parse_input()
    |> Enum.reduce({50, 0}, &loop_2/2)
    |> elem(1)
    |> IO.inspect()
  end
end

Day1.Part2.solve()
