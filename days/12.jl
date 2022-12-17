using Graphs
using Graphs.Experimental.ShortestPaths
using Images


function construct_grid(file)
    rows = []

    for line in readlines(file)
        push!(rows, only.(split(line, "")))
    end

    reduce(hcat, rows)
end


function get_index(i, j, n_cols)
    (i - 1) * n_cols + j
end


function construct_graph(grid)

    padded = padarray(grid, Pad(:replicate, 1, 1))

    padded[:, 0] .= 0
    padded[:, end] .= 0
    padded[0, :] .= 0
    padded[end, :] .= 0

    graph = SimpleDiGraph()

    for i = 1:length(grid)
        add_vertex!(graph)
    end

    n_rows, n_cols = size(grid)

    for i = 1:n_rows
        for j = 1:n_cols

            node_u = get_index(i, j, n_cols)

            if padded[i, j] - padded[i-1, j] <= 1
                node_v = get_index(i - 1, j, n_cols)
                add_edge!(graph, node_u, node_v)
            end

            if padded[i, j] - padded[i+1, j] <= 1
                node_v = get_index(i + 1, j, n_cols)
                add_edge!(graph, node_u, node_v)
            end

            if padded[i, j] - padded[i, j-1] <= 1
                node_v = get_index(i, j - 1, n_cols)
                add_edge!(graph, node_u, node_v)
            end

            if padded[i, j] - padded[i, j+1] <= 1
                node_v = get_index(i, j + 1, n_cols)
                add_edge!(graph, node_u, node_v)
            end
        end
    end

    graph
end


function shortest_number_of_steps(file)

    grid = construct_grid(file)

    index_start = findall(x -> x == 'S', grid)[1]
    index_end = findall(x -> x == 'E', grid)[1]
    indices_a = findall(x -> x == 'a', grid)  # For part 2

    grid[index_start] = 'a'
    grid[index_end] = 'z'

    grid = transpose(Int.(grid))

    graph = construct_graph(grid)

    n_cols = size(grid)[2]
    source = get_index(index_start[2], index_start[1], n_cols)
    target = get_index(index_end[2], index_end[1], n_cols)

    result = dijkstra_shortest_paths(graph, target)

    # Part 2
    distances = []

    for index_a in indices_a
        node_a = get_index(index_a[2], index_a[1], n_cols)
        push!(distances, result.dists[node_a])
    end

    result.dists[source], minimum(distances)
end


file = open("data/12.txt")
answer_1, answer_2 = shortest_number_of_steps(file)

println("Part 1: ", answer_1)
println("Part 2: ", answer_2)