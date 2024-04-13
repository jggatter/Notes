#go
## Packages, Imports, and Exports

Every Go program is made up of packages. Programs start by running in `package main`.

By convention, the package name is the same as the last element of the import path. E.g. `math/rand` package comprises files that begin with the statement `package rand`.

`import "fmt"` to import the `fmt` package. Parentheses can group multiple imports as a "factored" import statement:
```go
import (
    "fmt"
    "math"
)
```
It's good style to use the factored import statement

Names are exported if they begin with a capital letter, e.g. `Println` is exported from the `fmt` package. Names that do not are private within the package and cannot be imported elsewhere.
## Functions

Function can take zero or more arguments. The type is specified after the name.
```go
func add(x int, y int) int {
	return x + y
}
```
The return type is specified after the arguments. Here the return type is `int`.

When two or more consecutive function parameters share a type, you can omit the type from all but the last:
```go
func add(x, y int) int {
	return x + y
}
```
To me this is weird.

A function can return any number of results.
```go
func swap(x, y string) (string, string) {
	return y, x
}
```

Naked return statements are a thing... Here `x` and `y` are only specified in the return type info.
```go
func split(sum int) (x, y int) {
	x = sum * 4 / 9
	y = sum - x
	return
}
```
Don't do this in longer functions. Bad for readability.

## Variables

### Declarations

`var` statements declare a list of variables. Like function args, the type is specified last.
```go
var i int
var c, python, java bool
```

`var` declarations can include initializers, one per variable.
```go
var i, j int = 1, 2
```
If the initializer is present the type can be omitted.
```go
var c, python, java = true, false, "no!"
```

It's shorter to use the `:=` assignment statement instead of `var`.
```go
k := 3
c, python, java := true, false, "no!"
```
Outside of a function, every statement begins with a keyword, thus the `:=` is not available.

### Types

Go's basic types are:
```go
bool

string

int // 64 bits on 64-bit
int8
int16
int32
int64

uint // 64 bits on 64-bit
uint8
uint16
uint32
uint64 
uintptr // 64 bits on 64-bit

byte // alias for uint8
rune // alias for int32, represents Unicode code point

float32
float64

complex64
complex128
```
Just use `int` for integers unless you have specific reason to use `uint` or a sized `int...`.

Variables declared without an explicit initial value are given their "zero value":
* `0` for numeric types
* `false` for `bool`
* `""` for `string`

#### Type conversion and inference

The expression `T(v)` converts the value `v` to the type `T`
```go
var i int = 42
var f float64 = float64(i)
var u uint = uint(f)
```
Or, put more simply
```go
i := 42
f := float64(i)
u := uint(f)
```
Unlike C, an error will be raised if you attempt to assign to a value to a variable with another type without converting it.
```go
var z uint = f  // throws error
```

When declaring a variable without specifying an explicit type, the variable's type is inferred from the value being assigned.

#### Constants

Constants are declared using `const`:
```go
const Truth = true
const Pi = 3.14
```
They cannot be declared using `:=`.

They can be character, string, boolean, or numeric values.

Numeric constants are high-precision values.
```go
const (
	// Create a huge number by shifting a 1 bit left 100 places.
	// In other words, the binary number that is 1 followed by 100 zeroes.
	Big = 1 << 100
	// Shift it right again 99 places, so we end up with 1<<1, or 2.
	Small = Big >> 99
)
```
Untyped constants take on the type needed by its context.

## For

Go has only one looping construct, the `for` loop. 
```go
sum := 0
for i := 0; i < 10; i++ {
    sum += i
}
```
Notice that unlike C, Java, etc. there are no parentheses surrounding the three components. 

The braces are also always required.

The init and post statements are optional:
```go
sum := 1
for ; sum < 1000; {
	sum += sum
}
```
Which is basically the equivalent of a "while" statement. It can be written more simply as:
```go
sum := 1
for sum < 1000 {
	sum += sum
}
```
Here's an infinite loop:
```go
for {
}
```

## If

Same story: expression doesn't need parentheses but does need curly braces:
```go
if x < 0 {
	return sqrt(-x) + "i"
}
```

Like the for-loop, we can use a short statement `:=`.
```go
if v := math.Pow(x, n); v < lim {
	return v
}
```
Variables declared by the statement are only in scope until the end of the `if`. They are also available in any `else` block

