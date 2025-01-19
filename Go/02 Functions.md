# Go Functions
#go #functions #closures

## Function type definitions

Function can take zero or more arguments,
enclosed in parentheses after the function name.
They're delimited by commas.

The argument's type is specified after its name,
and the return type is specified after the arguments.
```go
func add(x int, y int) int {
	return x + y
}
```
Here the type of the arguments and the return type are all `int`.

When two or more consecutive function parameters share a type,
such as in the example above,
you can omit the type from all parameters but the last:
```go
func add(x, y int) int {
	return x + y
}
```

## Multiple return values

A function can return any number of results.
```go
func swap(x, y string) (string, string) {
	return y, x
}
```

## Named return values / "Naked" returns

Return values may be named.
If so, they are treated as variables defined at the beginning of the function.
The names should be used to document the meaning of the return values.

A `return` without arguments returns the named return values.
This is known as a "naked" return.

Here `x` and `y` are only specified in the return type info.
```go
func split(sum int) (x, y int) {
	x = sum * 4 / 9
	y = sum - x
	return
}
```
Don't do this in longer functions. It can hurt readability.

## Functions as values

Functions are values as well. They can be passed around just like other values.

For example, we pass various functions to `compute` for execution:
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

## Function as closures

Functions may be closures.
A closure is a function value that references from outside of its body.

The function may access and assign to the referenced variables.
In this sense the function is "bound" to the variables.

In the example below, the `adder` function returns a closure. 
Each closure is bound to its own `sum` variable.
```go
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
			neg(-2 * i),
		)
	}
}
```

