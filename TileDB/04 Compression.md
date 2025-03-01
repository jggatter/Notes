# TileDB Compression
#tiledb

TileDB supports several filters performing generic compression.
Compression is specified:
- (generally) per attr,
- or per dim in sparse arrays,
- or per offsets for var-length attrs.

Compression applies to each physical data tile.

TileDB further partitions each physical data tile into _chunks_,
which typically have their size equal to the L1 cache.
The chunks are streamed into the compression process.

Supported compression filters in TileDB (Python):
- GZIP: `tiledb.GzipFilter()` with level option (np.int32)
- Zstandard: `tiledb.ZstdFilter()` with level option (np.int32)
- LZ4: `tiledb.Lz4Filter()` with level option (np.int32)
- Run-length encoding: `tiledb.RleFilter()` with level option (np.int32)
- BZIP2: `tiledb.Bzip2Filter()` with level option (np.int32)
- Double Delta: `tiledb.DoubleDeltaFilter()` with no options.

C/C++/Go support the same filters but names differ, e.g. `TILEDB_FILTER_GZIP`.

Default option value is `-1`.

