function compute_value(character)
    if isuppercase(character)
        value = Int(lowercase(character)) - 96 + 26
    else
        value = Int(character) - 96
    end
    return value
end

function part_1(file)

    total = 0

    for line in readlines(file)
        halfway = Int(length(line) / 2)

        compartment_1 = Set(line[1:halfway])
        compartment_2 = Set(line[halfway+1:end])

        intersection = intersect(compartment_1, compartment_2)
        character = first(intersection)

        total += compute_value(character)
    end

    return total
end


function part_2(file)

    total = 0
    group = []

    for line in readlines(file)

        push!(group, line)

        if length(group) == 3

            set_1 = Set(group[1])
            set_2 = Set(group[2])
            set_3 = Set(group[3])

            intersection = intersect(set_1, set_2, set_3)
            character = first(intersection)

            total += compute_value(character)
            group = []
        end

    end

    return total
end


file = open("data/03.txt")
println("Part 1: ", part_1(file))

file = open("data/03.txt")
println("Part 2: ", part_2(file))