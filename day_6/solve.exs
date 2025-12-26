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

    # returns {int[], op}[]
  end

  def apply_operation_to_row({list_of_digits, "+"}) do
    Enum.sum(list_of_digits)
  end

  def apply_operation_to_row({list_of_digits, "*"}) do
    Enum.product(list_of_digits)
  end

  def solve do
    read_file()
    |> parse()
    |> Enum.map(&apply_operation_to_row/1)
    |> Enum.sum()
  end
end

defmodule Day6.Part2 do
  import Day6.Part1

  # chunk structure is {int[], op}

  def separate_first_int_from_rows(lines) do
    {int, _} =
      lines
      |> Enum.map(&hd/1)
      |> Enum.filter(fn c -> c != " " end)
      |> Enum.join()
      |> Integer.parse()

    rem_lines = lines |> Enum.map(&tl/1)

    {int, rem_lines}
  end

  def get_op_from_start_of_chunk(lines) do
    lines |> List.last() |> List.first()
  end

  def get_chunks_recursive(lines_rem, complete_chunks, cur_chunk = {cur_ints, op}) do
    lines_empty = lines_rem |> Enum.all?(&Enum.empty?/1)

    if lines_empty do
      [cur_chunk | complete_chunks]
    else
      firsts_all_blank = lines_rem |> Enum.map(&List.first/1) |> Enum.all?(&(&1 == " "))

      if firsts_all_blank do
        tails = lines_rem |> Enum.map(&tl/1)
        new_chunks = [cur_chunk | complete_chunks]
        new_op = get_op_from_start_of_chunk(tails)

        get_chunks_recursive(tails, new_chunks, {[], new_op})
      else
        {int, tails} = separate_first_int_from_rows(lines_rem)

        get_chunks_recursive(tails, complete_chunks, {[int | cur_ints], op})
      end
    end
  end

  def get_chunks(grapheme_lines) do
    op = get_op_from_start_of_chunk(grapheme_lines)
    get_chunks_recursive(grapheme_lines, [], {[], op})
  end

  def parse2(string) when is_binary(string) do
    string
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> get_chunks()

    # returns {int[], op}[]
  end

  def solve do
    read_file()
    |> parse2()
    |> Enum.map(&apply_operation_to_row/1)
    |> Enum.sum()
  end
end

Day6.Part2.solve() |> IO.inspect()
