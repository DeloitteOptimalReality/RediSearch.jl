export IndexDefinition, IndexType

baremodule IndexType
    const HASH = 1
    const JSON = 2
end

abstract type AbstractIndex end

""" 
    IndexDefinition(args)

Object used to create a specific index in Redis. 

# Fields
- `args::Vector{Union{String,Number}}`: List of arguments used to define a searchable index.
"""
mutable struct IndexDefinition <: AbstractIndex
    args::Vector{Union{String,Number}}
end

"""
    IndexDefinition(;
        prefix=[],
        filter="",
        language_field="",
        language="",
        score_field="",
        score=1.0,
        payload_field="",
        index_type=IndexType.HASH
    ) -> IndexDefinition

IndexDefinition is used to define a index definition for automatic indexing on 
Hash or Json update.

# KeyWords
- `prefix::AbstractArray{AbstractString}`: Tells the index which keys it should index. Each 
prefix should finish with a `:`.
- `filter::AbstractString`: Filter expression with the full RediSearch aggregation 
expression language.
- `language_field::AbstractString`: If set indicates the document attribute that should be 
used as the document language.
- `language::AbstractString`: If set indicates the default language for documents in the 
index. Default to English.
- `score_field::AbstractString`: If set indicates the document attribute that should be used
as the document's rank based on the user's ranking. Ranking must be between 0.0 and 1.0. 
If not set the default score is 1
- `score::Float64`: If set indicates the default score for documents in the index. 
Default score is 1.0.
- `payload_field::AbstractString`: If set indicates the document attribute that should be 
used as a binary safe payload string to the document, that can be evaluated at query time by
a custom scoring function, or retrieved to the client.
- `index_type::Number`: Currently supports HASH (default) and JSON.
"""
function IndexDefinition(;
    prefix::AbstractArray=String[],
    filter::AbstractString="",
    language_field::AbstractString="",
    language::AbstractString="",
    score_field::AbstractString="",
    score::Float64=1.0,
    payload_field::AbstractString="",
    index_type::Number=IndexType.HASH,
)
    args = Vector{Union{AbstractString,Number}}()

    if index_type == IndexType.HASH
        append!(args, ["ON", "HASH"])
    elseif index_type == IndexType.JSON
        append!(args, ["ON", "JSON"])
    elseif !isnothing(index_type)
        throw(ErrorException("Cannot use index type " * index_type))
    end

    if length(prefix) > 0
        prefix_args = vcat(["PREFIX", length(prefix)], [p for p in prefix])
        append!(args, prefix_args)
    end

    if !isempty(filter)
        append!(args, ["FILTER", filter])
    end

    if !isempty(language_field)
        append!(args, ["LANGUAGE_FIELD", language_field])
    end

    if !isempty(language)
        append!(args, ["LANGUAGE", language])
    end

    if !isempty(score_field)
        append!(args, ["SCORE_FIELD", score_field])
    end

    if score != 1.0
        append!(args, ["SCORE", score])
    end

    if !isempty(payload_field)
        append!(args, ["PAYLOAD_FIELD", payload_field])
    end

    return IndexDefinition(args)
end
