abstract type AbstractDocument end

"""
    Document(id::AbstractString; score=nothing, payload=nothing, kwargs...) -> Document

A RediSearch Document that is returned from a search query.

# Attributes
- `id::String`: Redis Key id that the document is stored in.
- `score::Union{Float64,Nothing}`: Match Score for the document based on the search 
criteria.
- `payload::Union{Nothing,AbstractDict}`: Payload returned buy the query.
- `kwargs`: Additional redis fields.
"""
mutable struct Document <: AbstractDocument
    id::String
    score::Union{Float64,Nothing}
    payload::Union{Nothing,Dict}
end

function Document(
    id::AbstractString;
    score::Union{Float64,Nothing},
    payload::Union{Nothing,AbstractDict}=Dict(),
    kwargs...
)
    for (k, v) in kwargs
        payload[k] = v
    end
    
    return Document(id, score, payload)
end
