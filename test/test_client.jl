@testset "client" begin
    client = SearchClient("idx")
    @test client.index_name == "idx"
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
        score=2.0,
    )
    
    @test idx.args == ["ON", "HASH", "PREFIX", 1, "idx:", "LANGUAGE_FIELD", "language", "LANGUAGE", "english", "SCORE_FIELD", "name", "SCORE", 2.0]

    text_field = TextField("field1")

    @test_throws Jedis.RedisError create_index(
        [text_field];
        definition=idx,
        no_term_offsets=true,
        no_field_flags=true,
        stopwords=["of"],
        max_text_fields=true,
        temporary=1,
        no_highlight=true,
        no_term_frequencies=true,
        skip_initial_scan=true,
    )

    idx = IndexDefinition(
        prefix=["idx:"],
        score=1.0,
    )

    create_index(
        [text_field];
        definition=idx,
        no_term_offsets=true,
        no_field_flags=true,
        stopwords=["of"],
        max_text_fields=true,
        no_highlight=true,
        no_term_frequencies=true,
        skip_initial_scan=true,
    )

    @test Jedis.execute("FT._LIST") == ["idx"]
    drop_index()
    @test Jedis.execute("FT._LIST") == []

    create_index(
        [text_field];
        definition=idx
    )
end