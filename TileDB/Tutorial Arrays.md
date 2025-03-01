# TileDB Arrays
#python #arrays #sparse #dense #arrayschema #nosql

[Blog](https://tiledb.com/blog/tiledb-101-arrays)

TileDB is a multi-modal database.

The multi-dimensional array is a first class citizen in TileDB.

## Dimensions vs. Attributes

Dimensions orient the multi-dimensional space of the array, which is composed of cells.

Attributes specify what kind of values are store in each of the cells of the
multi-dimensional space.

Dimensions are the special attributes of your data where range search can
happen very, very fast.

Simple analogy is the index of a dataframe: The indexed columns are the dimensions, and the rest of the columns are attributes.

## Dense vs. Sparse

A dense array must have a value in every single one of its cells,
even if that value is empty.

A sparse array may have empty cells that TileDB will never materialize.

A 2D image is best stored as dense to store the value of every pixel,
whereas datasets with many zeros or missing values (scRNA-seq raw counts)
may best be stored as sparse.

## Array Schema

The two decisions of:
- dimensions vs. attributes 
- and dense vs. sparse 

need to be specified in the _array schema_,
which describes all info needed to understand the basic config of the array.

## Example of Dense Array 

In a simple 4x4 2D dense array, there are two dimensions here, `d1` and `d2`.
The *dimension `domain`* of each is `(0, 3)` 
nto inclusively specify the lower and upper bounds of each.

```python
import numpy as np
import tiledb

dd1 = tiledb.Dim(name="d1", domain=(0, 3), tile=2, dtype=np.int32)
dd2 = tiledb.Dim(name="d2", domain=(0, 3), tile=2, dtype=np.int32)
```

Collectively, the dimensions define the *array domain*:
```python
ddom = tiledb.Domain(dd1, dd2)
```
This effectively creates a 4x4 dense array.

Let's create two attributes, the first a string and the second a 64-bit float.
```python
da1 = tiledb.Attr(name="a1", dtype=np.dtype('U0'))
da2 = tiledb.Attr(name="a2", dtype=np.float64)
```

With the domain and the attributes of the array set,
these two pieces come together to form the array's schema:
```python
# Note: sparse=False is default
dschema = tiledb.ArraySchema(domain=ddom, sparse=False, attrs=[da1, da2])
```

The array can now be materialzed on disk:
```python
array_dense = os.path.expanduser('~/array_dense')
tiledb.Array.create(array_dense, dschema)
```
And opened with:
```python
A = tiledb.open(array_dense)
print(A.schema)
```
```output
ArraySchema(
  domain=Domain(*[
    Dim(name='d1', domain=(0, 3), tile=2, dtype='int32'),
    Dim(name='d2', domain=(0, 3), tile=2, dtype='int32'),
  ]),
  attrs=[
    Attr(name='a1', dtype='<U0', var=True, nullable=False),
    Attr(name='a2', dtype='float64', var=False, nullable=False),
  ],
  cell_order='row-major',
  tile_order='row-major',
  capacity=10000,
  sparse=False,
)
```

We write some data to the entire 4x4 array for both attributes:
```python
da1_data = np.array(
    [['apple', 'banana', 'cat', 'dog'],
    ['egg', 'frog', 'gas', 'hover'],
    ['icey', 'justice', 'krill', 'lemming'],
    ['munch', 'nothing', 'opal', 'polyester']],
    dtype='<U0'
)
da2_data = np.array(
    [[0.0, 0.1, 0.2, 0.3],
    [1.0, 1.1, 1.2, 1.3],
    [2.0, 2.1, 2.2, 2.3],
    [3.0, np.nan, 3.2, 3.3]],
    dtype=np.float64
)
```

We open the TileDB array in write mode and provide the above values
in an ordered dictionary:
```python
with tiledb.open(array_dense, 'w') as A:
    A[:] = {'a1': da1_data, 'a2': da2_data}

    # If we only had one attribute we'd write it directly:
    #A[:] = da1_data
```
To read it back:
```python
with tiledb.open(array_dense):
    print(A[:])
```

TileDB allows slicing in a variety of ways without having to bring 
unncessary data to main memory from disk:
```python
A[2:3, 1:3]  # Returns only subarray [2,2], [1,2]
```
```output
OrderedDict([('a1', array([['justice', 'krill']], dtype=object)),
             ('a2', array([[2.1, 2.2]]))])
```

Let's slice only on one attribute:
```python
A.query(attrs=['a1'])[:]
```

You can also slice directly on a Pandas DataFrame as TileDB arrays can be
also logically thought of as a dataframe:
```python
A.df[:]
```
```output
	d1	d2	a1		a2
0	0	0	apple		0.0
1	0	1	banana		0.1
2	0	2	cat		0.2
3	0	3	dog		0.3
4	1	0	egg		1.0
5	1	1	frog		1.1
6	1	2	gas		1.2
7	1	3	hover		1.3
8	2	0	icey		2.0
9	2	1	justice		2.1
10	2	2	krill		2.2
11	2	3	lemming		2.3
12	3	0	munch		3.0
13	3	1	nothing		NaN
14	3	2	opal		3.2
15	3	3	polyester	3.
```

## Example of Sparse Array

Similarly let's create a sparse 2D array.
We'll make one string attribute. 
We'll use a string as one dimension and a 32-bit float as the other 
to demonstrate that sparse arrays can have heterogenous dimensions 
(as well as infinite domains!).

We'll use `sparse=True` to initialize the `ArraySchema`:
```python
# Create dimensions
sd1 = tiledb.Dim(name='d1', dtype='ascii')
sd2 = tiledb.Dim(name='d2', domain=(0.0, 10.0), tile=2, dtype=np.float32)

# Create array domain
sdom = tiledb.Domain(sd1, sd2)

# Create the string attribute
sa1 = tiledb.Attr(name="a1", dtype=np.dtype('U0'))

# Create array schema, setting `sparse=True`
sschema = tiledb.ArraySchema(domain=sdom, sparse=True, attrs=[sa1])

# Materialize the array on disk
array_sparse = os.path.expanduser("~/array_sparse")
tiled.Array.create(array_sparse, sschema)
```
Inspecting:
```python
B = tiledb.open(array_sparse)
print(B.schema)
```
```
ArraySchema(
  domain=Domain(*[
    Dim(name='d1', domain=('', ''), tile=None, dtype='|S0', var=True),
    Dim(name='d2', domain=(0.0, 10.0), tile=2.0, dtype='float32'),
  ]),
  attrs=[
    Attr(name='a1', dtype='<U0', var=True, nullable=False),
  ],
  cell_order='row-major',
  tile_order='row-major',
  capacity=10000,
  sparse=True,
  allows_duplicates=False,
)
```

Let's write data.

Note that with sparse arrays, we have to pass a 1D numpy array for each dim
in order to specify the so-called coordinates of each non-empty cell 
(since TileDB doesn't materialze empty cells).

There should be a 1:1 correspondence between each of the values passed 
for each dimension and attribute.
```python
sd1_data = np.array(
    ["a", "bb", "ccc", "dddd", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"],
    dtype='<U0'
)
sd2_data = np.array(
    [0. , 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.10, 0.11, 0.12, 0.13, 0.14, 0.15],
    dtype=np.float32
)
sa1_data = da1_data.flatten() # we’ll simply reuse the dense data

with tiledb.open(array_sparse, 'w') as B:
    B[sd1_data, sd2_data] = sa1_data
```
The above writes the data into the array on disk.
Next, let's read some data from this array:
```python
B = tiledb.open(array_sparse, 'r')
B[:]
```
```output
OrderedDict([('a1',
              array(['apple', 'banana', 'cat', 'dog', 'egg', 'frog', 'gas', 'hover',
                     'icey', 'justice', 'krill', 'lemming', 'munch', 'nothing', 'opal',
                     'polyester'], dtype=object)),
             ('d1',
              array([b'a', b'bb', b'ccc', b'dddd', b'e', b'f', b'g', b'h', b'i', b'j',
                     b'k', b'l', b'm', b'n', b'o', b'p'], dtype=object)),
             ('d2',
              array([0.  , 0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1 ,
                     0.11, 0.12, 0.13, 0.14, 0.15], dtype=float32))])
```

We can slice portions of the array. 
We can use the `multi_index` operator/accessor for the string dimensions
which respects TileDB's inclusive semantics:
```python
B.multi_index["c":"g", 0.02:0.06]
```
```output
OrderedDict([('d1', array([b'ccc', b'dddd', b'e', b'f', b'g'], dtype=object)),
             ('d2', array([0.02, 0.03, 0.04, 0.05, 0.06], dtype=float32)),
             ('a1',
              array(['cat', 'dog', 'egg', 'frog', 'gas'], dtype=object))])
```