Here's an if-else:
```go
if v := math.Pow(x, n); v < lim {
	return v
} else {
	fmt.Printf("%g >= %g\n", v, lim)
}
```

## Switch
```go
switch os := runtime.GOOS; os {
case "darwin":
	fmt.Println("OS X.")
case "linux":
	fmt.Println("Linux.")
default:
	// freebsd, openbsd,
	// plan9, windows...
	fmt.Printf("%s.\n", os)
}
```

Switch cases evaluate cases from top to bottom, stopping when a case succeeds. No waterfall.
```go
switch i {
case 0:
case f():
}
```
We do not call function `f` in the case that `i == 0`.

With no condition, the switch statement is the same as `switch true`
```go
switch {
case t.Hour() < 12:
	fmt.Println("Good morning!")
case t.Hour() < 17:
	fmt.Println("Good afternoon.")
default:
	fmt.Println("Good evening.")
```

## Defer

A `defer` statement defers the execution of a function until the surrounding function returns. The deferred call's arguments are evaluated immediately though. Just not yet executed.
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
}
```

## Pointers

A pointer holds the memory address of a value.

The type `*T` is a pointer to a `T` value. Its zero value is `nil`.
```go
var p *int
```
The `&` operator generates a pointer to its operand.
```go
i := 42
p = &i // p is a pointer to the memory address of i
```
The `*` operator denotes the pointer's underlying value. This is called "derefencing" or "indirecting".
```go
fmt.Println(*p) // read i through the pointer p
*p = 21         // set i through the pointer p
```
Unlike C, Go has no pointer arithmetic.

By default, Go passes arguments by value, not by reference. 
- It can be more efficient with large structs or arrays to pass pointers to a function rather than the values themselves.
- Mutability of a variable's value is only possible through passing a pointer.
- Nullability: by default the zero value of every basic type is meaningful (`0`, `0.0`, `false`, etc.). A pointer has a zero value of `nil`, so you could use it to represent a "not-set" state.
- Pointers are also good for implementing and working with data structures

Go has garbage collection, so there is reduced risk of common pointer-related pitfalls seen in other languages, such as dangling pointers.

In Go, the `.` operator for accessing struct fields has a special behavior: it automatically dereferences pointers to structs. This means if you have a pointer to a struct, you do not have to explicitly dereference it with `*` to access fields.
```go
list.next.val
// equivalent
(*list.next).val
// incorrect!!!
*(list.next).val
```
## Structs

A struct is a collection of fields:
```go
type Vertex struct {
	X int
	Y int
}

