function count_calories(file)
    calories = [0]

    for line in readlines(file)
        if isempty(line)
            push!(calories, 0)
            continue
        end

        calories[end] += parse(Int, line)
    end

    return calories
end

file = open("data/01.txt")

calories = count_calories(file)
sort!(calories, rev=true)

println("Part 1: ", calories[1])
println("Part 2: ", sum(calories[1:3]))