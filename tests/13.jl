using Test
include("../days/13.jl")


@testset "in_order" begin
    @test in_order(1, 1) == 0
    @test in_order(1, 2) == -1
    @test in_order(2, 1) == 1
    @test in_order([1], [1]) == 0
    @test in_order([1], [2]) == -1
    @test in_order([1], 2) == -1

    # Examples from the problem statement
    @test in_order([1, 1, 3, 1, 1], [1, 1, 5, 1, 1]) == -1
    @test in_order([[1], [2, 3, 4]], [[1], 4]) == -1
    @test in_order([9], [[8, 7, 6]]) == 1
    @test in_order([[4, 4], 4, 4], [[4, 4], 4, 4, 4]) == -1
    @test in_order([7, 7, 7, 7], [7, 7, 7]) == 1
    @test in_order([], [3]) == -1
    @test in_order([[[]]], [[]]) == 1
    @test in_order([1, [2, [3, [4, [5, 6, 7]]]], 8, 9], [1, [2, [3, [4, [5, 6, 0]]]], 8, 9]) == 1
end