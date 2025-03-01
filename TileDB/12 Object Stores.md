# Object Stores and TileDB

Object stores such as Amazon S3, Google Cloud Storage, etc.,
provide several benefits to organizations
that are looking to store and analyze large quantities of data,
such as "infinite" scalability and high throughput at relatively low cost.

However they introduce a few challenges:
- Objects (i.e. file) is immutable, changing any byte = changing entire object
- Ops such as listing objs may be subject to different consistency guarantees
- File locking isn't a concept known to or supported by object stores
- Object stores may incur high latency when reading various objects.

These characteristics greatly affect how data systems implement various ops,
such as updates, indexing, etc.
TileDB takes care to optimize I/O for each obj store using corresponding SDKs,
nicely abstracting the backends (enabling support for future backends).

