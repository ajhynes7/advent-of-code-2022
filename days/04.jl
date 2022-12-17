function parts_1_and_2(file::IOStream)
    count_1, count_2 = 0, 0

    for line in readlines(file)
        tasks_1, tasks_2 = split(line, ",")

        start_1, end_1 = parse.(Int, split(tasks_1, "-"))
        start_2, end_2 = parse.(Int, split(tasks_2, "-"))

        tasks_1_includes_2 = start_1 <= start_2 && end_1 >= end_2
        tasks_2_includes_1 = start_2 <= start_1 && end_2 >= end_1

        if tasks_1_includes_2 || tasks_2_includes_1
            count_1 += 1
        end

        max_ = max(end_1, end_2)
        min_ = min(start_1, start_2)

        width_1 = end_1 - start_1
        width_2 = end_2 - start_2

        if max_ - min_ <= width_1 + width_2
            count_2 += 1
        end
    end

    return count_1, count_2
end


file_name = "data/04.txt"
file = open(file_name, "r")

count_1, count_2 = parts_1_and_2(file)

println("Part 1: ", count_1)
println("Part 2: ", count_2)
