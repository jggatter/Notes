# Go Iteration
#go #iteration #loops #for #range #slices #maps

## For-loops

Go has only one looping construct, the `for` loop. 
```go
sum := 0
for i := 0; i < 10; i++ {
    sum += i
}
```

The three components are:
- The init statement: executed before first iteration
- condition expression: evaluated before every iteration
- post statement: executed at the end of every iteration

There are no parentheses surrounding the three components,
unlike in C, Java, etc. 

The curly braces are also always required.

The init and post statements are optional.
We can omit them to write the equivalent of a "while" statement:
```go
sum := 1
for ; sum < 1000; {
	sum += sum
}
```
This can be written more simply as:
```go
sum := 1
for sum < 1000 {
	sum += sum
}
```

Dropping the condition expression, we get an infinite loop:
```go
for {
}
```

## Range

The `range` form of the `for` loop iterates over a slice or map.

When ranging over a slice, two values are returned per iteration:
1. the index,
2. a copy of the element at that index
(like `enumerate` in Python).

For example,
```go
var pow = []int{1, 2, 4, 8, 16, 32, 64, 128}

for i, v := range pow {
	fmt.Printf("2**%d = %d\n", i, v)
}
```

You can skip the index or value by assigning to `_`.
```go
for i, _ := range pow {
}

for _, value := range pow {
}
```

If you only want the index, you can omit the second variable:
```go
for i := range pow {
}
```

## Iterators

Iterators are constructs that allow traversing over a sequence of elements.

They are commonly used in many programming languages
as a way to provide clean and efficient handling of collections of data.

As of Go 1.23, the `iter` package provides basic ops related to seq iteration.

An iterator is a function that goes through elems of seq one by one,
sending them to a callback function, usually called `yield`.
The func stops when it reaches the end of the sequence
or when `yield` signals to stop early by returning `false`.

`iter` provides `Seq` and `Seq2`,
which are shortcuts for iterators that pass either one or two values
from each sequence element to `yield`.
```go
type (
    Seq[V any]     func(yield func(V) bool)
    Seq2[K, V any] func(yield func(K, V) bool)
)
```
`Seq2` represents a seq of paired values,
typically used for key-value or index-value pairs.

A `yield` func returns `true` if the iterator should continue to the next elem.
It returns `false` if it should stop.

Iterator functions are usually used within a `range` loop, such as
```go
func PrintAll[V any](seq iter.Seq[V]) {
    for v := range seq {
        fmt.Println(v)
    }
}
```

Verbosely, without `Seq2`, here's an example of a reverse iterator:
```go
package main

import "fmt"

func Backwards(s []string) func(func(int, string) bool) {
    return func(yield func(int, string) bool) {
        for i := len(s) - 1; i >= 0; i-- {
            if !yield(i, s[i]) {
                return 
            }
        }
    }
}

func main() {
    s := []string{"hello", "world"}
    for i, x := range Backwards(s) {
        fmt.Println(i, x)
    }
}
```
The iterator `Backwards` is invoked, returning a closure.
`range` invokes this closure, passing an auto-generated `yield` func to it.
The compiler generates this yield function based on the for-loop.

`yield` takes the current values of the iteration, `i`, `xs[i]`,
and performs the loop body, `fmt.Println(i, x)`.
If the body executed successfully, it returns `true` to continue iteration.
If `break` is encountered in the loop, `yield` returns `false`,
which signals the closure to return early.

Essentially:
```go
for i, x := range Backwards(s) {
    fmt.Println(i, x)
}
```
gets translated by the compiler to something like:
```go
Backwards(s)(func(i int, x string) bool {
    fmt.Println(i, x)
    return true // if `break`, then it would be translated  as `false`.
})
```

