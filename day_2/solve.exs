defmodule Day2.Part2 do
  def read_file do
    File.read!("day_2/input.txt")
  end

  def parse_input(input) when is_binary(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-"))
  end

  def is_invalid_id?(int) when is_integer(int) do
    text_int = Integer.to_string(int)
    text_len = String.length(text_int)
    max_substr_len = div(text_len, 2)

    case text_len do
      # can't be a single-digit number
      1 ->
        false

      _ ->
        1..max_substr_len
        |> Enum.any?(fn substr_len ->
          text_int
          |> String.slice(0..(substr_len - 1))
          # for part 1, replace `div(text_len, substr_len)` with `2` since the string can only repeat twice
          |> String.duplicate(div(text_len, substr_len))
          |> String.equivalent?(text_int)
        end)
    end
  end

  def find_invalid_ids_in_range_of_pair([hd, tl]) when is_binary(hd) and is_binary(tl) do
    Enum.filter(String.to_integer(hd)..String.to_integer(tl), &is_invalid_id?/1)
  end

  def solve do
    read_file()
    |> parse_input()
    |> Enum.map(&find_invalid_ids_in_range_of_pair/1)
    |> List.flatten()
    |> Enum.sum()
    |> IO.inspect()
  end
end

Day2.Part2.solve()
