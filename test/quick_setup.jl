
function quick_setup()
    client = SearchClient("idx")
    definition = IndexDefinition(prefix=["idx:"])
    fields = [
        TextField("field1"),
        TextField("field2"),
        NumericField("field3")
    ]
    create_index(fields; definition=definition)
end

function quick_flush()
    Jedis.flushall()
end