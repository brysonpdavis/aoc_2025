defmodule Day3.Part1 do
  def read_file do
    File.read!("day_3/input.txt")
  end

  def find_joltage(list) when is_list(list) do
    first_max = list
    |> Enum.drop(-1)
    |> Enum.max()

    max_idx = Enum.find_index(list, fn x -> x == first_max end)

    second_max = list
    |> Enum.drop(max_idx + 1)
    |> Enum.max()

    (first_max * 10) + second_max
  end

  def parse_input(input) when is_binary(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def solve do
    read_file()
    |> parse_input()
    |> Enum.map(&find_joltage/1)
    |> Enum.sum()
    |> IO.inspect()
  end
end

defmodule Day3.Part2 do
  import Day3.Part1

  def find_next_digits(list, rem_digits, sum \\ 0) when is_list(list) and is_integer(rem_digits) do
    case rem_digits do
      1 -> Enum.max(list) + sum
      _ ->
        rem_digits = rem_digits - 1

        max = list
          |> Enum.drop(-1 * rem_digits)
          |> Enum.max()

        new_sum = sum + max * 10 ** rem_digits
        max_idx = Enum.find_index(list, fn x -> x == max end)
        rem_list = Enum.drop(list, max_idx + 1)

        find_next_digits(rem_list, rem_digits, new_sum)
    end
  end

  def find_new_joltage(list) when is_list(list) do
    list
    |> find_next_digits(12)
  end

  def solve do
    read_file()
    |> parse_input()
    |> Enum.map(&find_new_joltage/1)
    |> Enum.sum()
    |> IO.inspect()
  end
end

Day3.Part2.solve()
