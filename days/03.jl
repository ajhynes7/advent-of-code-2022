function compute_value(character::Char)
    if isuppercase(character)
        value = Int(lowercase(character)) - 96 + 26
    else
        value = Int(character) - 96
    end
    return value
end

function compute_totals(file::IOStream)
    total_1, total_2 = 0, 0
    group = []

    for line in readlines(file)
        halfway = Int(length(line) / 2)

        compartment_1 = Set(line[1:halfway])
        compartment_2 = Set(line[halfway+1:end])

        intersection = intersect(compartment_1, compartment_2)
        character = first(intersection)

        total_1 += compute_value(character)

        push!(group, line)

        if length(group) == 3
            intersection = intersect(group...)
            character = first(intersection)

            total_2 += compute_value(character)
            group = []
        end
    end

    return total_1, total_2
end


file_name = "data/03.txt"

file = open(file_name, "r")
total_1, total_2 = compute_totals(file)

println("Part 1: ", total_1)
println("Part 2: ", total_2)
