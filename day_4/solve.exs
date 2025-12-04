defmodule Day4.Part1 do
  def read_file do
    File.read!("day_4/input.txt")
  end

  def parse_to_grid(str) do
    str
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
    end)
  end

  def grid_to_map(grid) do
    grid
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, i}, map ->
      line
      |> Enum.with_index()
      |> Enum.reduce(map, fn {char, j}, t_map ->
        Map.put(t_map, {i, j}, char)
      end)
    end)
  end

  def get_roll_coords_list(map) do
    map
    |> Enum.reduce([], fn {coords, char}, acc ->
      case char do
        "@" -> [coords | acc]
        _ -> acc
      end
    end)
  end

  def directions do
    [
      {-1, -1},
      {-1, 0},
      {-1, 1},
      {0, -1},
      {0, 1},
      {1, -1},
      {1, 0},
      {1, 1}
    ]
  end

  def is_coord_accessible_with_given_map(map) when is_map(map) do
    fn {i, j} ->
      directions()
      |> Enum.count(fn {a, b} ->
        Map.get(map, {i + a, j + b}) == "@"
      end)
      |> Kernel.<(4)
    end
  end

  def solve do
    map =
      read_file()
      |> parse_to_grid()
      |> grid_to_map()

    map
    |> get_roll_coords_list()
    |> Enum.filter(is_coord_accessible_with_given_map(map))
    |> length()
    |> IO.inspect()
  end
end

defmodule Day4.Part2 do
  import Day4.Part1

  def loop(map, rolls_to_remove_coords_list, rolls_removed_so_far \\ 0) do
    new_map = rolls_to_remove_coords_list
    |> Enum.reduce(map, fn coords, acc ->
      Map.put(acc, coords, "~")
    end)

    new_rolls_to_remove = new_map
    |> get_roll_coords_list()
    |> Enum.filter(is_coord_accessible_with_given_map(new_map))

    new_rolls_removed = rolls_removed_so_far + length(rolls_to_remove_coords_list)

    case new_rolls_to_remove do
      [] -> new_rolls_removed
      _ -> loop(new_map, new_rolls_to_remove, new_rolls_removed)
    end
  end

  def solve do
    map =
      read_file()
      |> parse_to_grid()
      |> grid_to_map()

    rolls_to_remove = map
    |> get_roll_coords_list()
    |> Enum.filter(is_coord_accessible_with_given_map(map))

    loop(map, rolls_to_remove)
    |> IO.inspect()
  end
end

Day4.Part2.solve()
