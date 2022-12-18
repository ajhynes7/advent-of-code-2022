

function read_packets(file)
    pair = []
    packet_pairs = []

    for line in readlines(file)

        if isempty(line)
            push!(packet_pairs, pair)
            pair = []
            continue
        end

        vector = Meta.parse(line) |> eval
        push!(pair, vector)
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
