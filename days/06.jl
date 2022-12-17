using DataStructures


function process_datastream(file::IOStream, queue_capacity::Int)

    circular_queue = CircularDeque{Char}(queue_capacity)

    for (i, character) in enumerate(read(file, String))
        push!(circular_queue, character)

        if length(circular_queue) == queue_capacity
            if allunique(circular_queue)
                return i
            end
            popfirst!(circular_queue)
        end
    end
end


file = open("data/06.txt", "r")
index_1 = process_datastream(file, 4)

seekstart(file)
index_2 = process_datastream(file, 14)

println("Part 1: ", index_1)
println("Part 2: ", index_2)
