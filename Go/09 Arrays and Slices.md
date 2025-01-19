# Go Arrays and Slices
#go #arrays #slices #zerovalues #make

## Arrays

Type `[n]T` is an array of `n` values of type `T`.
This syntax differs from other languages where usually it's `T[n]`.

This expression declares a variable `a` as an array of ten integers:
```go
var a [10]int
```

An array's length is part of its type so arrays cannot be resized.
This is where slices can come into play.

### Slices

An array has a fixed size,
but a slice is a dynamically-sized, flexible view into the elements of an array.

In practice, slices are much more common than arrays.

The type `[]T` is a slice with elements of type `T`.

### Slicing

A slice is formed by specifying two indices,
a low and high bound separated by a `:`.
```go
a[low : high]
```
The above selects a half-open range,
which includes the first element but excludes the last one.

For example, this creates a slice of elems `1` through `3` of array `a`:
```go
a[1:4]
```

We may omit the high or low bounds to use their defaults instead.
Basically like Python,
the default low bound is `0`,
and the default high bound is the length of the slice.

These are all equivalent for slicing array `var a [10]int`:
```go
a[0:10]
a[:10]
a[0:]
a[:]
```

### Slices are like references to arrays.

Slices are like references to arrays;
The slice doesn't store any data itself,
it just describes a section of the underlying array.

A slice is a reference type.

Changing the elems of a slice modifies the corresponding elements of its underlying array.
Other slices that share the same underlying array will see those changes as well.

Furthermore, this means we don't need to pass a pointer to a slice to a function in order to mutate its elements.

### Slice literals

Slice literals are like an array literal but without the length.

This is an array:
```go
[3]bool{true, true, false}
```

This creates the same array, then builds a slice that references it.
```go
[]bool{true, true, false}
```

### Slice length and capacity

A slice has both a length and a capacity.

The length is the number of elements that the slice contains.

The capacity is the number of elements in the underlying array,
counting from the first element in the slice.

We can use the expressions `len(s)` and `cap(s)` to obtain each for a slice `s`.
```go
s := []int{2, 3, 5, 7, 11, 13}
fmt.Printf("len=%d, cap=%d, %v\n", len(s), cap(s), s)
// len=6 cap=6 [2 3 5 7 11 13]
```

You can extend a slice's length by re-slicing it,
provided it has sufficient capacity.
```go
// Slice the slice to give it zero length.
s = s[:0]  // []
// Extend its length.
s = s[:4]  // [2 3 5 7]
// Drop its first two values.
s = s[2:]  // [5 7]
```

### Nil slices

The zero value of a slice is `nil`.
A `nil` slice has a `len` and `cap` of `0` and has no underlying array.

### Creating a slice with `make`

Slices can be created with the built-in `make` function.
This is how you create dynamically-sized arrays.

`make` allocates a zeroed array, returning a slice referring to this array:
```go
a := make([]int, 5)  // len(a)=5
```
To specify capacity, pass a third argument to `make`:
```go
b := make([]int, 0, 5) // len(b)=0, cap(5)=5

b = b[:cap(b)] // len(b)=5 cap(b)=5
b = b[1:] // len(b)=4 cap(b)=4
```

### Slices of slices

A slice can contain any type, including other slices:
```go
board := [][]string{
	[]string{"_", "_", "_"},
	[]string{"_", "_", "_"},
	[]string{"_", "_", "_"},
}
```

### Appending to a slice

It's common to append new elements to a slice.

Go provides the built-in `append` function. It has a signature like:
```go
func append(s []T, vs ...T) []T
```
`s` is a slice,
and `vs` are one or more `T` values to append to the slice.
The result is a slice containing all of the elements of the original slice
plus the provided values.

For example:
```go
var s []int  // nil slice, len=0 cap=0 []

s = append(s, 1)  // len=1 cap=1 [1]
// We can add more than one element at a time.
s = append(s, 2, 3, 4)  // len=4 cap=4 [1 2 3 4]
```

If the backing array of the slice is too small to fit the new elements,
a bigger one will be allocated and the slice will point to this new array.

