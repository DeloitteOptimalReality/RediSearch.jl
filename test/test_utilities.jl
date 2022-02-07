@testset "UTILS" begin
    l_a = String[]
    l_t = Tuple[]
    l_v = Vector{String}()
    l_d = Dict()
    @test RediSearch.isa_list(l_a) == true
    @test RediSearch.isa_list(l_t) == true
    @test RediSearch.isa_list(l_v) == true
    @test RediSearch.isa_list(l_d) == false
end