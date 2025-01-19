# Go Readers
#go #io #interfaces

The `io` package specifies the `io.Reader` interface,
which represents the read end of a stream of data.

The Go standard library contains maybe implementations of this interface,
including files, network connections, compressors, ciphers, and others.

The `io.Reader` interface has a `Read` method:
```go
func (T) Read(b []byte) (n int, err error)
```
`Read` populates the given byte slice `b` with data.
It returns the number of bytes populated `n` and an error value `err`.
It returns an `io.EOF` error when the stream ends.

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

This `Reader`, `MyReader`, emits an infinite stream of character `'A'`
```go
package main

import "golang.org/x/tour/reader"

type MyReader struct{}

// TODO: Add a Read([]byte) (int, error) method to MyReader.
func (r MyReader) Read(bytes []byte) (n int, err error) {
	for i := 0; i < len(bytes); i++ {
		bytes[i] = 'A'
	}
	return len(bytes), nil
}

func main() {
	reader.Validate(MyReader{})
}
```

An exercise applying ROT13 substitution to a stream:
```go
package main

import (
	"io"
	"os"
	"unicode"
	"strings"
)

type rot13Reader struct {
	r io.Reader
}

func rot13Substitution(char rune) rune {
	if unicode.IsLetter(char) {
		if unicode.IsUpper(char) {
			char = 'A' + ((char - 'A') + 13) % 26
		} else {
			char = 'a' + ((char - 'a') + 13) % 26
		}
	}
	return char
}

func readRot13(bytes []byte, n int) {
	for i := 0; i < n; i++ {
		char := rot13Substitution(rune(bytes[i]))
		bytes[i] = byte(char)
	}
}

func (r13 rot13Reader) Read(bytes []byte) (n int, err error) {
	n, err = r13.r.Read(bytes)
	readRot13(bytes, n)
	return n, err
}

func main() {
	s := strings.NewReader("Lbh penpxrq gur pbqr!")
	r := rot13Reader{s}
	io.Copy(os.Stdout, &r)
}
```
