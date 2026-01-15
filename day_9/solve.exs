defmodule Day9.Part1 do
  def read_file do
    File.read!("day_9/input.txt")
  end

  def parse_input_into_coords_list(input) when is_binary(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      String.split(line, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
    end)
  end

  def get_all_pairs(coords_list) do
    coords_list
    |> Enum.flat_map(fn cur ->
      coords_list
      |> Enum.map(fn other -> {cur, other} end)
    end)
    |> Enum.uniq()
  end

  def get_area_of_pair({{x1, y1}, {x2, y2}}) do
    (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
  end

  def solve do
    read_file()
    |> parse_input_into_coords_list()
    |> get_all_pairs()
    |> Enum.map(&get_area_of_pair/1)
    |> Enum.max()
  end
end

Day9.Part1.solve() |> IO.inspect()
