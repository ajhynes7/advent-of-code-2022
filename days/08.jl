function construct_grid(file::IOStream)
    rows = []

    for line in readlines(file)
        push!(rows, parse.(Int, split(line, "")))
    end

    reduce(hcat, rows)
end


function analyze_trees(grid::AbstractMatrix)
    n_rows, n_cols = size(grid)
    n_visible = 0
    scores = []

    for i = 1:n_rows
        for j = 1:n_cols
            tree = grid[i, j]

            left = tree .> grid[i, 1:j-1]
            right = tree .> grid[i, j+1:end]
            up = tree .> grid[1:i-1, j]
            down = tree .> grid[i+1:end, j]

            # Part 1
            if all(left) || all(right) || all(up) || all(down)
                n_visible += 1
            end

            # Part 2 
            distance_left = viewing_distance(reverse(left))
            distance_right = viewing_distance(right)
            distance_up = viewing_distance(reverse(up))
            distance_down = viewing_distance(down)

            score = distance_left * distance_right * distance_up * distance_down
            push!(scores, score)
        end
    end

    n_visible, maximum(scores)
end


function viewing_distance(vector::AbstractVector)
    total = 0

    for x in vector
        total += 1
        if !x
            break
        end
    end

    total
end


file = open("data/08.txt")
grid = construct_grid(file)

answer_1, answer_2 = analyze_trees(grid)
println("Part 1: ", answer_1)
println("Part 2: ", answer_2)
