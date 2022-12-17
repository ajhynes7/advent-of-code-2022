using Plots


function execute_program(file::IOStream)
    cycle = 0
    x = 1

    strengths = Int[]
    crt = fill(false, 6, 40)

    for line in readlines(file)
        if line != "noop"
            words = split(line, ' ')

            for _ in 1:2
                cycle += 1
                update_strengths!(strengths, cycle, x)
                update_crt!(crt, cycle, x)
            end

            x += parse(Int, words[2])
        else
            cycle += 1
            update_strengths!(strengths, cycle, x)
            update_crt!(crt, cycle, x)
        end
    end

    strengths, crt
end


function update_strengths!(strengths::AbstractVector, cycle::Int, x::Int)
    if (cycle - 20) % 40 == 0
        push!(strengths, cycle * x)
    end
end


function update_crt!(crt::AbstractMatrix, cycle::Int, x::Int)
    _, width = size(crt)

    index = cycle - 1
    row, column = get_row_and_column(width, index)

    if abs(column - x) <= 1
        crt[row+1, column+1] = true
    end
end


function get_row_and_column(width::Int, index::Int)
    row = floor(Int, index / width)
    column = index % width

    row, column
end


file = open("data/10.txt")
strengths, crt = execute_program(file)

println("Part 1: ", sum(strengths))
display(plot(Gray.(.!crt)))
