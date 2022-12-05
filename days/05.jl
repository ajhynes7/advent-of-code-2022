using DataStructures

function initialize_stacks()
    initial_stack_configs = [
        "FTCLRPGQ",
        "NQHWRFSJ",
        "FBHWPMQ",
        "VSTDF",
        "QLDWVFZ",
        "ZCLS",
        "ZBMVDF",
        "TJB",
        "QNBGLSPH",
    ]

    stacks = [Stack{Char}() for _ in 1:9]

    for (config, stack) in zip(initial_stack_configs, stacks)
        for char in config
            push!(stack, char)
        end
    end

    return stacks
end


function move_crates(file, stacks)
    pattern = r"move (\d+) from (\d) to (\d)"

    stacks_2 = deepcopy(stacks)

    for line in readlines(file)
        match_ = match(pattern, line)

        n_to_move = parse(Int, match_[1])
        index_i = parse(Int, match_[2])
        index_f = parse(Int, match_[3])

        for _ in 1:n_to_move
            crate = pop!(stacks[index_i])
            push!(stacks[index_f], crate)
        end

        # Part 2
        crates = []
        for _ in 1:n_to_move
            crate = pop!(stacks_2[index_i])
            push!(crates, crate)
        end

        for crate in reverse(crates)
            push!(stacks_2[index_f], crate)
        end
    end

    return stacks, stacks_2
end


function get_stack_tops(stacks)
    tops = []

    for stack in stacks
        push!(tops, first(stack))
    end

    return tops
end

file = open("data/05.txt", "r")

stacks = initialize_stacks()
stacks_1, stacks_2 = move_crates(file, stacks)

tops_1 = get_stack_tops(stacks_1)
tops_2 = get_stack_tops(stacks_2)

println("Part 1:", join(tops_1))
println("Part 2:", join(tops_2))