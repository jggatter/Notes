# Go Conditional Statements: If and Switch
#go #conditionals #if #switch

## If Statements

Same story as for-loops:
If statements don't need parentheses but do need curly braces:
```go
if x < 0 {
	return sqrt(-x) + "i"
}
```

Like the for-loop, we can use a short statement `:=` for assignment.
Note the init and condition are also separated by a `;`.
```go
if v := math.Pow(x, n); v < lim {
	return v
}
```
Variables declared by the statement are only in scope until the end of the `if`.
They are also available in any `else` block.

Here's an if-else:
```go
if v := math.Pow(x, n); v < lim {
	return v
} else {
	fmt.Printf("%g >= %g\n", v, lim)
}
```

## Switch statements

A switch is a shorter way of writing if-else statements.
It runs the first case whose value is equal to the condition expression.
Switches can perform better when comparing a considerable number of fixed values.

Once again, a short statement is used,
and the init and condition are separated by `;`:
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

Switch cases evaluate cases from top to bottom, stopping when a case succeeds.
It `break`s automatically. There is no cascading "waterfall"!

We can also have cases evaluated other than constants:
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

