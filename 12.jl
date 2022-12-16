using Graphs
using Images
using Graphs.Experimental.ShortestPaths


function construct_grid(file)
    rows = []

    for line in readlines(file)
        push!(rows, only.(split(line, "")))
    end

    reduce(hcat, rows)
end


function get_index(i, j, n_cols) 
    (i-1) * n_cols + j-1
end


function shortest_number_of_steps(file)
    grid = construct_grid(file)

    index_start = findall(x -> x == 'S', grid)[1]
    index_end = findall(x -> x == 'E', grid)[1]

    grid[index_start] = 'a'
    grid[index_end] = 'z' 

    grid = transpose(Int.(grid))

    n_rows, n_cols = size(grid)
    padded = padarray(grid, Pad(:replicate, 1, 1))

    padded[:, 0] .= 1000
    padded[:, end] .= 1000
    padded[0, :] .= 1000
    padded[end, :] .= 1000

    graph = SimpleDiGraph()

    for i = 1:length(grid)
       add_vertex!(graph) 
    end


    for i = 1:n_rows
        for j = 1:n_cols
            node_u = get_index(i, j, n_cols)  

            if padded[i-1, j] - padded[i, j] <= 1
                node_v = get_index(i-1, j, n_cols) 
                add_edge!(graph, node_u+1, node_v+1)
            end

            if padded[i+1, j] - padded[i, j] <= 1
                node_v = get_index(i+1, j, n_cols) 
                add_edge!(graph, node_u+1, node_v+1)
            end

            if padded[i, j-1] - padded[i, j]  <= 1
                node_v = get_index(i, j-1, n_cols) 
                add_edge!(graph, node_u+1, node_v+1)
            end

            if padded[i, j+1] - padded[i, j] <= 1
                node_v = get_index(i, j+1, n_cols) 
                add_edge!(graph, node_u+1, node_v+1)
            end

        end
    end

    source = get_index(index_start[2], index_start[1], n_cols)
    target = get_index(index_end[2], index_end[1], n_cols)

    result = dijkstra_shortest_paths(graph, source+1)
    result.dists[target+1]
end


file = open("data/12.txt")
n_steps = shortest_number_of_steps(file)

println("Part 1: ", n_steps)
