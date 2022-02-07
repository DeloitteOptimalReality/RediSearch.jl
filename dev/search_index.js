var documenterSearchIndex = {"docs":
[{"location":"#RediSearch-Documentation","page":"Home","title":"RediSearch Documentation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Depth = 3","category":"page"},{"location":"#Public-Functions","page":"Home","title":"Public Functions","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"These functions are exported by RediSearch.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [RediSearch]\nPrivate = false","category":"page"},{"location":"#RediSearch.Field","page":"Home","title":"RediSearch.Field","text":"Field::AbstractField(\n    name::String\n    args::Vector{Union{String,Number}}\n    sortable::Bool\n    no_index::Bool\n    as_name::Union{String,Nothing}\n)\n\nField object to include in RediSearch schema.\n\nArguments\n\nname::String: Name of the field.\n\nKeyWords\n\nargs::Vector{Union{String,Number}}: List of Arguments fot the field.\nsortable::Bool: Sortable status.\nno_index::Bool: Index Status.\nas_name::Union{String,Nothing}: Name to reference field as.\n\nReturns\n\nField::AbstractField\n\n\n\n\n\n","category":"type"},{"location":"#RediSearch.IndexDefinition","page":"Home","title":"RediSearch.IndexDefinition","text":"IndexDefinition(args)\n\nObject used to create a specific index in Redis. \n\nFields\n\nargs::Vector{Union{String,Number}}: List of arguments used to define a searchable index.\n\n\n\n\n\n","category":"type"},{"location":"#RediSearch.IndexDefinition-Tuple{}","page":"Home","title":"RediSearch.IndexDefinition","text":"IndexDefinition(;\n    prefix=[],\n    filter=\"\",\n    language_field=\"\",\n    language=\"\",\n    score_field=\"\",\n    score=1.0,\n    payload_field=\"\",\n    index_type=IndexType.HASH\n) -> IndexDefinition\n\nIndexDefinition is used to define a index definition for automatic indexing on  Hash or Json update.\n\nKeyWords\n\nprefix::AbstractArray{AbstractString}: Tells the index which keys it should index. Each \n\nprefix should finish with a :.\n\nfilter::AbstractString: Filter expression with the full RediSearch aggregation \n\nexpression language.\n\nlanguage_field::AbstractString: If set indicates the document attribute that should be \n\nused as the document language.\n\nlanguage::AbstractString: If set indicates the default language for documents in the \n\nindex. Default to English.\n\nscore_field::AbstractString: If set indicates the document attribute that should be used\n\nas the document's rank based on the user's ranking. Ranking must be between 0.0 and 1.0.  If not set the default score is 1\n\nscore::Float64: If set indicates the default score for documents in the index. \n\nDefault score is 1.0.\n\npayload_field::AbstractString: If set indicates the document attribute that should be \n\nused as a binary safe payload string to the document, that can be evaluated at query time by a custom scoring function, or retrieved to the client.\n\nindex_type::Number: Currently supports HASH (default) and JSON.\n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.Query","page":"Home","title":"RediSearch.Query","text":"Query(\n    query_string::AbstractString;\n    offset = 0,\n    num = 10,\n    no_content = false,\n    no_stopwords = false,\n    fields = [],\n    verbatim = false,\n    with_payloads = false,\n    with_scores = false,\n    scorer = nothing,\n    filters = [],\n    ids = [],\n    slop = -1,\n    in_order = false,\n    sortby = nothing,\n    return_fields = [],\n    summarize_fields = [],\n    highlight_fields = [],\n    language = nothing\n)::Query\n\nCreates a query instance that can be used to search a RediSearch instance\n\nArguments\n\nquery_string::String\n\nKeyWords\n\noffset::Integer\nnum::Integer\nno_content::Bool\nno_stopwords::Bool\nfields::AbstractArray\nverbatim::Boolverbatim setting for \nwith_payloads::Bool\nwith_scores::Bool\nscorer::Union{String, Nothing}\nfilters::AbstractArray{AbstractFilter}\nids::AbstractArray\nslop::Integer\nin_order::Bool\nsortby::Union{AbstractFilter, Nothing}\nreturn_fields::AbstractArray\nsummarize_fields::AbstractArray\nhighlight_fields::AbstractArray\nlanguage::Union{String, Nothing}\n\nReturns\n\nQuery::AbstractQuery\n\n\n\n\n\n","category":"type"},{"location":"#RediSearch.SearchClient","page":"Home","title":"RediSearch.SearchClient","text":"Client(index_name::AbstractString; kwargs....) -> Jedis.Client\n\nSet the RediSearch Client. Clients contain an index name and a Jedis Client Struct.  Kwargs are included as any Jedis client kwargs\n\nFields\n\nindex_name::String: Index name that will be created with the client.\nclient::Jedis.Client: Client object made through the Jedis package. \n\nExamples\n\njulia> client = Client(\"myIdx\");\n\njulia> client = Client(\"myIdx\"; host=\"localhost\", port=6379);\n\n\n\n\n\n","category":"type"},{"location":"#RediSearch.GeoField-Tuple{Any}","page":"Home","title":"RediSearch.GeoField","text":"GeoField(name; kwargs...)\n\nCreates a GeoField object.\n\nArguments\n\nname: Name of the field.\n\nKeyWords\n\nkwargs...: Additional fields defined in the Field object.\n\nReturns\n\nGeoField::Field\n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.NumericField-Tuple{Any}","page":"Home","title":"RediSearch.NumericField","text":"NumericField(name; kwargs...)\n\nCreates a NumericField object.\n\nArguments\n\nname: Name of the field.\n\nKeyWords\n\nkwargs...: Additional fields defined in the Field object.\n\nReturns\n\nNumericField::Field\n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.SortByField-Tuple{AbstractString}","page":"Home","title":"RediSearch.SortByField","text":"SortByField(field::AbstractString; asc::Bool=true)\n\nCreate a Fitler object for sorting specific fields.\n\nArguments\n\nfield::AbstractString: Field name that is being sorted\n\nKeyWords\n\nasc::Bool: Sort by ascending, default as true\n\nReturns\n\nFitler::AbstractFilter\n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.TagField-Tuple{Any}","page":"Home","title":"RediSearch.TagField","text":"TagField(name; separator=\",\", kwargs...)\n\nCreates a TagField object.\n\nArguments\n\nname: Name of the field.\n\nKeyWords\n\nseparator: Separator string.\nkwargs...: Additional fields defined in the Field object.\n\nReturns\n\nTagField::Field\n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.TextField-Tuple{Any}","page":"Home","title":"RediSearch.TextField","text":"TextField(name; weight=1.0, no_stem=false, phonetic=nothing, kwargs...)\n\nCreates a TextField.\n\nArguments\n\nname: Name of the field.\n\nKeyWords\n\nweight: Weight of the field.\nno_stem: Stem bool.\nphonetic: Phonetic reference.\nkwargs...: Additional fields defined in the Field object.\n\nReturns\n\nTextField::Field\n\n\n\n\n\n","category":"method"},{"location":"#RediSearch._mk_query_args-Tuple{Any}","page":"Home","title":"RediSearch._mk_query_args","text":"_mk_query_args(query; client=get_search_client())\n\nFrom a query object, generate the search arguments.\n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.create_index-Tuple{Any}","page":"Home","title":"RediSearch.create_index","text":"create_index(\n    fields;\n    client=get_search_client(),\n    no_term_offsets=false,\n    no_field_flags=false,\n    stopwords=nothing,\n    definition=nothing,\n    max_text_fields=false,\n    temporary=nothing,\n    no_highlight=false,\n    no_term_frequencies=false,\n    skip_initial_scan=false,\n)\ncreate_index(field::AbstractField; kwargs...) = create_index([field]; kwargs...)\n\nCreates an index with the given spec. If an index already exists, this will error.\n\nArguments\n\nfields: List of Field objects\n\nKeywords\n\nclient: Search client\nno_term_offsets: Bool for offsets.\nno_field_flags: Bool for field flags\nstopwords: List of stopwords. If nothing, default stopwords are used. \ndefinition: Index Definition object.\nmax_text_fields: Forces RediSearch to encode indexes as if there were more than 32 \n\ntext attributes.\n\ntemporary: Create a lightweight temporary index which will expire after the specified \n\nperiod of inactivity.\n\nno_highlight: Conserves storage space and memory by disabling highlighting support.\nno_term_frequencies: If true, we avoid saving the term frequencies in the index.\nskip_initial_scan: If true, we do not scan and index.\n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.get_args-Tuple{RediSearch.AbstractQuery}","page":"Home","title":"RediSearch.get_args","text":"get_args(q::AbstractQuery) -> Vector{Union{String,Number}}\n\nFor a query object, compile all the redis arguemnts that will be used when searching in  RediSearch.\n\nArguments\n\nq::AbstractQuery: Query object. \n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.get_search_client-Tuple{}","page":"Home","title":"RediSearch.get_search_client","text":"Return the client object for RediSearch\n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.highlight!-Tuple{Any}","page":"Home","title":"RediSearch.highlight!","text":"highlight!(\n    q::AbstractQuery; fields::AbstractArray=nothing, tags::AbstractArray=nothing\n)\n\nHighlighting will highlight the found term (and its variants) with a user-defined tag. \nThis may be used to display the matched text in a different typeface using a markup \nlanguage, or to otherwise make the text appear differently.\n\nArguments\n\nq::AbstractQuery: Query object. \n\nKeyWords\n\nfields::AbstractArray: List of fields\ntags::AbstractArray: User Tag objects.\n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.limit_ids!-Tuple{RediSearch.AbstractQuery, AbstractArray}","page":"Home","title":"RediSearch.limit_ids!","text":"limit_ids!(q::AbstractQuery, ids::AbstractArray)\n\nAlter a query to only return specific IDs\n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.redis_args-Tuple{AbstractField}","page":"Home","title":"RediSearch.redis_args","text":"redis_args(field::AbstractField)\n\nCreate an array of strings to represent the RedisArgs of a Field.\n\nArguments\n\nfield::AbstractField: Field to fetch arguements for.\n\nReturns\n\nAbstractArray{String}: List of strings that represent Redis arguments.\n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.return_field!-Tuple{RediSearch.AbstractQuery, AbstractString, AbstractString}","page":"Home","title":"RediSearch.return_field!","text":"return_field!(q::AbstractQuery, field::AbstractString, as_field::AbstractString)\n\nMap a return field to a new name\n\nArguments\n\nq::AbstractQuery: Query object\nfield::AbstractString: Field to be mapped\nas_field::AbstractString: Name for mapping to be made. \n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.return_fields!-Tuple{RediSearch.AbstractQuery, AbstractArray}","page":"Home","title":"RediSearch.return_fields!","text":"return_fields!(q::AbstractQuery, fields::AbstractArray)\n\nAlter the query object to only return specific fields\n\nArguments\n\nq::AbstractQuery: Query object\nfields::AbstractArray: List of fields to be returned\n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.search-Tuple{RediSearch.AbstractQuery}","page":"Home","title":"RediSearch.search","text":"search(q::AbstractQuery; client=get_search_client()) -> Result\n\nUsing a query objects, search RediSearch. \n\nArguments\n\nq::AbstractQuery: Query object.\n\nKeyWords\n\nclient: Client that will be searched.\n\n\n\n\n\n","category":"method"},{"location":"#Private-Functions","page":"Home","title":"Private Functions","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"These functions are internal to RediSearch.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [RediSearch]\nPublic = false","category":"page"},{"location":"#RediSearch.SEARCHCLIENT","page":"Home","title":"RediSearch.SEARCHCLIENT","text":"Global client of RediSearch. Used to reference the base client for RediSearch made \nthrough `Client()`.\n\n\n\n\n\n","category":"constant"},{"location":"#RediSearch.Document","page":"Home","title":"RediSearch.Document","text":"Document(id::AbstractString; score=nothing, payload=nothing, kwargs...) -> Document\n\nA RediSearch Document that is returned from a search query.\n\nAttributes\n\nid::String: Redis Key id that the document is stored in.\nscore::Union{Float64,Nothing}: Match Score for the document based on the search \n\ncriteria.\n\npayload::Union{Nothing,AbstractDict}: Payload returned buy the query.\nkwargs: Additional redis fields.\n\n\n\n\n\n","category":"type"},{"location":"#RediSearch.Filter","page":"Home","title":"RediSearch.Filter","text":"Filter\nFilter{AbstractFilter}\n\nFilter object that can be used in RediSearch\n\nFields\n\nargs::AbstractArray: Redis args that will be used when searching\n\n\n\n\n\n","category":"type"},{"location":"#RediSearch.Result","page":"Home","title":"RediSearch.Result","text":"Result(total, duration, docs)\n\nFormatted response object from redis. \n\nFields\n\ntotal::Integer: Number of results found for the \nduration::Float64: Length of time taken to find all results.\ndocs::Vector{Document}: Documents objects that are returned from  a search.\n\n\n\n\n\n","category":"type"},{"location":"#RediSearch.Results-Tuple{Any, Bool, Number}","page":"Home","title":"RediSearch.Results","text":"Results(res, has_content, duration; has_payload=false, with_scores=false)\n\nCreate the Result object from a Redis search response. \n\nArguments\n\nres: Response from Redis\nhas_content: Bool flag for if there is content returned\nduration: Time taken for query to return results\n\nKeywords\n\nhas_payload::Bool: Flag for payload bring returned.\nwith_scores::Bool: Flag for scores being returned. \n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.drop_index-Tuple{Any}","page":"Home","title":"RediSearch.drop_index","text":"drop_index(index; client=get_search_client())\n\nDrop an index against a Client.\n\nArguments\n\nindex: Index name to be dropped\n\nKeywords\n\nclient::SearchClient: RediSearch Client\n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.isa_list-Tuple{Any}","page":"Home","title":"RediSearch.isa_list","text":"Checks if l is a typle, list or vector type \n\n\n\n\n\n","category":"method"},{"location":"#RediSearch.summarize!-Tuple{RediSearch.AbstractQuery}","page":"Home","title":"RediSearch.summarize!","text":"summarize!(\n    q::AbstractQuery;\n    fields::Union{Nothing,AbstractArray}=nothing,\n    context_len::Union{Nothing,Number}=nothing,\n    num_frags::Union{Nothing,Number}=nothing,\n    sep::Union{Nothing,AbstractString}=nothing,\n)\n\nCreate a summary summary object to be used in the query.\n\nArguments\n\nq::AbstractQuery: Query object\n\nKeyWords\n\nfields::Union{Nothing,AbstractArray}:Array of fields to summarize\ncontext_len::Union{Nothing,Number}:Context length\nnum_frags::Union{Nothing,Number}:Number of Fragments to include\nsep::Union{Nothing,AbstractString}:Separater string.\n\n\n\n\n\n","category":"method"}]
}