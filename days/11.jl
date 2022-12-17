mutable struct Monkey
    items::Vector{Int}
    operation::Function
    divisor::Int
    test::Function
    throw_to_monkey::Dict

    function Monkey()
        return new([], x -> x, 1, x -> x, Dict())
    end
end


function initialize_monkeys(file::IOStream)
    monkeys = Monkey[]

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

                elseif i == 2
                    starting_items = parse.(Int, split(regex_match[1], ","))
                    monkeys[end].items = starting_items

                elseif i == 3
                    operation = eval(Meta.parse("(old) -> " * regex_match[1]))
                    monkeys[end].operation = operation

                elseif i == 4
                    divisor = parse(Int, regex_match[1])
                    test = (x) -> x % divisor == 0

                    monkeys[end].divisor = divisor
                    monkeys[end].test = test

                elseif i == 5
                    boolean = parse(Bool, regex_match[1])
                    target_monkey = parse(Int, regex_match[2])
                    monkeys[end].throw_to_monkey[boolean] = target_monkey

                end
            end
        end
    end

    monkeys
end


function throw_items!(monkeys::Vector{Monkey}, n_rounds::Int, part::Int)
    n_monkeys = length(monkeys)
    counts = zeros(Int, n_monkeys)

    modular_base = prod([monkey.divisor for monkey in monkeys])

    for _ = 1:n_rounds
        for i = 1:n_monkeys
            monkey = monkeys[i]

            for item in monkey.items
                counts[i] += 1
                worry_level = Base.invokelatest(monkey.operation, item)

                if part == 1
                    worry_level = floor(Int, worry_level / 3)
                elseif part == 2
                    worry_level = worry_level % modular_base
                else
                    error()
                end

                test_value = monkey.test(worry_level)
                target = monkey.throw_to_monkey[test_value]

                push!(monkeys[target+1].items, worry_level)
            end

            monkey.items = []
        end
    end

    counts
end


function monkey_business(file::IOStream, n_rounds::Int, part::Int)
    monkeys = initialize_monkeys(file)

    counts = throw_items!(monkeys, n_rounds, part)
    sort!(counts, rev=true)

    prod(counts[1:2])
end


file = open("data/11.txt")
answer_1 = monkey_business(file, 20, 1)

seekstart(file)
answer_2 = monkey_business(file, 10000, 2)

println("Part 1: ", answer_1)
println("Part 1: ", answer_2)
