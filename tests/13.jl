using Test
include("../days/13.jl")


@testset "compare" begin
    @test compare(1, 1) == 0
    @test compare(1, 2) == -1
    @test compare(2, 1) == 1
    @test compare([1], [1]) == 0
    @test compare([1], [2]) == -1
    @test compare([1], 2) == -1

    @test compare([1], [1, 1]) == -1
    @test compare([1, 1], [1]) == 1
    @test compare([1, 1], [1, 1]) == 0

    # Examples from the problem statement
    @test compare([1, 1, 3, 1, 1], [1, 1, 5, 1, 1]) == -1
    @test compare([[1], [2, 3, 4]], [[1], 4]) == -1
    @test compare([9], [[8, 7, 6]]) == 1
    @test compare([[4, 4], 4, 4], [[4, 4], 4, 4, 4]) == -1
    @test compare([7, 7, 7, 7], [7, 7, 7]) == 1
    @test compare([], [3]) == -1
    @test compare([[[]]], [[]]) == 1
    @test compare([1, [2, [3, [4, [5, 6, 7]]]], 8, 9], [1, [2, [3, [4, [5, 6, 0]]]], 8, 9]) == 1
end