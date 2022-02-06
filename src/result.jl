abstract type AbstractResult end

"""
    Result(total, duration, docs)

Formatted response object from redis. 

# Fields
- `total::Integer`: Number of results found for the 
- `duration::Float64`: Length of time taken to find all results.
- `docs::Vector{Document}`: Documents objects that are returned from  a search.
"""
mutable struct Result <: AbstractResult
    total::Integer
    duration::Float64
    docs::Vector{Document}
end

"""
    Results(res, has_content, duration; has_payload=false, with_scores=false)

Create the Result object from a Redis search response. 

# Arguments
- `res`: Response from Redis
- `has_content`: Bool flag for if there is content returned
- `duration`: Time taken for query to return results

# Keywords
- `has_payload::Bool`: Flag for payload bring returned.
- `with_scores::Bool`: Flag for scores being returned. 
"""
function Results(
    res,
    has_content::Bool,
    duration::Number;
    has_payload::Bool=false,
    with_scores::Bool=false,
)
    total = res[1]
    docs = Vector{Document}()

    step = 1
    if has_content
        step += 1
    end

    if has_payload
        step += 1
    end

    if with_scores
        step += 1
    end

    offset = 1
    if with_scores
        offset = 2
    end

    for i in 2:step:length(res)
        id = res[i]
        payload = Dict()
        field_offset = offset
        score = nothing

        if has_payload
            payload = res[i + offset]
            field_offset = offset + 1
        end

        if with_scores
            score = parse(Float64, res[i + 1])
        end

        fields = Dict()

        if has_content
            hset_fields = res[i + field_offset]
            fields = Dict(
                Symbol(hset_fields[j]) => hset_fields[j + 1] for
                j in 1:2:length(hset_fields)
            )
        end

        doc = Document(id; score=score, payload=payload, fields...)
        push!(docs, doc)
    end

    @info "Result: $total total"
    return Result(total, duration, docs)
end
