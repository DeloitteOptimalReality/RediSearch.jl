export AbstractField, Field, Fields, TextField, NumericField, GeoField, TagField, redis_args

"""
    Fields

BareModel for Fields available in the RediSearch Framework.

# Members
- `NUMERIC`
- `TEXT`
- `NOSTEM`
- `PHONETIC`
- `WEIGHT`
- `GEO`
- `TAG`
- `SEPARATOR`
- `SORTABLE`
- `NOINDEX`
- `AS`
"""
baremodule Fields
    const NUMERIC = "NUMERIC"
    const TEXT = "TEXT"
    const NOSTEM = "NOSTEM"
    const PHONETIC = "PHONETIC"
    const WEIGHT = "WEIGHT"
    const GEO = "GEO"
    const TAG = "TAG"
    const SEPARATOR = "SEPARATOR"
    const SORTABLE = "SORTABLE"
    const NOINDEX = "NOINDEX"
    const AS = "AS"
end

abstract type AbstractField end

"""
    Field::AbstractField(
        name::String
        args::Vector{Union{String,Number}}
        sortable::Bool
        no_index::Bool
        as_name::Union{String,Nothing}
    )

Field object to include in RediSearch schema.

# Arguments
- `name::String`: Name of the field.

# KeyWords
- `args::Vector{Union{String,Number}}`: List of Arguments fot the field.
- `sortable::Bool`: Sortable status.
- `no_index::Bool`: Index Status.
- `as_name::Union{String,Nothing}`: Name to reference field as.

# Returns
- `Field::AbstractField`
"""
mutable struct Field <: AbstractField
    name::String
    args::Vector{Union{String,Number}}
    sortable::Bool
    no_index::Bool
    as_name::Union{String,Nothing}
end

function Field(
    name::String;
    args=Vector{Union{String,Number}}(),
    sortable=false,
    no_index=false,
    as_name=nothing,
)
    if !isnothing(as_name)
        args = vcat(args, [Fields.AS, as_name])
    end

    if sortable
        append!(args, [Fields.SORTABLE])
    end

    if no_index
        sortable && throw(ErrorException("Cannot Allow for Sortable and No Index on Field"))
        append!(args, [Fields.NOINDEX])
    end

    return Field(name, args, sortable, no_index, as_name)
end

"""
    TextField(name; weight=1.0, no_stem=false, phonetic=nothing, kwargs...)

Creates a TextField.

# Arguments
- `name`: Name of the field.

# KeyWords
- `weight`: Weight of the field.
- `no_stem`: Stem bool.
- `phonetic`: Phonetic reference.
- `kwargs...`: Additional fields defined in the `Field` object.

# Returns 
- `TextField::Field`
"""
function TextField(name; weight=1.0, no_stem=false, phonetic="", kwargs...)
    field = Field(name; args=[Fields.TEXT, Fields.WEIGHT, weight], kwargs...)

    if !isempty(phonetic) && phonetic in ["dm:en", "dm:fr", "dm:pt", "dm:es"]
        append!(field.args, [Fields.PHONETIC, phonetic])
    end

    if no_stem
        append!(field.args, [Fields.NOSTEM])
    end

    return field
end

"""
    NumericField(name; kwargs...)

Creates a NumericField object.

# Arguments
- `name`: Name of the field.

# KeyWords
- `kwargs...`: Additional fields defined in the `Field` object.

# Returns 
- `NumericField::Field`
"""
function NumericField(name; kwargs...)
    return Field(name; args=[Fields.NUMERIC], kwargs...)
end

"""
    GeoField(name; kwargs...)

Creates a GeoField object.

# Arguments
- `name`: Name of the field.

# KeyWords
- `kwargs...`: Additional fields defined in the `Field` object.

# Returns 
- `GeoField::Field`
"""
function GeoField(name; kwargs...)
    return Field(name; args=[Fields.GEO], kwargs...)
end

"""
    TagField(name; separator=",", kwargs...)

Creates a TagField object.

# Arguments
- `name`: Name of the field.

# KeyWords
- `separator`: Separator string.
- `kwargs...`: Additional fields defined in the `Field` object.

# Returns 
- `TagField::Field`
"""
function TagField(name; separator=",", kwargs...)
    return Field(name; args=[Fields.TAG, Fields.SEPARATOR, separator], kwargs...)
end

"""
    redis_args(field::AbstractField)

Create an array of strings to represent the RedisArgs of a Field.

# Arguments
- `field::AbstractField`: Field to fetch arguements for.

# Returns
- `AbstractArray{String}`: List of strings that represent Redis arguments.
"""
function redis_args(field::AbstractField)
    return vcat(field.name, field.args)
end
