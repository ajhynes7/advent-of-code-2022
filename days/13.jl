

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
    
    if left isa Int && right isa Int
        return left < right
        
    elseif left isa Array && right isa Int
        for x in left
            return in_order(x, right)
        end
        
    elseif left isa Int && right isa Array
        for x in right
            return in_order(left, x)
        end
        
    else
        if length(left) > length(right)
            return false
        end
        for (x, y) in zip(left, right)
            if x == y
                continue
            end
            ordered = in_order(x, y)
            if !ordered
                return false
            end
        end
        return true
    end
    
end


function compute_total(packet_pairs)
    total = 0 

    for (i, pair) in enumerate(packet_pairs)
        if in_order(pair...)
            total += i
        end
    end

    total
end


file = open("data/13_prac.txt")
packet_pairs = read_packets(file)

println("Part 1: ", compute_total(packet_pairs))
