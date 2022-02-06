""" Checks if `l` is a typle, list or vector type """
isa_list(l) = l isa Vector || l isa Tuple || l isa Array
