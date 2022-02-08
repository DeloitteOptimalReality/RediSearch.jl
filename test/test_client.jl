@testset "client" begin
    quick_flush()
    
    client = SearchClient("idx")
    @test client.index_name == "idx"

     # Check to see in docker container is working as expected
    @test Jedis.execute("FT._LIST") == []

    @test typeof(client.client) <: Jedis.Client    

    @test typeof(get_search_client()) <: SearchClient

    index_def_hash = IndexDefinition()
    @test typeof(index_def_hash) <: IndexDefinition
    @test index_def_hash.args == ["ON","HASH"]

    index_def_json = IndexDefinition(index_type=IndexType.JSON)
    @test index_def_json.args == ["ON","JSON"]

    @test_throws MethodError IndexDefinition(index_type=3)

    idx = IndexDefinition(
        prefix=["idx:"],
        language_field="language",
        language="english",
        score_field="name",
        score=1.0,
    )
    
    @test idx.args == ["ON", "HASH", "PREFIX", 1, "idx:", "LANGUAGE_FIELD", "language", "LANGUAGE", "english", "SCORE_FIELD", "name"]

    text_field = TextField("field1")

    @test create_index(
        [text_field];
        definition=idx,
        no_term_offsets=true,
        no_field_flags=true,
        stopwords=["of"],
        max_text_fields=true,
        no_highlight=true,
        no_term_frequencies=true,
        skip_initial_scan=true,
    ) == "OK"

    @test Jedis.execute("FT._LIST") == ["idx"]

    idx = IndexDefinition(
        prefix=["idx:"],
        score=1.0,
    )
    drop_index()
    @test Jedis.execute("FT._LIST") == []
    create_index(
        [text_field];
        definition=idx
    )
    @test Jedis.execute("FT._LIST") == ["idx"]
    drop_index()

    Jedis.execute("FLUSHALL")
end