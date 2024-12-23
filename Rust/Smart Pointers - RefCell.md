# Rust Smart Pointers: `RefCell<T>` and the Interior Mutability Pattern
#rust #pointers #smartpointers #mutability

Interior mutability is a Rust design pattern that allows mutating data
even when there are immutable references to that data;
normally, this action is disallowed by borrowing rules.
The pattern uses `unsafe` code inside the data structure to bend rules.

The `RefCell<T>` type that follows the interior mutability pattern.

## Enforce borrowing rules at runtime with `RefCell<T>`

Unlike `Rc<T>`, the `RefCell<T>` type represents a single ownership over the data it holds.

Recall the borrowing rules:
- At any given time, you can have exclusively either one mutable reference or any number of immutable references.
- References must always be valid.

Note: In programming, invariants are properties/conditions that are always true during the execution of a program.
With references and `Box<T>`, the borrowing rules' invariants are enforced at compile time.
With `RefCell<T>`, these invariants are enforced at _runtime_.
With references, breaking these rules yields a compiler error.
With `RefCell<T>`, breaking these rules causes the program to panic.

Checking errors at compile time is beneficial
in that errors are caught sooner in development process,
and there is no impact on runtime performance because all analysis is completed up front.
Checking these rules at compile time is the best choice in any cases,
this is why it's the default in Rust.

Checking the rules at runtime instead allows certain memory-safe scenarios that would otherwise be disallowed by compile-time checks.
Not every problem can be detected by analyzing the code,
therefore the compiler is conservative,
potentially rejecting a program that would run correctly.
`RefCell<T>` is used when we're sure our code followings borrowing rules but the compiler can't understand and guarantee that.

Like `Rc<T>`, `RefCell<T>` is only used for single-threaded scenarios.
We'll get a compile-time error if we try it in a multi-threaded context.
`Mutex<T>` is the thread-safe version.

## Recap: Choosing a smart pointer and Interior Mutability

`Rc<T>` enables multiple ownership of the same data.
`Box<T>` and `RefCell<T>` have single owners.

`Box<T>` allows immutable or mutable borrows checked at compile time.
`Rc<T>` allows only immutable borrows checked at compile time.
`RefCell<T>` allows immutable or mutable borrows checked at runtime.

Because `RefCell<T>` allows mutable borrows checked at runtime,
you can mutate the value inside a `RefCell<T>` even when the `RefCell<T>` itself is immutable.
Mutating the value inside an immutable value is the _interior mutability pattern_.

## Interior Mutability: a mutable borrow to an immutable value

This won't compile.
```rust
fn main () {
    let x = 5;
    let y = &mut x;
}
```

However there are situations when it'd be useful for a value to mutate itself in its methods, but appear immutable to other code.

`RefCell<T>` allows us to do this,
but we still have to obey borrowing rules or else the program will panic.

## An example use case for interior mutability: Mocking Objects

Rust doesn't have standard library functionality of mocking objects,
unlike in other languages.

We want to test the following code:
```rust
pub trait Messenger {
    fn send(&self, msg: &str);
}

pub struct LimitTracker<'a, T: Messenger> {
    messenger: &'a T,
    value: usize,
    max: usize,
}

impl <'a, T> LimitTracker<'a, T>
where
    T: Messenger
{
    pub fn new(messenger: &'a T, max: usize) -> LimitTracker<'a, T> {
        LimitTracker {
            messenger,
            value: 0,
            max,
        }
    }

    pub fn set_value(&mut self, value: usize) {
        self.value = value;
        
        let percentage_of_max = self.value as f64 / self.max as f64;
        if percentage_of_max >= 1.0 {
            self.messenger.send("Error: Exceeded the quota!");           
        } else if percentage_of_max >= 0.9 {
            self.messenger.send("Warning: >90% of quota used up!");
        } else if percentage_of_max >= 0.75 {
            self.messenger.send("Warning: >75% of quota used up.");
        }
    }
}
```
Notice that `send` takes an immutable reference to `self`.

We need a mock object that, instead of sending message on `send`,
will merely keep track of the messages its told to send.

We create an instance of the mock object,
we create a `LimitTracker` that uses the mock object,
call the `set_value` on `LimitTracker`,
and then check that the mock object has the messages we expect.

This won't compile:
```rust
#[cfg(test)]
mod tests {
    use super::*;

    struct MockMessenger {
        sent_messages: Vec<String>,
    }

    impl MockMessenger {
        fn new() -> MockMessenger {
            MockMessenger {
                sent_messages: vec![],
            }
        }
    }

    impl Messenger for MockMessenger {
        fn send(&self, message: &str) {
            self.sent_messages.push(
                String::from(message));
            )
        }
    }

    #[test]
    fn it_sends_an_over_75_percent_warning_message() {
        let mock_messenger = MockMessenger::new();
        let mut limit_tracker = LimitTracker::new(&mock_messenger, 100);

        limit_tracker.set_value(80);
        
        assert_eq!(mock_messenger.sent_messages.len(), 1);
    }
}
```
Since `send` accepts an immutable reference to `self`, 
we can't modify `MockMessenger` to track messages.
The compiler suggests using `&mut self`, but this betrays the `Messenger` trait.

We'll store the `sent_messages` in a `RefCell<T>` to get around this:
```rust
#[cfg(test)]
mod tests {
    use super::*;
    use std:cell:RefCell;

    struct MockMessenger {
        sent_messages: RefCell<Vec<String>>,
    }

    impl MockMessenger {
        fn new() -> MockMessenger {
            MockMessenger{
                sent_messages: RefCell::new(vec![]),
            }
        }   
    }

    impl Messenger for MockMessenger {
        fn send(&self, message: &str) {
            self.sent_messages.borrow_mut().push(
                String::from(message);
            )
        }
    }

    #[test]
    fn it_sends_an_over_75_percent_warning_message() {
        // ...
        assert_eq!(mock_messenger.sent_messages.borrow().len(), 1);
    }
}
```
We use `RefCell::new` to create an instance around the empty vector.
We preserve the `send` implementation where `self` is borrowed immutably.
`borrow_mut` on the `RefCell` gets us a mutable ref to the value inside.
This let's us call `push` on it.
For the assertion, we use `borrow` to get an immutable ref.

## Multiple owners of mutable data by combining `Rc<T>` and `RefCell<T>`

A common way to use `RefCell<T>` is in combination with `Rc<T>`.
`Rc<T>` enables multiple owners of some data, but only immutable access.
`Rc<T>` that holds `RefCell<T>` enables multi ownership w/ mutability!

```rust
#[derive(Debug)]
enum List {
    Cons(Rc<RefCell<i32>>, Rc<List>),
    Nil,
}

use crate::List::{Cons, Nil};
use std::cell::RefCell;
use std::rc::Rc;

fn main() {
    let value = Rc::new(RefCell::new(5));
    
    let a = Rc::new(Cons(Rc::clone(&value), Rc::new(Nil)));

    let b = Cons(Rc::new(RefCell::new(3)), Rc::clone(&a));
    let c = Cons(Rc::new(RefCell::new(4)), Rc::clone(&a));

    *value.borrow_mut() += 10;

    println!("a after = {a:?}"); // Cons(RefCell {value: 15}, Nil)
    println!("b after = {b:?}"); // Cons(RefCell {value: 3}, value of a)
    println!("c after = {c:?}"); // Cons(RefCell {value: 4}, value of a)
}
```
