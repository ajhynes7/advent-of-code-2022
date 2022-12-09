function move_knots(file, n_knots)
    knots = [[0, 0] for _ in 1:n_knots]
    tails = Set([[0, 0]])

    for line in readlines(file)
        split_ = split(line, ' ')

        direction = only(split_[1])
        n_steps = parse(Int, split_[2])

        for _ = 1:n_steps
            head = knots[1]

            if direction == 'R'
                head[1] += 1
            elseif direction == 'L'
                head[1] -= 1
            elseif direction == 'U'
                head[2] += 1
            elseif direction == 'D'
                head[2] -= 1
            else
                error()
            end

            for i = 1:length(knots)-1
                move_tail!(knots[i], knots[i+1])
            end

            push!(tails, copy(knots[end]))
        end
    end

    length(tails)
end


function move_tail!(head, tail)
    diff = head - tail

    if any(abs.(diff) .>= 2)
        tail .+= sign.(diff)
    end
end


file = open("data/09.txt")
println("Part 1: ", move_knots(file, 2))

seekstart(file)
println("Part 2: ", move_knots(file, 10))