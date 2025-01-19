# Go Methods
#go #methods #functions #pointers

Go doesn't have classes, but methods can be defined on types.

A method is a function with a special _receiver_ argument.
The receiver indicates the type that can directly call the method.
The receiver appears between the `func` keyword and the method name
in its own argument list.

```go
type Vertex struct {
	X, Y float64
}

// Receiver argument (v Vertex) appears before function name
func (v Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

func main() {
	v := Vertex{3, 4}
	fmt.Println(v.Abs())
}
```

Remember, a method is just a function. 
This function behaves equivalently, it's just called differently:
```go
// No receiver argument, instead regular argument
// Note: Remember names with capital letters are exported
func Abs(v Vertex) float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

func main() {
	v := Vertex{3, 4}
	fmt.Println(Abs(v))  // Called differently
}
```

Methods can be declared on non-struct types too:
```go
type MyFloat float64

func (f MyFloat) Abs() float64 {
	if f < 0 {
		return float64(-f)
	}
	return float64(f)
}

func main() {
	f := MyFloat(-math.Sqrt2)
	fmt.Println(f.Abs())
}
```

You can only declare a method with a receiver whose type is defined within the same package as the method.

## Pointer receivers

You can declare methods with pointer receivers.
The receiver type has the literal syntax `*T` for type `T`.
_Note: `T` itself cannot be a pointer!_
```go
// value receiver
func (v Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

// pointer receiver
func (v *Vertex) Scale(f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}

func main() {
	v := Vertex{3, 4}
	// call v's Scale method
	v.Scale(10)
	fmt.Println(v.Abs())
}
```
This allows the method to mutate the struct values.
Regular, non-pointer "value" receivers only act on a copy,
since Go is pass-by-value.

Pointer receivers tend to be common than value receivers.

Although, you can perform the equivalent mutations
by passing a pointer to regular functions that accept pointer arguments:
```go
func Abs(v Vertex) float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

// Not a receiver, just a function that accepts v pointer
func Scale(v *Vertex, f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}

func main() {
	v := Vertex{3, 4}
	// Call Scale function with v reference
	Scale(&v, 10)
	fmt.Println(Abs(v))
}
```

## Methods and pointer indirection

Methods with pointer receivers either take a value or pointer.

Conveniently, Go flexibly interprets the below statement
as `(&v).Scale(5)` even though `v` is a value, not a pointer.
```go
var v Vertex
v.Scale(5)  // value is OK
p := &v
p.Scale(10) // pointer is OK
``````
Compared to regular function with pointer argument:
```go
var v Vertex
ScaleFunc(v, 5)  // value causes Compile error!
ScaleFunc(&v, 5) // pointer is OK
```

The equivalent thing can happen in the reverse direction!

Consider this function and the equivalent method with a value receiver:
```go
func (v Vertex) Abs() float64 {
    return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

func AbsFunc(v Vertex) float64 {
    return math.Sqrt(v.X*v.X + v.Y*v.Y)
}
```

While funcs that take a value argument must take a value of that specific type,
```go
var v Vertex
AbsFunc(v)  // value ok
AbsFunc(&v) // pointer causes Compile error!!!
```
methods with value receivers can be called by either a value or pointer.
```go
var v Vertex
v.Abs() // OK
p := &v
p.Abs() // OK
```

## Choosing a value or pointer receiver

There are two reasons why you might want to use method receivers.
1. So the method can modify the value that its receiver points to
2. To avoid copying the value on each method call (esp. if the value is large)

In general, all methods on a given type should have either value or pointer receiver, but not a mixture of both.

