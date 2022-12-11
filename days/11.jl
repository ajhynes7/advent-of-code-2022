mutable struct Monkey
    items
    operation
    test
    throw_to_monkey

    function Monkey(items=nothing, operation=nothing, test=nothing, throw_to_monkey=nothing)
        return new(items, operation, test, throw_to_monkey)
    end
end

function initialize_monkeys(file)
    monkeys = Monkey[]
    throw_to_monkey = Dict()

    patterns = [
        r"Monkey (\d+)",
        r"Starting items: (.*)",
        r"Operation: new = (.*)",
        r"Test: divisible by (\d+)",
        r"If (true|false): throw to monkey (\d+)",
    ]

    for line in readlines(file)
        for (i, pattern) in enumerate(patterns)
            regex_match = match(pattern, line)

            if !isnothing(regex_match)
                if i == 1
                    push!(monkeys, Monkey())
                    throw_to_monkey = Dict()

                elseif i == 2
                    starting_items = parse.(Int, split(regex_match[1], ","))
                    monkeys[end].items = starting_items

                elseif i == 3
                    operation = eval(Meta.parse("(old) -> " * regex_match[1]))
                    monkeys[end].operation = operation

                elseif i == 4
                    number = parse(Int, regex_match[1])
                    test = (x) -> x % number == 0
                    monkeys[end].test = test

                elseif i == 5
                    boolean = parse(Bool, regex_match[1])
                    target_monkey = parse(Int, regex_match[2])
                    throw_to_monkey[boolean] = target_monkey
                    monkeys[end].throw_to_monkey = throw_to_monkey

                end
            end
        end
    end

    monkeys
end



function throw_items!(monkeys, n_rounds)

    n_monkeys = length(monkeys)
    counts = zeros(Int, n_monkeys)

    for _ = 1:n_rounds
        for i = 1:n_monkeys
            monkey = monkeys[i]

            for item in monkey.items
                counts[i] += 1

                worry_level = monkey.operation(item)
                worry_level = floor(Int, worry_level / 3)

                test_value = monkey.test(worry_level)
                target = monkey.throw_to_monkey[test_value]

                push!(monkeys[target+1].items, worry_level)
            end
            monkey.items = []
        end
    end

    counts
end


file = open("data/11.txt")

monkeys = initialize_monkeys(file)
counts = throw_items!(monkeys, 20)

sort!(counts, rev=true)
monkey_business = prod(counts[1:2])

println("Part 1: ", monkey_business)