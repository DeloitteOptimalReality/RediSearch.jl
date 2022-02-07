@testset "fields" begin
    text_field = TextField(
        "name";
        weight=2,
        sortable=true,
        as_name="nombre",
        no_stem=true,
    )

    @test text_field.as_name == "nombre"

    @test_throws ErrorException Field("errors", sortable=true, no_index=true)
    @test_throws MethodError NumericField()

    num_field = NumericField("age"; no_index=true)
    geo_field = GeoField("location")
    tag_field = TagField("tag")

    @test redis_args(text_field) == ["name", "TEXT", "WEIGHT", 2, "AS", "nombre", "SORTABLE", "NOSTEM"]
    @test redis_args(num_field) == ["age", "NUMERIC", "NOINDEX"]
    @test redis_args(geo_field) == ["location", "GEO"]
    @test redis_args(tag_field) == ["tag", "TAG", "SEPARATOR", ","]
end 