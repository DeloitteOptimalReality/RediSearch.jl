using Test
using JediSearch
using Jedis


@testset "Client" begin include("test_client.jl") end
@testset "Utils" begin include("test_utilities.jl") end
@testset "Result" begin include("test_result.jl") end
@testset "Document" begin include("test_document.jl") end
@testset "Fields" begin include("test_fields.jl") end
@testset "Query" begin include("test_query.jl") end
@testset "Search" begin include("test_search.jl") end
@testset "IndexDefinition" begin include("test_index_definition.jl") end