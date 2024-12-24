# Rust Smart Pointers: `Box<T>`
#rust #pointers #smartpointers #heap

The most straightforward smart pointer is a _box_, `Box<T>`.
Boxes allow storing data on the heap rather than the stack.

Boxes have no performance overhead, other than storing data on the heap instead.
They don't have many extra capabilities either.

They're most useful for these situations:
- When you have a type whose size is unknown at compile time, and want to use a value of that type in a context that requires an exact size.
- When you have a large amount of data and want to transfer ownership, but want to ensure the data will not be copied in doing so.
- When you want to own a value and only care that its a type that implements a particular trait rather than being of a specific type (_trait object_).

## Using `Box<T>` to store data on the heap

A simple but atypical example: store an `i32` value on the heap:
```rust
fn main() {
    let b = Box::new(5);
    println!("b = {b}");
}
```
This prints "b = 5".

The box pointer itself is stored on the heap.
The data is allocated on the heap, 
but the data is accessible as if it were stored on the stack.
When a box goes out of scope, the box and the data are both deallocated.

The example is atypical because single primitives are best left on the stack.

## Enabling Recursive Types with Boxes

A value of a _recursive type_ can have another value of the same type as part of itself. E.g. Type `T` can hold a `T` value which can ...

These types pose an issue:
The compiler needs to know how much space a type can take up,
but the nesting of values could theoretically continue infinitely.
Because boxes have a known size, we can enable recursive types by inserting a box in the recursive type definition.

### Example: cons list

A _cons list_ is an example of a recursive type.
It's common in functional programming languages.

Similar to a linked list:
The data structure is made up of nested list pairs,
in which each list contains two elements: the current value and the next pair.
Pseudocode representation of a cons list:
```
(1, (2, (3, Nil)))
```

It's not common in Rust, most of the time `Vec<T>` is a better choice.
We use `Box` to give the compiler a known size to work with:
```rust
enum List {
    Cons(i32, Box<List>),
    Nil,
}

use crate::List::{Cons, Nil};

fn main () {
    let list = Cons(1, Box::new(Cons(2, Box::new(Cons(3, Box::new(Nil))))))
}
```

## Enabling Dynamic Dispatch

Trait objects are the feature that enables [[Dynamic Dispatch]].
Likewise, `Box` can work with trait objects;
values of any type that implement a given trait.
Being of any type means that we do not know the size at compile time.

```rust
trait Shape {
    fn area(&self) -> f64;
}

struct Circle { radius: f64 }

impl Shape for Circle {
    fn area(&self) -> f64 {
        std::f64::consts:PI * self.radius * self.radius
    }
}

let shape: Box<dyn Shape> = Box::new(Circle{radius: 5.0});
println!("Area {}", shape.area());
```

