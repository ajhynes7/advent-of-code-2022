# Admittedly I looked for help on this one. This is based off a Python solution by krbarter.
using DataStructures


function compute_sizes(file)
    sizes = DefaultDict(0)
    path_vector = String[]

    for line in readlines(file)
        words = split(line, " ")

        if words[2] == "cd"
            dir = words[3]

            if dir == ".."
                pop!(path_vector)
            else
                dir = dir == "/" ? "root" : dir
                push!(path_vector, dir)
            end

        elseif words[2] == "ls" || words[1] == "dir"
            continue

        else
            file_size = parse(Int, words[1])

            for i in 1:length(path_vector)
                path = join(path_vector[1:i], '/')
                sizes[path] += file_size
            end
        end
    end

    return sizes
end


function compute_answers(sizes)
    total_1 = 0
    total_2 = 100_000_000

    total_disk_space = 70_000_000
    required_free_space = 30_000_000
    max_allowed_space = total_disk_space - required_free_space

    total_used_space = sizes["root"]
    space_to_free = total_used_space - max_allowed_space

    for size in values(sizes)
        if size <= 100_000
            total_1 += size
        end

        if size >= space_to_free
            total_2 = min(size, total_2)
        end
    end

    return total_1, total_2
end


file = open("data/07.txt")

sizes = compute_sizes(file)
total_1, total_2 = compute_answers(sizes)

println("Part 1: ", total_1)
println("Part 2: ", total_2)