func main() {
	fmt.Println(Vertex{1, 2})
}
```

Struct fields are accessed using dot notation:
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
Here dereferencing using `(*p).X` would be the more explicit equivalent.

A struct literal denotes a newly allocated struct value by listing the values of its fields.
```go
v1 = Vertex{1, 2}
```
You can list just a subset of fields by using the `Name:` syntax. The order of fields is irrelevant.
```go
v2 = Vertex{X: 1} // Y:0 is implicit
v3 = Vertex{} // X:0 and Y:0
```
A special prefix `&` returns a pointer to the struct:
```go
p = &Vertex{1, 2} // has type *Vertex
```

## Arrays

Type `[n]T` is an array of `n` values of type `T`.
```go
var a[10]int
```
This expression declares a variable `a` as an array of ten integers.

An array's length is part of its type so arrays cannot be resized.

### Slices

An array has a fixed size, but a slice is a dynamically-sized flexible view into the elements of an array. Slices are much more common than arrays in practice.

The type `[]T` is a slice with elements of type `T`.

A slice is formed by specifying two indices, a low and high bound separated by a `:`.
```go
a[low : high]
```
The above selects a half-open range which includes the first element but excludes the last one.
```
a[1:4]  // includes elements 1 through 3
```

Slices are like references to arrays. It doesn't store any data itself, just describes a section of the underlying array.

Changing the elements of a slice modifies the corresponding elements of its underlying array. Other slices that share the same underlying array will see those changes as well

Slice literals are like an array literal but without the length. This is an array:
```go
[3]bool{true, true, false}
```
This creates the same array, then builds a slice that references it.
```go
[]bool{true, true, false}
```

When slicing, you may omit the high or low bounds to use their defaults instead. Basically Python. These are equivalent:
```go
a[0:10]
a[:10]
a[0:]
a[:]
```

A slice has both a length and a capacity. The length is the number of elements in the underlying array, counting from the first element in the slice. The capacity is the number of elements in the underlying array, counting from the first element of the slice.
```go
s := []int{2, 3, 5, 7, 11, 13}
fmt.Printf("len=%d, cap=%d, %v\n", len(s), cap(s), s)
```

You can extend a slice's length by re-slicing it, provided it has sufficient capacity.
```go
// Slice the slice to give it zero length.
s = s[:0]
// Extend its length.
s = s[:4]
// Drop its first two values.
s = s[2:]
```

The zero value of a slice is `nil`. A `nil` slice has a `len` and `cap` of zero and has no underlying array.

Slices can be created with the built-in `make` function. This is how you create dynamically-sized arrays:
```go
a := make([]int, 5)  // len(a) is 5
```
To specify capacity, pass a third argument to `make`:
```go
b := make([]int, 0, 5) // len(b)=0, cap(5)=5
```

A slice can contain any type, including other slices:
```go
board := [][]string{
	[]string{"_", "_", "_"},
	[]string{"_", "_", "_"},
	[]string{"_", "_", "_"},
}
```

It's common to append new elements to a slice. Go provides the built-in `append` function.
```go
s = append(s, 1)
// We can add more than one element at a time.
s = append(s, 2, 3, 4)
```
The resulting value is a slice containing all of the elements of the original slice plus the provided values. If the backing array of the slice is too small to fit the new elements, a bigger one will be allocated and the slice will point to this array.

## Range

The `range` form of the `for` loop iterates over a slice or map.
```go
var pow = []int{1, 2, 4, 8, 16, 32, 64, 128}

for i, v := range pow {
	fmt.Printf("2**%d = %d\n", i, v)
}
```
When ranging over a slice, two values are returned per iteration. The first is the index, the second is a copy of the element at that index.

You can skip the index or value by assigning to `_`.
```go
for i, _ := range pow
for _, value := range pow
```
If you only want the index, you can omit the second variable:
```go
for i := range pow
```

### Maps

A map maps keys to values:
```go
type Vertex struct {
	Lat, Long float64
}

var m map[string]Vertex

func main() {
	m = make(map[string]Vertex)
	m["Bell Labs"] = Vertex{
		40.68433, -74.39967,
	}
	fmt.Println(m["Bell Labs"])
}
```
The zero value of a map is `nil`,  a `nil` map has no keys, nor can keys be added.

The `make` function returns a map of the given type, initialized and ready for use.

Map literals are like struct literal, but the keys are required!
```go
var m = map[string]Vertex{
	"Bell Labs": Vertex{
		40.68433, -74.39967,
	},
	"Google": Vertex{
		37.42202, -122.08408,
	},
}
```
If the top-level type is just a type name, you can omit it from the elements of the literal.
```go
var m = map[string]Vertex{
	"Bell Labs": {40.68433, -74.39967},
	"Google":    {37.42202, -122.08408},
}
```

You can insert or update elements in a map,
```go
m[key] = elem
```
Retrieve an element,
```go
elem := m[key]
```
Delete an element,
```go
delete(m, key)
```
Check that a key is present with a two-value assignment,
```go
elem, ok := m[key]
// ok is true if key is in m
// elem is 0 if key is not in m
```

## More about Functions

Functions are values as well. They can be passed around just like other values.
```go
func compute(fn func(float64, float64) float64) float64 {
	return fn(3, 4)
}

func main() {
	hypot := func(x, y float64) float64 {
		return math.Sqrt(x*x + y*y)
	}
	fmt.Println(hypot(5, 12))

	fmt.Println(compute(hypot))
	fmt.Println(compute(math.Pow))
}
```

Functions may be closures. A closure is a function value that references from outside of its body. The function may access and assign to the referenced variables.
```go
// For example, the `adder` function returns a closure. 
// Each closure is bound to its own `sum` variable.

func adder() func(int) int {
	sum := 0
	return func(x int) int {
		sum += x
		return sum
	}
}

