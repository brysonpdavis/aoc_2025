defmodule Day7.Part1 do
  def read_file do
    File.read!("day_7/input.txt")
  end

  # coords are {row, col}

  def parse_into_grid(string) do
    string
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  # assumes that the start is in the first row, which is true for sample and input
  def get_start_coords_from_grid(grid) do
    {0, grid |> List.first() |> Enum.find_index(fn c -> c == "S" end)}
  end

  def scan_beams_top_to_bottom(grid, beam_cols, splits_so_far \\ 0) do
    case grid do
      [] ->
        splits_so_far

      [cur_line | rem_grid] ->
        {new_beam_cols, new_splits} =
          beam_cols
          |> Enum.reduce({MapSet.new(), 0}, fn beam_col, {cols_set, splits} ->
            if cur_line |> Enum.at(beam_col) |> Kernel.==("^") do
              updated_cols =
                cols_set
                |> MapSet.put(beam_col - 1)
                |> MapSet.put(beam_col + 1)

              {updated_cols, splits + 1}
            else
              new_set = cols_set |> MapSet.put(beam_col)
              {new_set, splits}
            end
          end)

        scan_beams_top_to_bottom(rem_grid, new_beam_cols, splits_so_far + new_splits)
    end
  end

  def solve do
    grid =
      read_file()
      |> parse_into_grid()

    {_row, start_col} = get_start_coords_from_grid(grid)

    scan_beams_top_to_bottom(grid, MapSet.new([start_col]))
  end
end

defmodule Day7.Part2 do
  import Day7.Part1

  def scan_beams_top_to_bottom_2(grid, beam_cols) do
    case grid do
      [] ->
        beam_cols |> Map.values() |> Enum.sum()

      [cur_line | rem_grid] ->
        new_beam_cols =
          beam_cols
          |> Enum.reduce(Map.new(), fn {beam_col, col_count}, cols_map ->
            case cur_line |> Enum.at(beam_col) do
              "^" ->
                cols_map
                |> Map.update(beam_col + 1, col_count, fn x -> x + col_count end)
                |> Map.update(beam_col - 1, col_count, fn x -> x + col_count end)

              _ ->
                cols_map |> Map.update(beam_col, col_count, fn x -> x + col_count end)
            end
          end)

        scan_beams_top_to_bottom_2(rem_grid, new_beam_cols)
    end
  end

  def solve do
    grid =
      read_file()
      |> parse_into_grid()

    {_row, start_col} = get_start_coords_from_grid(grid)

    scan_beams_top_to_bottom_2(grid, Map.new([{start_col, 1}]))
  end
end

Day7.Part2.solve() |> IO.inspect()
