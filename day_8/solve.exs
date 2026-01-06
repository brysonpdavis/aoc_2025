defmodule Day8.Part1 do
    def read_file do
        File.read!("day_8/input.txt")
    end

    def parse_to_coords_list(string) do
        string
        |> String.split("\n")
        |> Enum.map(fn line ->
            line
            |> String.split(",")
            |> Enum.map(&String.to_integer/1)
            |> List.to_tuple()
        end)
    end

    def get_all_pairs(coords_list) do
        coords_list
        |> Enum.flat_map(fn cur ->
            coords_list
            |> Enum.map(fn other -> {cur, other} end)
        end)
        |> Enum.map(fn {{a, b, c}, {x, y, z}} ->
            if a + b + c < x + y + z do
                {{a, b, c}, {x, y, z}}
            else
                {{x, y, z}, {a, b, c}}
            end
        end)
        |> Enum.uniq()
        |> Enum.filter(fn {a, b} -> a != b end)
    end

    def get_distance({x1, y1, z1}, {x2, y2, z2}) do
        :math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2)
    end

    def get_all_distances(coords_list) do
        coords_list
        |> Enum.map(fn {a, b} -> get_distance(a, b) end)
    end

    def solve do
        all_pairs =
        read_file()
        |> parse_to_coords_list()
        |> get_all_pairs()

        all_distances =
        all_pairs
        |> get_all_distances()

        first_1000_pairs = Enum.zip(all_pairs, all_distances)
        |> Enum.sort_by(fn {_, distance} -> distance end)
        |> Enum.take(1000)
        |> Enum.map(fn {pair, _} -> pair end)

        Graph.new(type: :undirected)
        |> Graph.add_edges(first_1000_pairs)
        |> Graph.components()
        |> IO.inspect()
        |> Enum.map(&length/1)
        |> Enum.sort(:desc)
        |> Enum.take(3)
        |> Enum.product()
    end
end

defmodule Day8.Part2 do
    import Day8.Part1

    def solve do

        coords_list =
            read_file()
            |> parse_to_coords_list()

        all_pairs =
            coords_list
            |> get_all_pairs()

        all_distances =
            all_pairs
            |> get_all_distances()

        sorted_pairs = Enum.zip(all_pairs, all_distances)
        |> Enum.sort_by(fn {_, distance} -> distance end)
        |> Enum.map(fn {pair, _} -> pair end)

        graph_with_all_vertices = Graph.new(type: :undirected)
        |> Graph.add_vertices(coords_list)

        {{x1, _, _}, {x2, _, _}} = Enum.reduce_while(sorted_pairs, graph_with_all_vertices, fn {a, b}, graph ->
            graph = Graph.add_edge(graph, a, b)

            case Graph.components(graph) |> length() do
                1 -> {:halt, {a, b}}
                _ -> {:cont, graph}
            end
        end)

        x1 * x2
    end
end

Day8.Part2.solve() |> IO.inspect()
