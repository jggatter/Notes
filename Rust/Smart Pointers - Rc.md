# Rust Smart Pointers: Rc, the reference counted smart pointer
#rust #pointers #smartpointers

In the majority of cases, ownership is clear:
you know exactly which variable owns a given value.
However, there are cases where a value may have multiple owners.
For example, graph data structures where multiple edges point to the same node.
A node shouldn't be cleaned up unless if has no edges pointing to it, i.e. no owners.

Multiple ownership must be explicitly enabled by use of `Rc<T>`,
which is an abbreviation for _reference counting_.
`Rc<T>` keeps track of the # of references to a value
to determine whether or not the value is still in use.
If there are zero references to a value, it can be cleaned up without any reference becoming invalid.

We use `Rc<T>` when we want to allocate data on the heap for multiple parts of the program to read, but we can't determine at compile time which part will finish using the data last.
Off the top of my head: removing edges to a node based on some algorithm?
**Only used in single-threaded contexts though!**
Referencing counting is done differently for multi-threaded programs.

## Using `Rc<T>` to share data

Using the cons list data structure (think nested linked list) as an example,
let's say we have two separate lists pointing to the same list.

This won't work:
```rust
enum List {
    Cons(i32, Box<List>),
    Nil,
}

use crate::List::{Cons, Nil};

fn main() {
    let a = Cons(5, Box::new(Cons(10, Box::new(Nil))));
    let b = Cons(3, Box::new(a));
    let c = Cons(4, Box::new(a));
}
```

We could change the definition of `Cons` to hold references instead,
but then we would have to specify lifetimes.
And by specifying lifetime params, we would have to specify every element in the list will live as long as the entire list.
That'd be annoying.

We can change our definition of `List` to use `Rc<T>` instead of `Box<T>`.
```rust
enum List {
    Cons(i32, Rc<List>),
    Nil,
}

use crate::List::{Cons, Nil};
use std::rc::Rc;

fn main() {
    let a = Cons(5, Rc::new(Cons(10, Rc::new(Nil))));
    let b = Cons(3, Rc::clone(&a));
    let c = Cons(4, Rc::clone(&a));
}
```
We need to add a `use` statement to bring `Rc<T>` into scope,
because it's not in the prelude.
We call `Rc::clone`, passing a reference to the `Rc<List>` in `a`.
We could have called `a.clone()` but convention is `Rc::clone`.
`Rc::clone` doesn't make a deepy copy, while `.clone` mostly does.
`Rc::clone` only incremements reference count, which is quick.

## Clone `Rc<T>` increases reference count

Observe how the reference count changes:
```rust
fn main() {
    let a = Cons(5, Rc::new(Cons(10, Rc::new(Nil))));
    println!("Count after creating a = {}", Rc::strong_count(&a));

    let b = Cons(3, Rc::clone(&a));
    println!("Count after creating b = {}", Rc::strong_count(&a));

    {
        let c = Cons(4, Rc::clone(&a));
        println!("Count after creating c = {}", Rc::strong_count(&a));
    }
    println!("Count after c leaves scope = {}", Rc::strong_count(&a));
}
```
```output
Count after creating a = 1
Count after creating b = 2
Count after creating c = 3
Count after c leaves scope = 2
```
The `Drop` trait implementation of `Rc<T>` decreases the reference count.
When `a`+`b` leave scope, the count goes to 0 and the list is cleaned up.

