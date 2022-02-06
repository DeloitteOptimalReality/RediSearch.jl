@testset "client" begin
    client = SearchClient("idx")
    @test client.index_name == "idx"
    @test typeof(client.client) <: Jedis.Client    
end