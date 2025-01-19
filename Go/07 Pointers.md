# Go Pointers
#go #pointers #zerovalues

A pointer holds the memory address of a value.

The type `*T` is a pointer to a `T` value.
Its zero value is `nil`.
```go
var p *int
```

The `&` operator generates a pointer to its operand.
```go
i := 42
p = &i // p is a pointer to the memory address of i
```

The `*` operator denotes the pointer's underlying value.
This is called "derefencing" or "indirecting".
```go
fmt.Println(*p) // read i through the pointer p
*p = 21         // set i through the pointer p
```

Unlike C, Go has no pointer arithmetic.

## Why pointers?

By default, Go passes arguments by value, not by reference. 

- It can be more efficient with large structs or arrays to pass pointers of these to a function rather than the values themselves.
- Mutability of a variable's value is only possible through passing a pointer.
- Nullability: by default the zero value of every basic type is meaningful (`0`, `0.0`, `false`, etc.). A pointer has a zero value of `nil`, so you could use it to represent a "not-set" state.
- Pointers are also good for implementing and working with data structures

Go has garbage collection, so there is reduced risk of common pointer-related pitfalls seen in other languages, such as dangling pointers.

In Go, the `.` operator for accessing struct fields has a special behavior:
it automatically dereferences pointers to structs!
This means if you have a pointer to a struct, you do not have to explicitly dereference it with `*` to access fields.
```go
list.next.val
// equivalent
(*list.next).val
// incorrect!!!
*(list.next).val
```

