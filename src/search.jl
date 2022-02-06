export search, _mk_query_args
"""
    search(q::AbstractQuery; client=get_search_client()) -> Result

Using a query objects, search RediSearch. 

# Arguments
- `q::AbstractQuery`: Query object.

# KeyWords
- `client`: Client that will be searched.
"""
function search(q::AbstractQuery; client=get_search_client())
    isnothing(client) && return nothing
    args = _mk_query_args(q; client=client)
    start_time = time()
    res = Jedis.execute([SearchCommands.SEARCH_CMD, args...], client.client)

    return Results(
        res,
        !(q.no_content),
        time() - start_time;
        has_payload=q.with_payloads,
        with_scores=q.with_scores,
    )
end

"""
    _mk_query_args(query; client=get_search_client())

From a query object, generate the search arguments.
"""
function _mk_query_args(query; client=get_search_client())
    args = Vector{Union{Number,String}}([client.index_name])

    append!(args, get_args(query))
    return args
end
