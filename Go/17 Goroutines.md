# Go Concurrency
#go #concurrency #goroutines #threads #channels

## Goroutines

A goroutine is a lightweight thread managed by the Go runtime.

Using the `go` keyword on a function,
```go
go f(x, y, z)
```
starts a new goroutine running the function:
```go
f(x, y, z)
```
The _evaluation_ of `f`, `x`, `y`, and `z` happens in the current goroutine
and the actual _execution_ of `f` happens in the new goroutine.

The strings "hello" and "world" are printed multiple times in different threads:
```go
package main

import (
    "fmt"
    "time"
)

func say(s string) {
    for i := 0; i < 5; i++ {
        time.Sleep(100 * time.Millisecond)
        fmt.Println(s)
    }
}

func main() {
    go say("world")
    say("hello")
}
```

Goroutines run in the same address space,
so access to shared memory must be synchronized.

The `sync` package provides useful primitives,
although you won't need them much in Go as there are other primitives,
such as `Channel`.

## Channels

Channels are a typed conduit
through which you can send an receive values with the channel operator, `<-`.
```go
ch <- v    // Send v to channel ch
v := <-ch  // Receive from ch, and assign value to v
```
(The data flows in the direction of the arrow.)

Like maps and slices, channels must be created before use.
We `make` a `chan` for sending/receiving type `int`:
```go
ch := make(chan int)`
```

By default, send and receive actions block until the other side is ready.
This allows goroutines to sync without explicit locks or condition variables.

We sum numbers in a slice, distributing the work between two goroutines.
Once goroutines have completed, the main thread receives the result of each.
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
    middle := len(s) / 2
	go sum(s[:middle], c)
	go sum(s[middle:], c)
	x, y := <-c, <-c // receive from c

	fmt.Println(x, y, x+y)
}
```

### Buffered channels

Channels can be _buffered_.

To initialize a buffered channel,
provide the buffer length as the second argument to `make`:
```go
ch := make(chan int, 100)
```

Send actions to a buffered channel block only when the buffer is full.
Receive actions block when the buffer is empty.

Here when we try sending more values than the buffer can hold,
the goroutine is blocked!
Nothing here unblocks it, so we get a deadlock:
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

### Range and Close

A sender can `close` a channel to indicate that no more values will be sent.

Receivers can test whether a channel has been closed
by assigning a second boolean parameter (e.g. `ok`) to the receive expression.
After this send,
```go
v, ok := <-ch
```
`ok` is `false` if there are no more values to receive
and the channel is closed.

Using `range` on the channel, the loop 
```go
for i := range c
```
receives values from the channel repeatedly until it is closed.

E.g., a goroutine executes `fibonacci`, sending each elem to the channel.
The for-loop `range` waits an receives each elem as `i`, printing it.
`close` closes the channel so we can terminate the `range`:
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

#### Notes on closing channels

Only the sender should close a channel, never the receiver.
Sending on a closed channel will cause a panic.

Also, channels aren't like files; you don't usually need to close them.
Closing is only necessary when the receiver must be told there are no more values coming, such as to terminate a `range` loop.

## Select: handling multiple communication operations

The `select` statement lets a goroutine wait on multiple communication ops.
It's like a switch statement but for sending/receiving actions.

A `select` blocks until one of its cases can run, then it executes that case.
It chooses one at random if multiple are ready.

Here the `fibonacci` is orchestrated by cases within a `select` block.
It is powered by sending/receiving to/from the two channels, `c` and `quit`.
```go
package main

import "fmt"

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

    // This closure starts running in a goroutine
	go func() {
        // waiting to receive 10 times from channel c
        // the select statement unblocks each time for case `c <- x`
		for i := 0; i < 10; i++
			fmt.Println(<-c)
		}
        // after the loop we send a value to quit,
        // unblocking case `<-quit` (while `c <- x` is now blocked),
        // terminating the function
		quit <- 0
	}()

    // In the main thread we run fibonacci
	fibonacci(c, quit)
}
```

### Default selection

The `default` case in a `select` is run if no other case is ready.

Use a `default` case to try a send or receive without blocking:
```go
select {
case i := <-c:
	// use i
default:
	// receiving from c would block this!
}
```

In this example,
`Tick` and `After` return channels that receive values at certain intervals.
The default case is executed in between these intervals of receiving values.
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
The output:
```output
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

But what if we don't need communication?
What if we just want to make sure only one goroutine can access a variable at a time to avoid conflicts?

This concept is _mutual exclusion_.
The conventional name for the data structure that provides it is a _mutex_.

Go's stdlib provides mutual exclusion with `sync.Mutex` and its two methods:
- `Lock`
- `Unlock`

We can define a block of code to be executed in mutual exclusion
by surrounding it with a call to `Lock` and `Unlock`,
as shown on the `Inc` method:
We can also use `defer` to ensure the mutex will be unlocked.
```go
package main

import (
    "fmt"
    "sync"
    "time"
)

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