func main() {
	pos, neg := adder(), adder()
	for i := 0; i < 10; i++ {
		fmt.Println(
			pos(i),
			neg(-2*i),
		)
	}
}
```

## Methods

Go doesn't have classes, but methods can be defined on types.

A method is a function with a special receiver argument:
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

Method is just a function. This function behaves equivalently, it's just called differently:
```go
// No receiver argument, instead regular argument
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

### Pointer receivers

You can declare methods with pointer receivers. This means the receiver type has the literal syntax `*T` for some type `T` (`T` itself cannot be a pointer!).
```go
func (v Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

// v is a receiver
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
This allows the method to mutate the struct values. Regular, non-pointer receivers only act on a copy since Go is pass-by-value. Although you can do the equivalent by passing a pointer to regular functions that accept pointer arguments:
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


#### Methods with pointer indirection

Methods with pointer receivers either take a value or pointer. As a convenience, Go flexibly interprets the below statement as `(&v).Scale(5)` even though `v` is a value, not a pointer.
```go
var v Vertex
v.Scale(5)  // value is OK
p := &v
p.Scale(10) // pointer is OK

// Compared to regular function with pointer argument
var v Vertex
ScaleFunc(v, 5)  // value causes Compile error!
ScaleFunc(&v, 5) // pointer is OK
```

The equivalent thing can happen in the reverse direction! While functions that take a value argument must take a value of that specific type, method receivers with _values_ can be called by either a value or pointer.
```go
var v Vertex
v.Abs() // OK
p := &v
p.Abs() // OK

// Compared to regular function with value argument
var v Vertex
AbsFunc(v)  // value ok
AbsFunc(&v) // pointer causes Compile error!!!
```

#### Why?

There's two reasons why you might want to use method receivers.
1. So the method can modify the value that its receiver points to
2. To avoid copying the value on each method call (especially if the value is large)

In general, all methods on a given type should have either value or pointer receiver, but not a mixture of both.

### Interfaces

Interface is a set of message signatures. A value of interface type can hold any value that implements those methods
```go
type Abser interface {
	Abs() float64
}
```

Value type implementing `Abser` interface methods can be assigned to variable of type `Abser`
```go
type MyFloat float64

func (f MyFloat) Abs() float64 {
	if f < 0 {
		return float64(-f)
	}
	return float64(f)
}

func main() {
	var a Abser
	f := MyFloat(-math.Sqrt2)
	

	a = f // a MyFloat implements Abser
	fmt.Println(a.Abs())
}
```

Pointer type implementing `Abser` interface methods can be assigned to variable of type `Abser`. The underlying type does not implement the method and thus cannot be assigned.
```go
type Vertex struct {
	X, Y float64
}

