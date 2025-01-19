# Go Interfaces
#go #interfaces #types

## Interface types

An _interface type_ is a set of method signatures.

A value of interface type can hold any value that implements those methods

The value of a type implementing the interface methods 
can be assigned to variable of the interface type:
```go
// Interface specifies required methods and their signatures
type Abser interface {
	Abs() float64
}

// Type that implements this interface
type MyFloat float64

func (f MyFloat) Abs() float64 {
	if f < 0 {
		return float64(-f)
	}
	return float64(f)
}

type Vertex struct {
    X, Y float64
}

// A pointer to the type above implements this interface
func (v *Vertex) Abs() float64 {
    return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

func main() {
	var a Abser

	f := MyFloat(-math.Sqrt2)
    v := Vertex{3, 4}

	a = f    // a MyFloat implements Abser
    a = &v   // a *Vertex implements Abser
    //a = v  // a Vertex does NOT implement Abser

	fmt.Println(a.Abs())
}
```
Note that the pointer type implementing `Abser` interface methods, `*Vertex`,
can be assigned to variable of type `Abser`,
but the underlying type, `Vertex`, doesn't and thus cannot be assigned.

## Interfaces are implemented implicitly

Interfaces are implemented implicitly.
A type implements an interface simply by implementing its methods.
There's no explicit declaration of intent, i.e., no `implements` keyword.

Implicit interfaces decouple the def of an interface from its implementation,
which could then appear in any package without prearrangement.
```go
package main

import "fmt"

type I interface {
	M()
}

type T struct {
	S string
}

// This method means type T implements the interface I,
// but we don't need to explicitly declare that it does so.
func (t T) M() {
	fmt.Println(t.S)
}

func main() {
	var i I = T{"hello"}
	i.M()
}
```

## Interface values

Under the hood,
interface values can be thought as a tuple of a value and a concrete type:
```
(value, type)
```
An interface value holds a value of an underlying concrete type.
In this case the interface is a reference type.

Calling a method on an interface value
executes the method of the same name on its underlying type.
```go
type I interface {
	M()
}

// A type that implements I
type T struct {
	S string
}

func (t *T) M() {
	fmt.Println(t.S)
}


// Another type that implements I
type F float64

func (f F) M() {
	fmt.Println(f)
}

// The respective M functions get called for each type
// despite i being of type I
func main() {
	var i I

	i = &T{"Hello"}
	i.M()  // Calls *T's method M

	i = F(math.Pi)
	i.M()  // Calls F's method M
}
```

### Interface values with nil underlying values

If the concrete value inside an interface is `nil`,
the interface itself is not nil and has a concrete type,
so the method of the type will be called with a receiver of `nil`.

In some languages, this would call a null pointer exception.
In Go, it's common to write methods that gracefully handle being called with a nil receiver. 

Note that the interface value (`i`) that holds a nil concrete value is itself non-nil:
```go
type I interface {
    M()
}

type T struct {
    S string
}

func (t *T) M() {
    // If called with a nil receiver
	if t == nil {
		fmt.Println("<nil>")
		return
	}
    // Else
	fmt.Println(t.S)
}

func describe(i I) {
    // print value, type
	fmt.Printf("(%v, %T)\n", i, i)
}

func main() {
	var i I

	var t *T
	i = t
	describe(i)  // (<nil>, *main.T)
    // Call M with a nil receiver
	i.M()  // <nil>

	i = &T{"hello"}
	describe(i)  // (&{hello}, *main.T)
    // M is called with a non-nil receiver
	i.M()  // hello
}
```

## Nil interface values

A nil interface value holds neither value nor concrete type.

Calling a method on a nil interface is a run-time error
because there is no type inside the interface tuple 
to indicate which _concrete_ method to call
```go
func main() {
	var i I  // nil interface! No type with concrete methods is ever assigned!
	describe(i)  // (<nil>, <nil>)
	i.M()  // runtime error: invalid memory address or nil pointer dereference
}
```

## Empty interface

The interface type that specifies zero methods is known as the _empty_ interface.
```go
interface{}
```

An empty interface may hold values of any type
(Every type implements at least 0 methods).

Empty interfaces are used by code that handles values of unknown type,
e.g. `fmt.Print` accepts any number of args of type `interface{}`.
```go
func main() {
	var i interface{}
	describe(i)  // (<nil>, <nil>)

	i = 42
	describe(i)  // (42, int)

	i = "hello"
	describe(i)  // (hello, string)
}
```

## Type assertions

Provides access to an interface value's underlying concrete value:
```go
t := i.(T)
```
This asserts that the interface value, `i`, holds the concrete type, `T`,
and assigns the underlying `T` value to variable `t`.
If `i` does not hold `T`, the statement will trigger a panic.

To test whether an interface value holds a specific type,
a type assertion can return two values:
- the underlying value 
- and a boolean value that reports whether the assertion succeeded:
```go
t, ok := i.(T)
```

If `i` holds `T`, then `t` is the underyling value and `ok` is `true`.
Otherwise `t` is the zero val of type `T`, `ok` is `false`, and no panic occurs.
```go
func main() {
	var i interface{} = "hello"

	s := i.(string)
	fmt.Println(s)  // hello

	s, ok := i.(string)
	fmt.Println(s, ok)  // hello true

	f, ok := i.(float64)
	fmt.Println(f, ok)  // 0 false

	f = i.(float64)  // panic
	fmt.Println(f)
}
```

## Type switches

A type switch is a construct that permits several type assertions in series.
It's like a regular `switch`, but the cases specify types and not values.
Those vals are compared against the type of val held by the given interface val.
```go
switch v := i.(type) {
case T:
    // here v has type T
case S:
    // here v has type S
default:
    // no match; here v has the same type as i
}
```
The declaration in a type switch has the same syntax as a type assertion,
`i.(T)`,
but the specific type `T` is replaced with the keyword `type`.

## Stringers

One of the most ubiquitous interfaces is `Stringer`,
defined by the `fmt` package.
```go
type Stringer interface {
	String() string
}
```

A `Stringer` is a type that can describe itself as a string.
The `fmt` package (and many others) look for this interface to print values.
```go
type Person struct {
	Name string
	Age  int
}

func (p Person) String() string {
	return fmt.Sprintf("%v (%v years)", p.Name, p.Age)
}

func main() {
	a := Person{"Arthur Dent", 42}
	z := Person{"Zaphod Beeblebrox", 9001}
	fmt.Println(a, z)
	// Arthur Dent (42 years) Zaphod Beeblebrox (9001 years)
}
```

