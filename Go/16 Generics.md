# Go Generics
#go #generics #types

## Type parameters

Go functions can be written to work on multiple types using type parameters.

The type parameters of a function appear between square brackets,
before the function's argument.
```go
func Index[T comparable](s []T, x T) int
```

This declaration means that `s` is a slice of any type `T`
that fulfills the built-in constraint `comparable`.
`x` is also a value of the same type.

`comparable` is a useful constraint.
It makes it possible to use the `==` and `!=` operators on values of the type.

Here, we use it to compare a value to all slice elems until a match is found.
```go
package main

import "fmt"

// Index returns the index of x in s, or -1 if not found
func Index[T comparable](s []T, x T) int {
	// v and x are type T, which has comparable
	// constraint, so we can use == here.
	for i, v := range s {
		if v == x {
			return i
		}
	}
	return -1
}

func main() {
	// Index works on slice of ints
	si := []int{10, 20, 15, -10}
	fmt.Println(Index(si, 15))

	// Index works on a slice of strings too
	ss := []string{"foo", "bar", "baz"}
	fmt.Println(Index(ss, "hello"))
}
```

## Generic types

In addition to generic functions, Go also supports generic types.

A type can be parameterized with a type parameter,
which could be useful for implementing generic data structures.

For example, here is
a simple type declaration for a singly-linked list holds an type of value.
```go
package main

import "fmt"

type List[T any] struct {
	next *List[T]
	val  T
}

func (list *List[T]) SetNext(other List[T]) {
	list.next = &other	
}

func main() {
	var list List[int] = List[int]{val: 6}
	
	list2 := List[int]{val: 10}
	list.SetNext(list2)
	
	fmt.Println(list.next.val, list.val)
}
```

