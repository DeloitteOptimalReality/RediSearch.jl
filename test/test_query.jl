@testset "queries" begin
    quick_flush()
    quick_setup()

    q = Query("query string")
    @test q.num == 10
    
    @test q.return_fields == []
    f1 = TextField("test1")
    RediSearch.return_fields!(q, [f1])
    @test q.return_fields == [f1]

    q.return_fields = []
    @test q.return_fields != [f1]

    RediSearch.return_fields!(q, f1)
    @test q.return_fields == [f1]
    RediSearch.return_field!(q, f1.name, "test")

    @info q.return_fields

    @test q.ids == []
    RediSearch.limit_ids!(q, ["idx:test1"])
    @test q.ids == ["idx:test1"]

    q = Query(
        "test_string";
        offset=0,
        num=100,
        no_content=true,
        no_stopwords=true,
        fields=[],
        verbatim=false,
        with_payloads=true,
        with_scores=true,
        scorer=nothing,
        filters=[],
        ids=[],
        slop=-1,
        in_order=true,
        sortby=nothing,
        return_fields=[],
        summarize_fields=[],
        highlight_fields=[],
        language=nothing,
    )

    @info RediSearch.get_args(q)
    
    q = Query("workshop";
    )
    hset("idx:1", "test1", "test_string", "field2", "information", "field3", 20)
    hset("idx:2", "field1", "workshop", "field2", "thanks", "field3", 22)
    
    @info search(q)





end