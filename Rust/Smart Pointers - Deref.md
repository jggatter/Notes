# Rust Smart Pointers: Treating as regular references using `Deref` trait
#rust #pointers #smartpointers #references #traits

Implementing trait `Deref` allows customizing of the derefence operator, `*`.
By implementing `Deref`, such that smart pointers can be treated as regular references,
we can write code that operates on references and use that code with smart pointers too.

## Following the pointer to the value

A regular reference is a type of pointer.
One way to think of a pointer is like an arrow pointing to a value stored elsewhere.

```rust
fn main () {
    let x = 5;
    let y = &x;

    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```
`y` is a pointer, equal to the reference of `x`.
`*y` is the derefencing of this reference, accessing the value of `5`.

## Using `Box<T>` like a reference

We can rewrite the above examples to use a `Box<T>` instead of a reference.
We still use the deference operator in the same way.
```rust
fn main() {
    let x = 5;
    let y = Box::new(x);

    assert_eq!(5, x);
    assert_eq!(5, *y);
}
```

## Defining our own smart pointer

We can make a smart pointer similar to `Box<T>`.
This will help us experience how smart pointers behave differently from references.

```rust
struct MyBox<T>(T);

impl<T> MyBox<T> {
    fn new(x: T) -> MyBox<T> {
        MyBox(x)
    }
}
```
`MyBox` is a tuple struct which holds one element of type `T`.
It has a `new` constructor function.

In order to dereference it we need to implement `Deref`:
```rust
use std::ops::Deref;

impl<T> Deref for MyBox<T> {
    type Target = T;
    
    fn deref(&self) -> &Self::Target {
        &self.0
    }
}
```
`defer` returns a "regular" reference to the value we want to access with `*`.

The `type Target = T;` syntax defines an associated type for `Deref` to use.
Associated types are a slightly different way of declaring a generic param.

Behind the scenes `*y` (reference `y`) was actually `*(y.deref())`.
Rust substitutes `*` with a call to `deref` and then a plain derefene.
This is so we don't have to think about whether or not we need to call `.deref`.
This Rust feature lets us write code that functions identically whether we have regular reference of a type that implements `Deref`.

## Implicit `Deref` coercions with funcs and methods

_Defer coercion_ converts a `Deref`-implementing type to a ref to another type.
E.g. `&String` -> `&str`
because `String` implements `Deref` such that it returns `&str`.

It's a convenience Rust performs on arguments to funcs and methods.
It works only on types that implement `Deref`.
Automatically happens when we pass a ref to a particular type's value
as argument to a func/method where the defined param type doesn't match.
A sequence of calls to `defer` converts the type to the type the param needs.

Was added so that we don't need to add so many explicit `*` and `&` calls.
It also lets us write code that can work for either references or smart ptrs.

```rust
fn hello(name: &str) {
    println!("Hello {name}!");
}

fn main() {
    let m = MyBox::new(String::from("Rust"));
    hello(&m);
}
```

Without defer coercion, we'd have to write code like this:
```rust
fn main() {
    let m = MyBox::new(String::from("Rust"));
    hello(&(*m)[..]); 
}
```
`(*m)` dereferences `MyBox<String>` to `String`.
`&` and `[..]` take a string slice of the whole string to get `&str`.

## How Deref Coercion interacts with mutability

`Deref` trait overrides `*` operator behavior on immutable references.
`DerefMut` does so for mutable references.


Deref coercion happens when we find types and trait implementations in 3 cases:
- From `&T` to `&U` when `T: Deref<Target=U>`
- From `&mut T` to `&mut U` when `T: DerefMut<Target=U>`
- From `&mut T` to `&U` when `T: Deref<Target=U>`

First two cases are the same except the second implements mutability.
The third case is trickier: Rust will coerce a mutable ref to an immutable one.
The reverse is not possible because of borrowing rules.
Converting immutable ref to mutable ref would require that immutable ref was the only reference to that data,
but borrowing rules don't guarantee this, therefore Rust can't assume.

