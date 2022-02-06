export Query,
    NumericFilter,
    GeoFilter,
    SortByField,
    limit_ids!,
    return_fields!,
    return_field!,
    summarize,
    highlight!,
    get_args

abstract type AbstractFilter end

"""
    Filter
    Filter{AbstractFilter}

Filter object that can be used in RediSearch

# Fields
- `args::AbstractArray`: Redis args that will be used when searching
"""
mutable struct Filter <: AbstractFilter
    args::AbstractArray
    Filter(keyword, field, args...) = new([keyword, field, args...])
end

function NumericFilter(
    field::String; minval="-inf", maxval="+inf", min_exclusive=true, max_exclusive=true
)
    args = [min_exclusive ? "($(minval)" : minval, max_exclusive ? "$(minval))" : maxval]

    return Filter("FILTER", field, args...)
end

"""
    GeoFilterUnit

BareModule for Geo units that can be used in a filter object.

# Members
- `METERS`: Meters unit of measurement.
- `KILOMETERS`: Kilometers unit of measurement.
- `FEET`: Feet unit of measurement.
- `MILES`: Miles unit of measurement.

# Returns
- `String`
"""
baremodule GeoFilterUnit
    const METERS = "m"
    const KILOMETERS = "km"
    const FEET = "ft"
    const MILES = "mi"
end

function GeoFilter(field, lon, lat, radius; unit=GeoFilterUnit.KILOMETERS)
    return Filter("GEOFILTER", field, lon, lat, radius, unit)
end

"""
    SortByField(field::AbstractString; asc::Bool=true) 

Create a `Fitler` object for sorting specific fields.

# Arguments
- `field::AbstractString`: Field name that is being sorted

# KeyWords
- `asc::Bool`: Sort by ascending, default as `true`

# Returns
- `Fitler::AbstractFilter`
"""
function SortByField(field::AbstractString; asc::Bool=true)
    return Filter(field, asc ? "ASC" : "DESC")
end

abstract type AbstractQuery end

"""
    Query(
        query_string::AbstractString;
        offset = 0,
        num = 10,
        no_content = false,
        no_stopwords = false,
        fields = [],
        verbatim = false,
        with_payloads = false,
        with_scores = false,
        scorer = nothing,
        filters = [],
        ids = [],
        slop = -1,
        in_order = false,
        sortby = nothing,
        return_fields = [],
        summarize_fields = [],
        highlight_fields = [],
        language = nothing
    )::Query

Creates a query instance that can be used to search a RediSearch instance

# Arguments
- `query_string::String`

# KeyWords
- `offset::Integer`
- `num::Integer`
- `no_content::Bool`
- `no_stopwords::Bool`
- `fields::AbstractArray`
- `verbatim::Bool`verbatim setting for 
- `with_payloads::Bool`
- `with_scores::Bool`
- `scorer::Union{String, Nothing}`
- `filters::AbstractArray{AbstractFilter}`
- `ids::AbstractArray`
- `slop::Integer`
- `in_order::Bool`
- `sortby::Union{AbstractFilter, Nothing}`
- `return_fields::AbstractArray`
- `summarize_fields::AbstractArray`
- `highlight_fields::AbstractArray`
- `language::Union{String, Nothing}`

# Returns 
- `Query::AbstractQuery`
"""
mutable struct Query <: AbstractQuery
    query_string::String
    offset::Integer
    num::Integer
    no_content::Bool
    no_stopwords::Bool
    fields::AbstractArray
    verbatim::Bool
    with_payloads::Bool
    with_scores::Bool
    scorer::Union{String,Nothing}
    filters::AbstractArray{AbstractFilter}
    ids::AbstractArray
    slop::Integer
    in_order::Bool
    sortby::Union{AbstractFilter,Nothing}
    return_fields::AbstractArray
    summarize_fields::AbstractArray
    highlight_fields::AbstractArray
    language::Union{String,Nothing}
end

function Query(
    query_string::AbstractString;
    offset=0,
    num=10,
    no_content=false,
    no_stopwords=false,
    fields=[],
    verbatim=false,
    with_payloads=false,
    with_scores=false,
    scorer=nothing,
    filters=[],
    ids=[],
    slop=-1,
    in_order=false,
    sortby=nothing,
    return_fields=[],
    summarize_fields=[],
    highlight_fields=[],
    language=nothing,
)::Query
    return Query(
        query_string,
        offset,
        num,
        no_content,
        no_stopwords,
        fields,
        verbatim,
        with_payloads,
        with_scores,
        scorer,
        filters,
        ids,
        slop,
        in_order,
        sortby,
        return_fields,
        summarize_fields,
        highlight_fields,
        language,
    )
end

"""
    limit_ids!(q::AbstractQuery, ids::AbstractArray)

Alter a query to only return specific IDs
"""
function limit_ids!(q::AbstractQuery, ids::AbstractArray)
    q.ids = ids
    return q
end

