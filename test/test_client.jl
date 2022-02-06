@testset "client" begin
    client = SearchClient("idx")
    @test client.index_name == "idx"
    @test typeof(client.clinet) <: Jedis.Client    
end