func (v *Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

func main() {
	var a Abser
	v := Vertex{3, 4}

	a = &v // a *Vertex implements Abser

	// ERROR
	// In the following line, v is a Vertex (not *Vertex)
	// and does NOT implement Abser.
	a = v
	fmt.Println(a.Abs())
}
```

Interfaces are implemented implicitly. A type implements an interface by implementing its methods. There's no explicit declaration of intent, i.e., no "implements" keyword.

Implicit interfaces decouple the definition of an interface from its implementation, which could then appear in any package without prearrangement
```go
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

Under the hood, interface values can be thought as a tuple of a value and a concrete type:
`(value, type)`

An interface value holds a value of a specific underlying concrete type.
Calling a method on an interface value executes the method of the same name on its underlying type.
```go
type I interface {
	M()
}


type T struct {
	S string
}

func (t *T) M() {
	fmt.Println(t.S)
}


type F float64

func (f F) M() {
	fmt.Println(f)
}

// The respective M functions get called for each type despite i being of type I
func main() {
	var i I

	i = &T{"Hello"}
	describe(i)
	i.M()

	i = F(math.Pi)
	describe(i)
	i.M()
}
```

If the concrete value inside the interface itself is `nil`, the method will be called with a nil receiver.
```go
func (t *T) M() {
	if t == nil {
		fmt.Println("<nil>")
		return
	}
	fmt.Println(t.S)
}

func describe(i I) {
	fmt.Printf("(%v, %T)\n", i, i)
}

func main() {
	var i I

	var t *T
	i = t
	describe(i)  // (<nil>, *main.T)
	i.M()  // <nil>

	i = &T{"hello"}
	describe(i)  // (&{hello}, *main.T)
	i.M()  // hello
}
```
In some languages, this would call a null pointer exception. In Go, it is common to write methods that gracefully handle being called with a nil receiver. 

Note that the interface value (`i`) that holds a nil concrete value is itself non-nil.

A nil interface value holds neither value nor concrete type. Calling a method on a nil interface is a run-time error because there is no type inside the interface tuple to indicate which _concrete_ method to call
```go
func main() {
	var i I
	describe(i)
	i.M()  // runtime error: invalid memory address or nil pointer dereference
}
```

The interface type that specifies zero methods is known as the _empty_ interface.
`interface{}`

An empty interface may hold values of any type (Every type implements at least 0 methods). Empty interfaces are used by code that handles values of unknown type, e.g. `fmt.Println` accepts any number of args of type `interface{}`.
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

### Type assertions

A type assertion provides access to an interface value's underlying concrete value.
```go
t := i.(T)
```
This statement asserts that the interface value, `i`, holds the concrete type `T` and assigns the underlying `T` value to variable `t`.  If `i` does not hold `T`, the statement will trigger a panic.

To test whether an interface value holds a specific type, a type assertion can return two values: the underlying value and a boolean value that reports whether the assertion succeeded:
`t, ok := i.(T)`

If `i` holds `T`, then `t` is the underyling value and `ok` is true. Otherwise `t` is the zero value of type `T`, `ok` is `false`, and no panic occurs.
```go
func main() {
	var i interface{} = "hello"

	s := i.(string)
	fmt.Println(s)

	s, ok := i.(string)
	fmt.Println(s, ok)

	f, ok := i.(float64)
	fmt.Println(f, ok)

	f = i.(float64) // panic
	fmt.Println(f)
}
```

### Type switches

A type switch is a construct that permits several type assertions in series.
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
Here the declaration in a type switch has the same syntax as a type assertion `i.(T)`, but the specific type `T` is replaced with the keyword `type`.

### Stringers

One of the most ubiquitous interfaces is `Stringer`. This is defined by the `fmt` package.
```go
type Stringer interface {
	String() string
}
```
A `Stringer` is a type that can describe itself as a string. The `fmt` package (and many others) look for this interface to print values.
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

### Errors

Go programs express error states with `error` values. The `error` type has a built-in interface similar to `fmt.Stringer`:
```go
type error interface {
	Error() string
}
```

As with `fmt.Stringer`, the `fmt` package looks for the error interface when printing values.

Functions often return an `error` value. and calling code should handle errors by testing whether the error equals `nil`.
```go
i, err := strconv.Atoi("42")
if err != nil {
	fmt.Printf("Couldn't convert number: %v\n", err)
	return
}
fmt.Println("Converted integer:", i)
```
A nil `error` denotes success, a non-nil denotes failure. The `Stringer` method `Error` gets invoked when an error is printed.
```go
import (
	"fmt"
	"time"
)

type MyError struct {
	When time.Time
	What string
}

func (e *MyError) Error() string {
	return fmt.Sprintf("at %v, %s",
		e.When, e.What)
}

func run() error {
	return &MyError{
		time.Now(),
		"it didn't work",
	}
}

func main() {
	if err := run(); err != nil {
		fmt.Println(err)
	}
}
```
Another example:
```go
type ErrNegativeSqrt float64

func (e ErrNegativeSqrt) Error() string {
	return fmt.Sprintf("cannot Sqrt negative number: %f", float64(e))
}

func Sqrt(x float64) (result float64, err error) {
	if x < 0 {
		result = 0
		err = ErrNegativeSqrt(x)
	} else {
		result = x * x
	}
	return result, err
}

func main() {
	fmt.Println(Sqrt(2))
	fmt.Println(Sqrt(-2))
}
```

### Readers

The `io` package specifies the `io.Reader` interface, which represents the read end of a stream of data. The Go standard library contains maybe implementations of this interface, including files, network connections, compressors, ciphers, and others.

The `io.Reader` interface has a `Read` method:
`func (T) Read(b []byte) (n int, err error)`

`Read` populates the given byte slice with data and returns the number of bytes populated and an error value, It returns an `io.EOF` error when the stream ends.

The example code creates a [`strings.Reader`](https://go.dev/pkg/strings/#Reader) and consumes its output 8 bytes at a time.
```go
import (
	"fmt"
	"io"
	"strings"
)

func main() {
	r := strings.NewReader("Hello, Reader!")

	b := make([]byte, 8)
	for {
		n, err := r.Read(b)
		fmt.Printf(
			"n = %v, err = %v, b = %v\n"
			n, err, b,
		)
		fmt.Printf("b[:n] = %q\n", b[:n])
		if err == io.EOF {
			break
		}
	}
}
```

## Images

Package `image` defines an `Image` interface:
```go
package image

type Image interface {
    ColorModel() color.Model
    Bounds() Rectangle
    At(x, y int) color.Color
}

```

```go
package main

import (
	"fmt"
	"image"
)

func main() {
	m := image.NewRGBA(image.Rect(0, 0, 100, 100))
	fmt.Println(m.Bounds())  // (0,0)-(100,100)
	fmt.Println(m.At(0, 0).RGBA())  // 0 0 0 0
}
```

### Type parameters

Go functions can be written to work on multiple types using type parameters. The type parameters of a function appear between brackets, before the function's argument.
```go
func Index[T comparable](s []T, x T) int
```

This declaration means that `s` is a slice of any type `T` that fulfills the built-in constraint `comparable`. `x` is also a value of the same type.

`comparable` is a useful constraint that makes it possible to use the `==` and `!=` operators on values of the type.
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


### Generic types

In addition to generic functions, Go also supports generic types. A type can be parameterized with a type parameter, which could be useful for implementing generic data structures.
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

## Goroutines

A goroutine is a lightweight thread managed by the Go runtime:
```go
go f(x, y, z)
```
starts a new goroutine running:
```go
f(x, y, z)
```
The _evaluation_ of `f`, `x`, `y`, and `z` happens in the current goroutine and the actual _execution_ of `f` happens in the new goroutine.

Goroutines run in the same address space, so access to shared memory must be synchronized. The `sync` package provides useful primitives, although you won't need them much in Go as there are other primitives.

#### Channels

Channels are a typed conduit through which you can send an receive values with the channel operator, `<-`.
```go
ch <- v    // Send v to channel ch
v := <-ch  // Receive from ch, and assign value to v
```
The data flows in the direction of the arrow.

Like maps and slices, channels must be created before use:
`ch := make(chan int)`

By default, send and receive actions block until the other side is ready. This allows goroutines to sync without explicit locks or condition variables.
```go
func sum(s []int, c chan int) {
	sum := 0
	for _, v := range s {
		sum += v
	}
	c <- sum // send sum to c
}

func main() {
	s := []int{7, 2, 8, -9, 4, 0}

	c := make(chan int)
	go sum(s[:len(s)/2], c)
	go sum(s[len(s)/2:], c)
	x, y := <-c, <-c // receive from c

	fmt.Println(x, y, x+y)
}
```


##### Buffered channels
Channels can be _buffered_. Provide the buffer length as the second argument to `make` to initialize a buffered channel.
```go
ch := make(chan int, 100)
```
Sends to a buffered channel block only when the buffer is full. Receives block when the buffer is empty.
```go
func main() {
	ch := make(chan int, 2)
	ch <- 1
	ch <- 2
	ch <- 3  // fatal error: all goroutines are asleep - deadlock!
	fmt.Println(<-ch)
	fmt.Println(<-ch)
}
```

##### Range and Close

A sender can `close` a channel to indicate that no more values will be sent. Receivers can test whether a channel has been closed by assigning a second parameter to the receive expression:

After this send,
```go
v, ok := <-ch
```
`ok` is `false` if there are no more values to receive and the channel is closed.

The look `for i := range c` receives values from the channel repeatedly until it is closed:
```go
func fibonacci(n int, c chan int) {
	x, y := 0, 1
	for i := 0; i < n; i++ {
		c <- x
		x, y = y, x+y
	}
	close(c)
}

func main() {
	c := make(chan int, 10)
	go fibonacci(cap(c), c)
	for i := range c {
		fmt.Println(i)
	}
}
```
**Note:** Only the sender should close a channel, never the receiver. Sending on a closed channel will cause a panic.

**Another note:** Channels aren't like files; you don't usually need to close them. Closing is only necessary when the receiver must be told there are no more values coming, such as to terminate a `range` loop.

#### Select

The `select` statement lets a goroutine wait on multiple communication operations. A `select` blocks until one of its cases can run, then it executes that case. It chooses one at random if multiple are ready.
```go
func fibonacci(c, quit chan int) {
	x, y := 0, 1
	for {
		select {
		case c <- x:
			x, y = y, x+y
		case <-quit:
			fmt.Println("quit")
			return
		}
	}
}

func main() {
	c := make(chan int)
	quit := make(chan int)
	go func() {
		for i := 0; i < 10; i++
			fmt.Println(<-c)
		}
		quit <- 0
	}()
	fibonacci(c, quit)
}
```

The `default` case in a `select` is run if no other case is ready.
```go
select {
case i := <-c:
	// use i
default:
	// receiving from c would block this!
}
```

```go
func main() {
	tick := time.Tick(100 * time.Millisecond)
	boom := time.After(500 * time.Millisecond)
	for {
		select {
		case <-tick:
			fmt.Println("tick.")
		case <-boom:
			fmt.Println("BOOM!")
			return
		default:
			fmt.Println("    .")
			time.Sleep(50 * time.Millisecond)
		}
	}
}
```
Output:
```text
    .
    .
    .
tick.
    .
tick.
    .
    .
    .
tick.
    .
tick.
    .
    .
    .
BOOM!
```

### `sync.Mutex`

Channels are great for communication among goroutines.

But what if we don't need communication? What if we just want to make sure only one goroutine can access a variable at a time to avoid conflicts?

The concept of _mutual exclusion_ and the conventional name for the data structure that provides it is a **mutex**. Go's standard library provides mutual exclusion with `sync.Mutex` and its two methods:
- `Lock`
- `Unlock`

We can define a block of code to be executed in mutual exclusion by surrounding it with a call to `Lock` and `Unlock` and shown on the `Inc` method:
```go
// SafeCounter is safe to use concurrently.
type SafeCounter struct {
	mu sync.Mutex
	v map[string]int
}

// Inc increments the counter for the given key.
func (c *SafeCounter) Inc(key string) {
	c.mu.Lock()
	// Lock so only one goroutine at a time can access the map c.v.
	c.v[key]++
	c.mu.Unlock()
}

// Value returns the current value of the counter for the given key.
func (c *SafeCounter) Value(key string) int {
	c.mu.Lock()
	// Lock so only one goroutine at a time can access the map c.v.
	defer c.mu.Unlock()
	return c.v[key]
}

func main() {
	c := SafeCounter{v: make(map[string]int)}
	for i := 0; i < 1000; i++ {
		go c.Inc("somekey")
	}

	time.Sleep(time.Second)
	fmt.Println(c.Value("somekey"))
}
```

## Where to Go from here...

You can get started by [installing Go](https://go.dev/doc/install/).

Once you have Go installed, the [Go Documentation](https://go.dev/doc/) is a great place to continue. It contains references, tutorials, videos, and more.

To learn how to organize and work with Go code, read [How to Write Go Code](https://go.dev/doc/code).

If you need help with the standard library, see the [package reference](https://go.dev/pkg/). For help with the language itself, you might be surprised to find the [Language Spec](https://go.dev/ref/spec) is quite readable.

To further explore Go's concurrency model, watch [Go Concurrency Patterns](https://www.youtube.com/watch?v=f6kdp27TYZs) ([slides](https://go.dev/talks/2012/concurrency.slide)) and [Advanced Go Concurrency Patterns](https://www.youtube.com/watch?v=QDDwwePbDtw) ([slides](https://go.dev/talks/2013/advconc.slide)) and read the [Share Memory by Communicating](https://go.dev/doc/codewalk/sharemem/) codewalk.

To get started writing web applications, watch [A simple programming environment](https://vimeo.com/53221558) ([slides](https://go.dev/talks/2012/simple.slide)) and read the [Writing Web Applications](https://go.dev/doc/articles/wiki/) tutorial.

The [First Class Functions in Go](https://go.dev/doc/codewalk/functions/) codewalk gives an interesting perspective on Go's function types.

The [Go Blog](https://go.dev/blog/) has a large archive of informative Go articles.

Visit [the Go home page](https://go.dev/) for more.
