using Test
using RediSearch
using Jedis

include("quick_setup.jl")

@testset "Client" begin include("test_client.jl") end
@testset "Utils" begin include("test_utilities.jl") end
@testset "Result" begin include("test_result.jl") end
@testset "Document" begin include("test_document.jl") end
@testset "Fields" begin include("test_fields.jl") end
@testset "Query" begin include("test_query.jl") end

