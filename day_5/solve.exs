defmodule Day5.Part1 do
  def read_file do
    File.read!("day_5/input.txt")
  end

  def parse(string) when is_binary(string) do
    [str1 | [str2]] = string
    |> String.split("\n\n")

    ranges = str1
    |> String.split("\n")
    |> Enum.map(fn str ->
      [r1 | [r2]] = str
      |> String.split("-")
      |> Enum.map(&(Integer.parse(&1) |> elem(0)))

      Range.new(r1, r2)
    end)

    nums = str2
      |> String.split("\n")
      |> Enum.map(&(Integer.parse(&1) |> elem(0)))

    {ranges, nums}
  end

  def find_nums_within_ranges({ranges, nums}) do
    nums
    |> Enum.filter(fn num ->
      ranges
      |> Enum.any?(&(num in &1))
    end)
  end

  def solve do
    read_file()
    |> parse()
    |> find_nums_within_ranges()
    |> length()
  end
end

defmodule Day5.Part2 do
  import Day5.Part1

  def find_fresh_ingredients_from_ranges(ranges) do
    ranges
    |> Enum.reduce(MapSet.new(), fn range, set ->
      Enum.reduce(range, set, fn int, set ->
        set
        |> MapSet.put(int)
      end)
    end)
    |> MapSet.size()
  end

  def solve_brute_force do
    {ranges, _} = read_file()
    |> parse()

    ranges
    |> find_fresh_ingredients_from_ranges()
  end

  def difference_of_two_ranges(a_start..a_end = range_a, b_start..b_end = range_b) do
    # Normalize ranges to ensure start <= end for easier logic
    {s1, e1} = if a_start <= a_end, do: {a_start, a_end}, else: {a_end, a_start}
    {s2, e2} = if b_start <= b_end, do: {b_start, b_end}, else: {b_end, b_start}

    cond do
      # 1. No overlap
      e2 < s1 or s2 > e1 ->
        [range_a]

      # 2. B fully covers A
      s2 <= s1 and e2 >= e1 ->
        []

      # 3. B is strictly inside A (The Split)
      s2 > s1 and e2 < e1 ->
        [s1..(s2 - 1), (e2 + 1)..e1]

      # 4. B overlaps the left side of A
      s2 <= s1 and e2 < e1 ->
        [(e2 + 1)..e1]

      # 5. B overlaps the right side of A
      s2 > s1 and e2 >= e1 ->
        [s1..(s2 - 1)]
    end
  end

  def find_difference_of_many_ranges(prev_ranges, new_range) do
    prev_ranges
    |> Enum.reduce([new_range], fn cur_range, new_ranges ->
      # given a new range and a previously existing range,
      # find the remaining difference(s), and return them
      new_ranges
      |> Enum.flat_map(&(difference_of_two_ranges(&1, cur_range)))
    end)
  end

  def find_fresh_ingredients_from_ranges_fast(ranges) do
    ranges
    |> Enum.reduce([], fn cur_range, deduped_range_set ->
      # from a set of ranges, find the range or ranges that have no overlap
      # with previous ranges, and add them to the deduped_range_set
      deduped_range_set
      |> find_difference_of_many_ranges(cur_range)
      |> Enum.concat(deduped_range_set)
    end)
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
  end

  def solve do
    {ranges, _} = read_file()
    |> parse()

    ranges
    |> find_fresh_ingredients_from_ranges_fast()

  end
end

Day5.Part2.solve() |> IO.inspect()
