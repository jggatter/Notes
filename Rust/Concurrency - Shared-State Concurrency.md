# Rust Concurrency: Shared-State Concurrency
#rust #concurrency #threads #mutexes

Another method of handling concurrency, apart from channels,
is having multiple threads access the same shared data.

Consider this part of the Go language's slogan on concurrency:
> Do not communicate by sharing memory.

Channels in any language are similar to single ownership.
Once you transfer a value down a channel, you should no longer use that value.
Shared memory concurrency is like multiple ownership:
multiple threads can access the same memory at the same time.

As we saw with smart pointers, multiple ownership brings its own complexity.
Rust's type system and ownership rules assist in managing this complexity.
Mutexes are a more common concurrency primitive for working with shared memory.

## Using mutexes to allow access to data from one thread at a time.

_Mutex_ is an abbreviation for _mutual exclusion_;
a mutex allows only one thread access to some data at any given time.

To access the data in a mutex, a thread must first request the mutex's _lock_.
The lock is a data structure which tracks who currently has exclusive access.
Therefore, a mutex is described as _guarding_ the data it holds via this lock.

Mutexes have a reputation for being difficult to use because of these rules:
- You must attempt to acquire the lock before using the data
- When you're done with the data, you must unlock the data for access by others.

In a single-threaded context, for simplicity:
```rust
use std::sync::Mutex;

fn main() {
    let m = Mutex::new(5);
    
    {
        let mut num = m.lock().unwrap();
        *num = 6;
    }
    
    println!("m = {m:?}");
}
```
As with many types, we create a `Mutex<T>` using `new`.
We use `lock` to acquire the lock.
The call would fail if another thread holding it panicked.
We've chosen to `unwrap` and have this thread panic in this situation.

The type of `m` is a smart pointer, `Mutex<i32>`, not `i32`.
We must call `lock` to be able to use the `i32` value.
The `lock` return value is a mutable reference to the data inside.
More accurately, `lock` returns a smart pointer called `MutexGuard`.
It implements `Deref` so we can dereference it to get the `i32` value.
It implements `Drop` so that it automatically releases the lock upon dropping.

## Multiple Ownership With Multiple Threads

Trying to share a plain `Mutex<T>` among multiple threads will not work,
the second thread spawned will fail to acquire the lock,
because the first thread takes ownership.

To get around this, We can wrap `Mutex<T>` in `Arc<T>`,
and clone the `Arc<T>` before moving ownership to the thread.

`Rc<T>` is not thread-safe, but `Arc<T>` is!
`Arc<T>` is an _atomically reference counted_ type.
Atomics are an additional kind of concurrency primitive.
Atomics work like primitives but are safe to share across threads.

Why `Arc<T>` is only used in concurrent contexts:
Assuring thread safety comes with a performance penalty,
code in a single thread will run faster if it doesn't have to enforce guarantees.

`Arc<T>` has a similar user experience to `Rc<T>`:
```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main () {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            
            *num += 1;
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }
    
    println!("Result {}", *counter.lock().unwrap());  // prints 10
}
```
Note: If simple numerical operations are being done,
there are simpler types than `Mutex<T>` provided by `std::sync::atomic`.

