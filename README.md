# JediSearch.jl
A RediSearch API for Julia. This package uses **[Jedis.jl](https://github.com/captchanjack/Jedis.jl)** as a the Redis api to interact with a redis server. All additional features needed to use the secondary indexing module **[RediSearch](https://oss.redis.com/redisearch/)** can be found in this package


## Usage 
### Generating a client
Generating a client object:
```
julia> using JediSearch;
julia> client = SearchClient("myIdx"; host="localhost", port=6379);
```

This client sets both the search client object for JediSearch and the Redis Global client in Jedis. a client can be retrieved at any time using:
```
julia> get_search_client();
```

Viewing the index name associated to a client:
```
julia> client.index_name
"myIdx"
```

while the base Jedis client can be viewd with:
```
julia> client.client;
```

### Creating Fields
Fields define the searchable schema:
```
julia> field_1 = TextField("name"; weight=2);
julia> field_2 = NumericField("age");
julia> field_3 = TextField("occupation"; weight=1.5, as_name="job");
julia> schema = [field_1, field_2, field_3]

```

### Creating an Index
Fields from above are used within an IndexDefintion to define a searchable schema within a RediSearch client.

An IndexDefinition should be made first to define the prefixes that will be indexed. 
```
julia> definition = IndexDefinition(prefix=["person:"]);
```
We can use this defition along with fields to create a searchable index:

```
julia> create_index(schema; definition=definition);
```

### Adding Items to Index

Data is inserted into the RediSearch client by using the **[hset](https://captchanjack.github.io/Jedis.jl/commands/#Jedis.hset)** command. 
```
julia> using Jedis
julia> hset("person:1", "name", "James", "age",26, "occupation", "software")
3
```

**NOTE** This is for a schema using the HASH  index type. This differes when using the JSON index type.

### Searching a Schema
Create a query and search:
```
julia> q = Query("software");
julia> results = search(q)
[ Info: Result: 1 total
JediSearch.Result(
  1,
  0.0018129348754882812,
  JediSearch.Document[
    JediSearch.Document(
      "person:1",
      nothing,
      Dict{Any, Any}(
        :age => "26",
        :name => "James",
        :occupation => "software"
      )
    )
  ]
)
```