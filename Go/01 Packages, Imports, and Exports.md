# Go Packages, Imports, and Exports
#go #imports #packages #exports

## Packages

Every Go program is made up of packages.
Programs start by running in the package `main`.

By convention, package name is the same as the last element of the import path.
E.g. `math/rand` package comprises files that begin with `package rand`.

## Imports

After declaring our `package`, we can use `import` to import other packages.
Notably the package name must be a string. Example:
```go
import "fmt" // Imports the `fmt` package
```

Parentheses can group multiple imports as a "factored" import statement:
```go
package main

import (
    "fmt"
    "math"
)

func main() {
    fmt.Printf("Now you have %g problems.\n", math.Sqrt(7))
}
```

We could alternatively have individual import statements:
```go
import "fmt"
import "math"
```
But it's good style to use the factored import statement.

## Exports

Names are exported if they begin with a capital letter,
e.g. `Println` is exported from the `fmt` package.

Names that don't are private within the package and can't be imported elsewhere.
