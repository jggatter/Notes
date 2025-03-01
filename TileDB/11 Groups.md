# TileDB Groups
#tiledb

Organizes arrays, other groups, and other TileDB assets into hierarchies,
similar to folders in traditional file managers.

However TileDB groups do this organization logically.
Groups differ from traditional file managers in two ways:
1. Physical location of any array/group/asset may be different from logical
   location of the asset in a TileDB group.
2. Same asset with same physical location may belong to more than one group.

This provides a lot of flexibility in dynamically grouping various assets,
especially on (cloud) object storage,
without physically copying/moving enormous quantities of data from
one physical path to another.

Each group is physically stored as a collection of folders/files,
similar to arrays.

On TileDB Cloud, access policies can be applied to a group, similar
to arrays and other assets.
This allows flexible organization and governance of all data in one place.
