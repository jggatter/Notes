#go

## Install
[Guide](https://go.dev/doc/install)

Download the latest tar for appropriate OS and architecture. For me on Fedora, this was linux-amd64.

On Fedora I ran:
```zsh
 # Delete preexisting Go installations and extract to create /usr/local/go
 sudo rm -rf /usr/local/go \
 && sudo tar \
	 -C /usr/local \
	 -xzf ~/Downloads/go1.19.4.linux-amd64.tar.gz
```

I added `export PATH=$PATH:/usr/local/go/bin` to my `.profile` and sourced it.

Verify by executing `go version`

`go env` should show details about your go environment which should be installed in `/usr/local/go`. I think the `GOROOT` should point here but `GOHOME` will point to `$HOME/go` which doesn't exist for me

`go help` displays a list of commands

## Hello World
[Guide](https://go.dev/doc/tutorial/getting-started)

Go to the Projects directory and make a project directory: 
```bash
cd Projects
mkdir hello
cd hello
```

Enable dependency tracking for your code via the `go.mod` file. Imported modules that provide packages are managed by this file which stays with your code in your source code repository. Use `go mod init <module name>` where the module name will be the module's path:
`go mod init example/hello`

Create a `hello.go` file. This file contains external code from a module `rsc.io/quote` found on `pkg.go.dev`:

```go
package main

import "fmt"
import "rsc.io/quote"

func main() {
    fmt.Println(quote.Go())
}
```

Add the `quote` module requirement and a `go.sum` file for use in authenticating the module:
`go mod tidy`

Run this file:
`go run .`

## Create a Module

### Initialize module and declare package
[Guide](https://go.dev/doc/tutorial/create-module)

Create a directory for your Go module source code
`mkdir -p ~/Projects/greetings && cd ~/Projects/greetings`

Initialize the module, giving it a module path:
`go mod init example.com/greetings`
If you publish a module this must be a path from which your module can be downloaded by Go tools. That would be your hosted code repository.

Create `greetings.go`
```go
package greetings

import "fmt"

// Hello returns a greeting for the named person.
func Hello(name string) string {
    // Return a greeting that embeds the name in a message.
    message := fmt.Sprintf("Hi, %v. Welcome!", name)
    return message
}
```
Here we declare a `greetings` package to collect related functions.

Note: `Hello` begins with a capital letter. In Go, a name is exported if it begins with a capital letter. For example, `Pizza` is an exported name, as is `Pi`, which is exported from the `math` package.

Note: The return type comes _after_ the variable name.
### Call module code
[Guide part 2](https://go.dev/doc/tutorial/call-module-code)

Back in `~/hello/hello.go`, let's change it to:
```go
package main

import (
    "fmt"
    "rsc.io/quote"
    "example.com/greetings"
)

func main() {
    // Get a greeting message and print it.
    message := greetings.Hello("Gladys")
    fmt.Println(message)
    fmt.Println(quote.Go())
}
```

Edit the hello module to use the greetings module:
`go mod edit -replace example.com/greetings=../greetings`
If the greetings module was in a hosted repository, Go tools could find it by the URL. We do the above since we're using the local filesystem right now

Synchronize and add dependencies:
`go mod tidy`

The `hello/go.mod` should look as such:
```go
module example/hello  
  
go 1.19  
  
require (  
       example.com/greetings v0.0.0-00010101000000-000000000000  
       rsc.io/quote v1.5.2  
)  
  
require (  
       golang.org/x/text v0.0.0-20170915032832-14c0d48ead0c // indirect  
       rsc.io/sampler v1.3.0 // indirect  
)  
  
replace example.com/greetings => ../greetings
```
The number following the module path is a _pseudo-version number_ -- a generated number used in place of a semantic version number (which the module doesn't have yet).

To reference a _published_ module, a go.mod file would typically omit the `replace` directive and use a `require` directive with a tagged version number at the end.

Now `go run .` outputs:
```
Hi, Gladys. Welcome!
Don't communicate by sharing memory, share memory by communicating.
```

### Handling Errors

In the case of an empty string being passed to the function, let's return an error. `greetings.go` now looks like:
```go
package greetings

import (
    "errors"
    "fmt"
)

// Hello returns a greeting for the named person.
func Hello(name string) (string, error) {
    // If no name was given, return an error with a message.
    if name == "" {
        return "", errors.New("empty name")
    }

    // If a name was received, return a value that embeds the name
    // in a greeting message.
    message := fmt.Sprintf("Hi, %v. Welcome!", name)
    return message, nil
}
```
Notice that we return two values of type `(string, error)`.

We change `hello.go` to handle the potential error:
```go
package main

import (
    "fmt"
    "log"

    "example.com/greetings"
)

func main() {
    // Set properties of the predefined Logger, including
    // the log entry prefix and a flag to disable printing
    // the time, source file, and line number.
    log.SetPrefix("greetings: ")
    log.SetFlags(0)

    // Request a greeting message.
    message, err := greetings.Hello("")
    // If an error was returned, print it to the console and
    // exit the program.
    if err != nil {
        log.Fatal(err)
    }

    // If no error was returned, print the returned message
    // to the console.
    fmt.Println(message)
}
```

### Compile and Install 

`go run` does not compile the application. Let's compile it and execute it:
```bash
go build
./hello
```
Next, let's install the executable so we can run it without specifying its path.
```bash
# Discover the install path
go list -f '{{.Target}}'
# Append the path to environment PATH
export PATH=$PATH:/path/to/your/install/directory
# Run
hello
```
Alternatively, let's save executables to `~/bin`:
```bash
# Change install target 
go env -w GOBIN=$HOME/bin
# Compile and install
go install
# Run
hello
```

## Tour of Go