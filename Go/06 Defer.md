# Go Defer Statement
#go #defer

`defer` defers the execution of a func until the surrounding func returns.

Note a deferred call's arguments are evaluated immediately,
they're just not yet executed.
```go
func main() {
	defer fmt.Println("world")

	fmt.Println("hello")
}
```

Deferred function calls are pushed onto a stack and executed in LIFO order.
```go
func main() {
	for i := 0; i < 10; i++ {
		defer fmt.Println(i)
	}
    fmt.Println("done")
}
```
`"done"` is printed before any numbers are,
and the numbers are printed in reverse order.

