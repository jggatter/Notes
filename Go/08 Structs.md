# Go Structs
#go #structs #pointers #zerovalues

A struct is a collection of fields.
```go
type Vertex struct {
	X int
	Y int
}

func main() {
	fmt.Println(Vertex{1, 2}) // prints {1 2}
}
```

Struct fields are accessed using dot `.` notation:
```go
type Vertex struct {
	X int
	Y int
}

func main() {
	v := Vertex{1, 2}
	v.X = 4
	fmt.Println(v.X)
}
```

Struct fields can be accessed through a struct pointer
```go
func main() {
	v := Vertex{1, 2}
	p := &v
	p.X = 1e9
	fmt.Println(v)
}
```
Go allows implicit deferencing as seen above with `p.X`.
Here dereferencing using `(*p).X` would be the more explicit equivalent.

A struct literal denotes a newly allocated struct value
by listing the values of its fields.
```go
v1 = Vertex{1, 2}
```

You can list just a subset of fields by using the `Name:` syntax.
The order of fields is irrelevant.
Omitted fields implicitly are set to their zero values.
```go
v2 = Vertex{X: 1} // Y:0 is implicit
v3 = Vertex{} // X:0 and Y:0 are implicit
```

A special prefix `&` returns a pointer to the struct:
```go
p = &Vertex{1, 2} // has type *Vertex
```

