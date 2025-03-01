# TileDB Array Metadata
#tiledb #arrays #metadata

TileDB supports storing array metadata in the form of key-pair values.
This metadata is stored in a directory `__meta/` within each array directory.
All key and value binary data items are serialized into a tile and gzipped.

Those files are timestamped in the same manner as fragments.
This is for the same reasons: immutability, concurrent writes, and time travel.

In addition, TileDB Cloud indexes the metadata to enable global keyword search
across all arrays, enhancing asset discoverability.

