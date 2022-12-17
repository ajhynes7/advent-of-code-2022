using DelimitedFiles
using DataFrames

victor_of = Dict('A' => 'B', 'B' => 'C', 'C' => 'A')

function compute_outcome_score(move_1::Char, move_2::Char)
    if move_1 == move_2
        return 3
    end
    if victor_of[move_1] == move_2
        return 0
    end
    return 6
end


function compute_game_score(move_1::Char, move_2::Char)
    shape_score = Dict('A' => 1, 'B' => 2, 'C' => 3)
    return shape_score[move_1] + compute_outcome_score(move_1, move_2)
end


function decide_move_of_part_2(opponent::Char, strategy::Char)
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


function compute_total_scores(file::IOStream)
    strategy_map = Dict('X' => 'A', 'Y' => 'B', 'Z' => 'C')
    total_score_1, total_score_2 = 0, 0

    for line in readlines(file)
        opponent_move, strategy = only.(split(line, ' '))

        my_move_1 = strategy_map[strategy]
        my_move_2 = decide_move_of_part_2(opponent_move, strategy)

        total_score_1 += compute_game_score(my_move_1, opponent_move)
        total_score_2 += compute_game_score(my_move_2, opponent_move)
    end

    return total_score_1, total_score_2
end


file = open("data/02.txt")

total_score_1, total_score_2 = compute_total_scores(file)

println("Part 1: ", total_score_1)
println("Part 2: ", total_score_2)
