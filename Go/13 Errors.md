# Go Errors
#go #errors #interfaces

Go programs express error states with `error` values.

The `error` type has a built-in interface similar to `fmt.Stringer`:
```go
type error interface {
	Error() string
}
```
(As with `fmt.Stringer`,
the `fmt` package looks for the error interface when printing values.)

Functions often return an `error` value.
Calling code should handle errors by testing whether the error is `nil`.
A nil `error` denotes success, a non-nil denotes failure.
```go
i, err := strconv.Atoi("42")
if err != nil {
	fmt.Printf("Couldn't convert number: %v\n", err)
	return
}
fmt.Println("Converted integer:", i)
```

The `Stringer` method `Error` gets invoked when an error is printed.
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

