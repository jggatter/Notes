# Rust Concurrency - Threads
#rust #concurrency #threads

Independent parts of a program that run simulataneously are run by threads.
Web servers typically have many to handle more than one request at a time.

Splitting computation into multiple threads to run tasks in parallel
can improve performance, but it also adds complexity.

With simulateaneously running threads,
there are no inherent guarantees about th order in which tasks run.
This can lead to problems such as:
- Race conditions: threads access data/resources in inconsistent order.
- Deadlocks: Two threads wait for each other, preventing them from progressing.
- Rare situational bugs that are hard to reproduce and fix reliably.

Rust tries to mitigate the negative effects of using threads.
Programming in multithreaded context still takes careful thought
as well as a different code structure.

## Creating new thread with `spawn`

We call `thread::spawn` to create a new thread,
passing it a closure containing the code we want to run in the new thread.
```rust
use std::thread;
use std::time::Duration;

fn main() {
    thread::spawn(|| {
        for i in 1..10 {
            println!("hi {i} from spawned thread");
            thread::sleep(Duration::from_millis(1));
        }
    });

    for i in 1..5 {
        println!("hi {i} from main thread");
        thread::sleep(Duration::from_millis(1));
    }
}
```
`thread::sleep` causes the thread to wait for the specified duration.
When the main thread completes, all threads are shut down.

The output can differ from run to run:
```output
hi number 1 from the main thread!
hi number 1 from the spawned thread!
hi number 2 from the main thread!
hi number 2 from the spawned thread!
hi number 3 from the main thread!
hi number 3 from the spawned thread!
hi number 4 from the main thread!
hi number 4 from the spawned thread!
hi number 5 from the spawned thread!
...
```

## Waiting for all threads using `join` handles

In the above example, the main thread may terminate before the spawned threads finish, prematurely terminating them.

We can use the return value of `thread::spawn`, a `JoinHandle`.
A `JoinHandle` is an owned value.
When we call `join` on it, it will block the current thread,
causing it to wait for its thread to finish.
```rust
use std::thread;
use std::time::Duration;

fn main() {
    let handle = thread::spawn(|| {
        for i in 1..10 {
            println!("hi {i} from spawned thread");
            thread::sleep(Duration::from_millis(1));
        }
    });

    for i in 1..5 {
        println!("hi {i} from main thread");
        thread::sleep(Duration::from_millis(1));
    }
}

handle.join().unwrap();
```
When the main thread is done printing numbers and reaches the `join`,
it will wait for the child thread to print all numbers and terminate.

If we moved `join` right before the main thread prints,
the child thread would print all numbers, then the main thread would start printing all number.

## Using `move` closures with threads

We'll often use the `move` keyword with closure passes to `thread::spawn`.
The closure will take ownership of the values it uses from the environment,
thus transferring ownership of those values from one thread to another.

This won't work:
```rust
use std::thread;

fn main() {
    let v = vec![1, 2, 3];

    let hande = thread::spawn(|| {
        println!("Here's a vector {v:?}");
    });
    
    handle.join().unwrap();
}
```
Rust infers how to capture `v` in the closure, attempting to borrow `v`.
The compiler complains that the closure may outlive the current function,
which owns it.
Rust can't know how long the spawned thread will run, so the ref to `v` would not be guaranteed.

It suggests we use `move` with the closure to transfer ownership:
```rust
use std::thread;

fn main() {
    let v = vec![1, 2, 3];

    let hande = thread::spawn(move || {
        println!("Here's a vector {v:?}");
    });
    
    handle.join().unwrap();
}
```
In doing this, we will no longer be able to use `v` on the main thread.







