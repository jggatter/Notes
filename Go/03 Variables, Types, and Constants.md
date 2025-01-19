# Go Variables, Types, and Constants
#go #variables #types #constants #zerovalues

## Declarations

The `var` statement declares a list of variables.
It can exist at the function or package level.

Like function arguments, the type is specified last.
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
The types are implicit based on the initializer
```go
k := 3
c, python, java := true, false, "no!"
```
Outside of a function, every statement begins with a keyword,
thus the `:=` construct is not available outside of functions.

## Types

Go's basic types are:
```go
bool

string

int // 64 bits on 64-bit systems
int8
int16
int32
int64

uint // 64 bits on 64-bit systems
uint8
uint16
uint32
uint64 
uintptr // 64 bits on 64-bit systems

byte // alias for uint8
rune // alias for int32, represents Unicode code point

float32
float64

complex64
complex128
```
Just use `int` for integers unless you have specific reason to use `uint` or a sized `int...`.


### Zero values of types

Variables declared without an explicit initial value are given their "zero value":
* `0` for numeric types
* `false` for `bool`
* `""` for `string`

```go
package main

import "fmt"

func main() {
    var i int
    var f float64
    var b bool
    var s string

    fmt.Printf("%v %v %v %q\n", i, f, b, s)
    // prints 0 0 false ""
}
```

### Type conversion

The expression `T(v)` converts the value `v` to the type `T`
```go
var i int = 42
var f float64 = float64(i)
var u uint = uint(f)
```
Or, put more simply:
```go
i := 42
f := float64(i)
u := uint(f)
```

Unlike C, an error will be raised if you attempt to assign to a value 
to a variable with another type without converting it.
```go
var z uint = f  // throws error
```

### Type inference

When declaring a variable without specifying an explicit type,
either by `:=` or `var =`,
the variable's type is inferred from the value being assigned.
```go
var i int
j := i // j is an int
```

But if the assigned value is an untyped numeric constant,
the new variable may be `int`, `float,` or `complex` based on its precision.
```go
i := 42 // int
f := 3.142 // float
g := 0.867 + 0.5i // complex128
```

## Constants

Constants are declared using the `const` keyword:
```go
const Truth = true
const Pi = 3.14
```
They cannot be declared using `:=`.

They can be character, string, boolean, or numeric values.

### Numeric constants

Numeric constants are high-precision values.
An untyped value takes the type needed by its context.
```go
package main

import "fmt"

const (
	// Create a huge number by shifting a 1 bit left 100 places.
	// In other words, the binary number that is 1 followed by 100 zeroes.
	Big = 1 << 100
	// Shift it right again 99 places, so we end up with 1<<1, or 2.
	Small = Big >> 99
)

func needInt(x int) int {
    return x * 10 + 1
}

func needFloat(x float64) float64 {
    return x * 0.1
}

func main() {
    fmt.Println(needFloat(Small)) // 0.2
    fmt.Println(needFloat(Big)) // 1.26e+29

    fmt.Println(needInt(Small)) // 21
    fmt.Println(needInt(Big)) // build error: uint constant as int overflows
}
```

