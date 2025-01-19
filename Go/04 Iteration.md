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

TODO
