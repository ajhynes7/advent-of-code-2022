using JSON


function read_packet_pairs(file)

    file_string = read(file, String)
    string_pairs = split(file_string, "\n\n")

    packet_pairs = []

    for pair in string_pairs
        push!(packet_pairs, map(JSON.parse, split(pair, "\n")))
    end

    packet_pairs
end


function read_packets(file)

    packets = []

    for line in readlines(file)
        if !isempty(line)
            push!(packets, JSON.parse(line))
        end
    end

    packets
end


function compare(left, right)

    if left isa Int && right isa Int
        return sign(left - right)
    end

    if left isa Vector && right isa Int
        return compare(left, [right])
    end

    if left isa Int && right isa Vector
        return compare([left], right)
    end

    if left isa Vector && right isa Vector

        for (a, b) in zip(left, right)
            comparison = compare(a, b)

            if comparison != 0
                return comparison
            end
        end

        return sign(length(left) - length(right))
    end

end


function compute_total(packet_pairs)

    total = 0

    for (i, pair) in enumerate(packet_pairs)
        if compare(pair...) == -1
            total += i
        end
    end

    total
end


file = open("data/13.txt")
packet_pairs = read_packet_pairs(file)
println("Part 1: ", compute_total(packet_pairs))

seekstart(file)
packets = read_packets(file)

divider_packet_1 = [[2]]
divider_packet_2 = [[6]]
push!(packets, divider_packet_1)
push!(packets, divider_packet_2)

sort!(packets, lt=(x, y) -> compare(x, y) == -1)

index_1 = findall(x -> x == divider_packet_1, packets)[1]
index_2 = findall(x -> x == divider_packet_2, packets)[1]
println("Part 2: ", index_1 * index_2)
