using DelimitedFiles
using DataFrames

victor_of = Dict('A' => 'B', 'B' => 'C', 'C' => 'A')

function outcome_score(move_1, move_2)
    if move_1 == move_2
        return 3
    end
    if victor_of[move_1] == move_2
        return 0
    end
    return 6
end


function game_score(move_1, move_2)
    shape_score = Dict('A' => 1, 'B' => 2, 'C' => 3)
    return shape_score[move_1] + outcome_score(move_1, move_2)
end


function compute_total_score(df)
    strategy_map = Dict('X' => 'A', 'Y' => 'B', 'Z' => 'C')
    df.strategy = map(x -> strategy_map[x], df.strategy)

    df[!, "total_score"] = game_score.(df.strategy, df.opponent)

    return sum(df.total_score)
end


function decide_move_of_part_2(opponent, strategy)

    loser_of = Dict(victor_of[k] => k for k in keys(victor_of))

    if strategy == 'X'
        # Need to lose
        move = loser_of[opponent]
    elseif strategy == 'Y'
        # Need to draw
        move = opponent
    elseif strategy == 'Z'
        # Need to win
        move = victor_of[opponent]
    else
        error(strategy)
    end
    return move
end

function compute_total_score_of_part_2(df)
    moves = decide_move_of_part_2.(df.opponent, df.strategy)
    df[!, "total_score"] = game_score.(moves, df.opponent)

    return sum(df.total_score)
end

df = DataFrame(readdlm("data/02.txt", header=false), :auto)

rename!(df, [:opponent, :strategy])

# Convert elements from string to char
df = only.(df)
# total_score = compute_total_score(df)
# println(total_score)

total_score_2 = compute_total_score_of_part_2(df)
println(total_score_2)