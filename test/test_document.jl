@testset "doc_search" begin
    quick_flush()
    quick_setup()
    client = get_search_client()

    hset("idx:1", "field1", "disappear", "field2", "information", "field3", 20)
    hset("idx:2", "field1", "workshop", "field2", "thanks", "field3", 22)
    hset("idx:3", "field1", "bulletin", "field2", "correspond", "field3", 23)
    hset("idx:4", "field1", "youth", "field2", "dictate", "field3", 24)
    hset("idx:5", "field1", "paper", "field2", "intention", "field3", 25)

    q = Query("paper")
    results = search(q);
    docs = results.docs

    @test length(docs) == 1
    @test docs[1].id == "idx:5"
    @test docs[1].score === nothing


    q.with_scores = true

    results = search(q);
    doc = results.docs[1]
    @test typeof(doc.score) <: Number

    @test typeof(doc.payload) <: Dict

    for k in keys(doc.payload)
        @test typeof(k) <: Symbol
    end
end

@testset "single_doc" begin
    id = "idx:1:testing"
    payload = Dict(
        :name=>"RediSearch",
        :language=>"Julia",
    )
    score = 1.0


    doc1 = RediSearch.Document(id, score, payload)
    doc2 = RediSearch.Document(id; score=score, payload...)

    @test doc1.id == doc2.id
    @test doc1.score == doc2.score
    @test doc1.payload == doc2.payload

    doc3 = RediSearch.Document(id; payload...)
    @test doc3.score === nothing
end