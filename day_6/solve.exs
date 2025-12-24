defmodule Day6.Part1 do
  def read_file do
    File.read!("day_6/input.txt")
  end

  def parse(string) do
    [operations | numbers] =
      string
      |> String.split("\n")
      |> Enum.map(&String.split/1)
      |> Enum.reverse()

    numbers
    |> Enum.map(fn line ->
      Enum.map(line, &(Integer.parse(&1) |> elem(0)))
    end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.zip(operations)

    # returns {list of digits, op}[]
  end

  def apply_operation_to_row({list_of_digits, op}) do
    case op do
      "+" -> Enum.sum(list_of_digits)
      "*" -> Enum.product(list_of_digits)
    end
  end

  def solve do
    read_file()
    |> parse()
    |> Enum.map(&apply_operation_to_row/1)
    |> Enum.sum()
  end
end

Day6.Part1.solve() |> IO.inspect()
