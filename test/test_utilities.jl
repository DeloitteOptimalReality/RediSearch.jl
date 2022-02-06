@testset "UTILS" begin
    l_a = Array{Any, 1}()
    l_t = Tuple{Any, Any}()
    l_v = Vector{Any}()
    l_d = Dict()
    @test JediSearch.isa_list(l_a) == true
    @test JediSearch.isa_list(l_t) == true
    @test JediSearch.isa_list(l_v) == true
    @test JediSearch.isa_list(l_d) == false
end