

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


function in_order(left, right)

    if left isa Vector && right isa Vector
        index = 1
        length_l = length(left)
        length_r = length(right)

        while true
            if index > length_l
                if length_l == length_r
                    return 0
                end
                # Left ran out of items first.
                return -1
            end
            if index > length_r
                # Right ran out of items first.
                return 1
            end

            ordered = in_order(left[index], right[index])

            if ordered != 0
                return ordered
            end

            index += 1
        end

        return -1
    end

    if left isa Int && right isa Int

        if left < right
            return -1
        end
        if left == right
            return 0
        end
        return 1
    end

    if left isa Vector && right isa Int
        return in_order(left, [right])
    end

    if left isa Int && right isa Vector
        return in_order([left], right)
    end

end


function compute_total(packet_pairs)
    total = 0

    for (i, pair) in enumerate(packet_pairs)
        if in_order(pair...) == -1
            total += i
        end
    end

    total
end


file = open("data/13.txt")
packet_pairs = read_packets(file)

println("Part 1: ", compute_total(packet_pairs))
