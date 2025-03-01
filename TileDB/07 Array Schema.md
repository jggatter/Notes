# TileDB Array Schema
#tiledb #array

The array schema stores all the info specified upon array creation.

It's stored in a timestamped file inside a folder called `__schema`,
which itself is inside the array directory.
All the information is serialized in the one place.

This information includes but is not limited to the following:
- Array type (dense or sparse)
- Dims and all info about them (types, domains, etc.)
- Attrs and all info about them (types, tile filters, etc.)
- Whether the array is encrypted
- The tile and cell orders
- The tile capacity (for sparse arrays)

## Schema Evolution

Schema evolution allows altering of array schema after creation or population.

Time traveling is supported in the presence of evolved schemas.
This allows us to see the state of our array at older timepoints.

Currently the following schema evolution operations are supported:
1. Dropping an attribute
2. Adding an attribute

