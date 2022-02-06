module JediSearch

using Base: String, Number
using Jedis


include("utilities.jl")
include("document.jl")
include("query.jl")
include("command.jl")
include("fields.jl")
include("client.jl")
include("result.jl")
include("index_definition.jl")
include("search.jl")

end # module
