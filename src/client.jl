export SearchClient, create_index, get_search_client, drop_index

"""
    Client(index_name::AbstractString; kwargs....) -> Jedis.Client

Set the RediSearch Client. Clients contain an index name and a Jedis Client Struct. 
Kwargs are included as any Jedis client kwargs

# Fields
- `index_name::String`: Index name that will be created with the client.
- `client::Jedis.Client`: Client object made through the Jedis package. 

# Examples
```julia-repl
julia> client = Client("myIdx");

julia> client = Client("myIdx"; host="localhost", port=6379);
```
"""
mutable struct SearchClient
    index_name::String
    client::Jedis.Client
end

function SearchClient(index_name::AbstractString; kwargs...)::SearchClient
    client = SearchClient(index_name, Jedis.Client(; kwargs...))
    SEARCHCLIENT[] = client
    return client
end

"""
    Global client of RediSearch. Used to reference the base client for RediSearch made 
    through `Client()`.
"""
const SEARCHCLIENT = Ref{SearchClient}()

""" Return the client object for RediSearch"""
get_search_client() = SEARCHCLIENT[]

"""
    create_index(
        fields;
        client=get_search_client(),
        no_term_offsets=false,
        no_field_flags=false,
        stopwords=nothing,
        definition=nothing,
        max_text_fields=false,
        temporary=nothing,
        no_highlight=false,
        no_term_frequencies=false,
        skip_initial_scan=false,
    )
    create_index(field::AbstractField; kwargs...) = create_index([field]; kwargs...)

Creates an index with the given spec. If an index already exists, this will error.


# Arguments
- `fields`: List of Field objects

# Keywords
- `client`: Search client
- `no_term_offsets`: Bool for offsets.
- `no_field_flags`: Bool for field flags
- `stopwords`: List of stopwords. If nothing, default stopwords are used. 
- `definition`: Index Definition object.
- `max_text_fields`: Forces RediSearch to encode indexes as if there were more than 32 
text attributes.
- `temporary`: Create a lightweight temporary index which will expire after the specified 
period of inactivity.
- `no_highlight`: Conserves storage space and memory by disabling highlighting support.
- `no_term_frequencies`: If true, we avoid saving the term frequencies in the index.
- `skip_initial_scan`: If true, we do not scan and index.
"""
function create_index(
    fields;
    client=get_search_client(),
    no_term_offsets=false,
    no_field_flags=false,
    stopwords=nothing,
    definition=nothing,
    max_text_fields=false,
    temporary=nothing,
    no_highlight=false,
    no_term_frequencies=false,
    skip_initial_scan=false,
)
    args = []
    append!(args, [SearchCommands.CREATE_CMD, client.index_name])
    redis_client = client.client

    if !isnothing(definition)
        append!(args, definition.args)
    end

    if max_text_fields
        push!(args, SearchCommands.MAXTEXTFIELDS)
    end

    if !isnothing(temporary) && temporary isa Integer
        append!(args, [SearchCommands.TEMPORARY, temporary])
    end

    if no_term_offsets
        push!(args, SearchCommands.NOOFFSETS)
    end

    if no_highlight
        push!(args, SearchCommands.NOHL)
    end

    if no_field_flags
        push!(args, SearchCommands.NOFIELDS)
    end

    if no_term_frequencies
        push!(args, SearchCommands.NOFREQS)
    end

    if skip_initial_scan
        push!(args, SearchCommands.SKIPINITIALSCAN)
    end

    if !isnothing(stopwords) && isa_list(stopwords)
        num_stopwords = length(stopwords)
        append!(args, [SearchCommands.STOPWORDS, num_stopwords])

        if num_stopwords > 0
            append!(args, [word for word in stopwords])
        end
    end

    push!(args, "SCHEMA")
    schema_args = []

    for field in fields
        append!(schema_args, redis_args(field))
    end

    append!(args, schema_args)
    return Jedis.execute(args, redis_client)
end


""" 
    drop_index(index; client=get_search_client())

Drop an index against a Client.

# Arguments
- `index`: Index name to be dropped

# Keywords
- `client::SearchClient`: RediSearch Client
"""
function drop_index(index; client::SearchClient=get_search_client())
    return Jedis.execute([SearchCommands.DROP_CMD, index], client.client)
end
drop_index() = drop_index(get_search_client().index_name)
