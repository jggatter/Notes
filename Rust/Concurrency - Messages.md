# Rust Concurrency: Using Message passing to transfer data between threads
#rust #concurrency #threads #messages #channels #ownership

One increasingly popular approach to ensure safe concurrency is message passing,
where threads or actors communicate by sending messages containing data to each other.

Go language's slogan:
> Do not communicate by sharing memory;
> instead share memory by communicating.

Rust's standard library provides an implementation of _channels_.
A channel is a programming concept by which data is sent from one thread to another.

A channel has two halves, a transmitter and receiver.
The transmitter's methods are called with data we want to send,
and the receiver checks for arriving messages.
The channel is said to be `closed` if either half is dropped.

```rust
use std::sync::mpsc;

fn main() {
    let (tx, rx) = mpsc::channel();
}
```
The channel is created by `mpsc::channel.
`mpsc` standards for _multiple producer, single consumer_.
This means a channel can have many transmitters, which produce values,
but only one receiver, which consumes the values.

`channel` returns a tuple of the `(transmitter, receiver)`.
These are commonly abbreviated as `(tx, rx)`.
The tuple is deconstucted by this `let (tx, rx)` statement so that variables `tx` and `rx` are bound.

```rust
use std::sync::mpsc;
use std::thread;

fn main () {
    let (tx, rx) = mpsc::channel();
    
    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
    });
}
```
Here we create a new thread and move `tx` into it. It is now owned by this thread.
`tx` sends `val` through the channel via `send`,
which returns a `Result<T, E>` type.
If the receiver has already been dropped, there's nowhere to send the value,
and the send operation will return an error.
Here we call `unwrap` to panic in case of an error, but in a real application we would handle it properly.


```rust
use std::sync::mpsc;
use std::thread;

fn main () {
    let (tx, rx) = mpsc::channel();
    
    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
    });
    
    let received = rx.recv().unwrap();
}
```
Receiver has two useful methods, `recv` and `try_recv`.
We use `recv`, "receive", to block the main thread and wait for a message.
Once the value is sent, `recv` returns it in a `Result<T, E>`.
When the transmitter closes, `recv` will return an error to signal no further values will be coming.

`try_recv` does not block but instead returns `Result<T, E>` immediately.
An `Ok` value holding a message if available,
or an `Err` if there weren't any messages.
This method is useful when one thread has other work to do while waiting.
We can call it in a loop every so often to handle any available messages.

## Channels and ownership transference

Ownership rules play a vital role in safe, concurrent message sending code.

We'll try using `val` in a spawned thread after we've sent it down the channel.
This does not compile:
```rust
use std::sync::mpsc;
use std::thread;

fn main () {
    let (tx, rx) = mpsc::channel();
    
    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
        println!("val is {val}");
    });
    
    let received = rx.recv().unwrap();
    println!("Got: {received}");
}
```
`send` takes ownership of its parameter,
when the value is moved, the receiver takes ownership of it.
Therefore the borrow in the spawned thread is invalid.

## Sending multiple values and seeing the receiver waiting

The spawned thread will now send multiple messages,
pausing a second between messages:
```rust
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main () {
    let (tx, rx) = mpsc:channel();
    
    thread::spawn(move || {
        let vals = vec![
            String::from("hi");
            String::from("from");
            String::from("the");
            String::from("thread");
        ];

        for val in vals {
            tx.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });

    for recieved in rx {
        println!("Got: {received}");
    }
}
```
The spawned thread has a vector of strings that we want to send to the main thread.
We iterate over them, sending each individually, pausing 1 sec between each.
We do not call `recv` explicitly, we treat `rx` as an iterator.
The receiver waits until the channel is closed, ending iteration.

## Creating multiple producers by cloning the transmitter

We can clone the transmitter to create multiple producers of messages:
```rust
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main () {
    let (tx, rx) = mpsc:channel();
    
    let tx1 = tx.clone();    
    thread::spawn(move || {
        let vals = vec![
            String::from("hi");
            String::from("from");
            String::from("the");
            String::from("thread");
        ];

        for val in vals {
            tx1.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });

    thread::spawn(move || {
        let vals = vec![
            String::from("more");
            String::from("messages");
            String::from("for");
            String::from("you");
        ];

        for val in vals {
            tx.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });
    for recieved in rx {
        println!("Got: {received}");
    }
}
```
We now have two transmitters sending messages to the same receiver.