"""
    return_fields!(q::AbstractQuery, fields::AbstractArray)

Alter the query object to only return specific fields

# Arguments
- `q::AbstractQuery`: Query object
- `fields::AbstractArray`: List of fields to be returned
"""
function return_fields!(q::AbstractQuery, fields::AbstractArray)
    push!(q.return_fields, fields...)
    return q
end
return_fields!(q::AbstractQuery, field) = return_fields!(q, [field])

"""
    return_field!(q::AbstractQuery, field::AbstractString, as_field::AbstractString)

Map a return field to a new name

# Arguments
- `q::AbstractQuery`: Query object
- `field::AbstractString`: Field to be mapped
- `as_field::AbstractString`: Name for mapping to be made. 
"""
function return_field!(q::AbstractQuery, field::AbstractString, as_field::AbstractString)
    push!(q.return_fields, [field, "AS", as_field]...)
    return q
end

"""
    summarize!(
        q::AbstractQuery;
        fields::Union{Nothing,AbstractArray}=nothing,
        context_len::Union{Nothing,Number}=nothing,
        num_frags::Union{Nothing,Number}=nothing,
        sep::Union{Nothing,AbstractString}=nothing,
    )

Create a summary summary object to be used in the query.

# Arguments
- `q::AbstractQuery`: Query object

# KeyWords

- `fields::Union{Nothing,AbstractArray}`:Array of fields to summarize
- `context_len::Union{Nothing,Number}`:Context length
- `num_frags::Union{Nothing,Number}`:Number of Fragments to include
- `sep::Union{Nothing,AbstractString}`:Separater string.
"""
function summarize!(
    q::AbstractQuery;
    fields::Union{Nothing,AbstractArray}=nothing,
    context_len::Union{Nothing,Number}=nothing,
    num_frags::Union{Nothing,Number}=nothing,
    sep::Union{Nothing,AbstractString}=nothing,
)
    args = ["SUMMARIZE"]

    if !isempty(fields)
        push!(args, "LEN", string(length(fields)), fields...)
    end

    if !isnothing(context_len)
        push!(args, "LEN", string(context_len))
    end

    if !isnothing(num_frags)
        push!(args, "FRAGS", string(num_frags))
    end

    if !isnothing(sep)
        push!(args, "SPEARATOR", sep)
    end

    q.summarize_fields = args

    return q
end

"""
    highlight!(
        q::AbstractQuery; fields::AbstractArray=nothing, tags::AbstractArray=nothing
    )

    Highlighting will highlight the found term (and its variants) with a user-defined tag. 
    This may be used to display the matched text in a different typeface using a markup 
    language, or to otherwise make the text appear differently.

# Arguments
- `q::AbstractQuery`: Query object. 

# KeyWords
- `fields::AbstractArray`: List of fields
- `tags::AbstractArray`: User Tag objects.
"""
function highlight!(
    q; fields::AbstractArray=Vector{AbstractFilter}(), tags::AbstractArray=[]
)
    args = ["HIGHLIGHT"]

    if !isempty(fields)
        push!(args, "LEN", string(length(fields)), fields...)
    end

    if !isnothing(tags) && !isempty(tags)
        push!(args, "TAGS", tags...)
    end

    q.highlight_fields = args
    return q
end

"""
    get_args(q::AbstractQuery) -> Vector{Union{String,Number}}

For a query object, compile all the redis arguemnts that will be used when searching in 
RediSearch.

# Arguments
- `q::AbstractQuery`: Query object. 
"""
function get_args(q::AbstractQuery)
    args = Vector{Union{String,Number}}()
    push!(args, q.query_string)

    if q.no_content
        push!(args, "NOCONTENT")
    end

    if !isempty(q.fields)
        push!(args, "INFIELDS", string(length(q.fields)), q.fields...)
    end

    if q.verbatim
        push!(args, "VERBATIM")
    end

    if q.no_stopwords
        push!(args, "NOSTOPWORDS")
    end

    if !isempty(q.filters)
        for filter in q.filters
            if filter <: AbstractFilter
                push!(args, filter.args...)
            end
        end
    end

    if q.with_payloads
        push!(args, "WITHPAYLOADS")
    end

    if !isnothing(q.scorer)
        push!(args, "SCORER", self.scorer)
    end

    if q.with_scores
        push!(args, "WITHSCORES")
    end

    if !isempty(q.ids)
        push!(args, "INKEYS", string(length(q.ids), q.ids...))
    end

    if q.slop >= 0
        push!(args, "SLOP", q.slop)
    end

    if q.in_order
        push!(args, "INORDER")
    end

    if !isempty(q.return_fields)
        push!(args, "RETURN", string(length(q.return_fields), q.return_fields...))
    end

    if !isnothing(q.sortby)
        if !isempty(q.sortby.args)
            push!(args, "SORTBY", q.sortby.args...)
        end
    end

    if !isnothing(q.language)
        push!(args, "LANGUAGE", q.language)
    end

    push!(args, q.summarize_fields..., q.highlight_fields...)
    push!(args, "LIMIT", q.offset, q.num)

    return args
end
