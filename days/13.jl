using JSON


function read_packets(file)

    file_string = read(file, String)
    string_pairs = split(file_string, "\n\n")

    packet_pairs = []

    for pair in string_pairs
        push!(packet_pairs, map(JSON.parse, split(pair, "\n")))
    end

    packet_pairs
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
packet_pairs = read_packets(file)

println("Part 1: ", compute_total(packet_pairs))
