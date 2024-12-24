# Rust Dynamic Dispatch
#rust

When code involves polymorphism, there needs to be a mechanism
which chooses which specific version is run or _dispatched_.
Dynamic dispatch is the alternative to Rust's favored static dispatch.

## Static Dispatch

Rust uses _monomorphization_ to perform static dispatch;
the compiler fills in concrete types for generic ones at compile time,
duplicating code if necessary.

Consider we write:
```rust
fn do_something<T: Foo>(x: T) {
    x.some_method();
}

fn main() {
    let x = 5u8;
    let y = "Hello".to_string();
    
    do_something(x);
    do_something(y);
}
```

The compiler would create type-specific variants for `do_something` for `u8` and `String`, then replace the call sites with calls to these specialized funcs.
```rust
fn do_something_u8<T: Foo>(x: u8) {
    x.some_method();
}

fn do_something_string<T: Foo>(x: String) {
    x.some_method();
}

fn main() {
    let x = 5u8;
    let y = "Hello".to_string();
    
    do_something_u8(x);
    do_something_string(y);
}
```

Static dispatching of any method call allows for inlining,
usually increasing performance.

However, this can potentially cause code bloat;
too many copies of the same function may exist in the binary.
Furthermore, compilers aren't perfect and may "optimise" code to become slower.
For example, functions inlined too eagerly will bloat the instruction cache.
This is why `#[inline]` and `#[inline(always)]` should be used carefully.

Commonly it is most efficient to use static dispatch.
One can also have a thin statically-dispatched wrapper func that does dynamic dispatch, but not vice versa. 
Thus static calls are more flexible.
So, the standard library tries to be statically-dispatched where possible.

Generally:
Libraries should avoid dynamic dispatch so any choices belongs to the user,
while binaries can make use of dynamic dispatch.

Still, for some of these situations named above,
and despite a performance penalty at runtime,
it may be more preferable to instead use dynamic dispatch.

## Dynamic Dispatch

Trait objects are the feature that provide dynamic dispatch.
For example of trait `Foo`, `&Foo` or `Box<Foo>`
These are values which store a value of any type that implement a given trait.
The precise type can only be known at runtime.

We can obtain a trait object value in two ways: casting or coercing.
```rust
// Where T is a type that implements trait Foo
let ref_to_t: &T = ...;

// Cast using `as`
let casted = ref_to_t as &Foo;

// Coercion
let coerced: &Foo = ref_to_t;

// likewise coerce by passing to function.
fn also_coerce(_unused: &Foo) {
}

also_coerce(ref_to_t);
```
Coercions and casts will also work for pointers like `&mut T` to `&mut Foo`,
and `Box<T>` to `Box<Foo>`.

The operation can be seen as "erasing" the compiler's knowledge about the type,
hence trait objects are sometimes referred to as "type erasure".

We can use the `dyn` keyword to put the trait object in a `Box<T>`
so that the compiler won't complain about it not having a known size.

Example using casting:
```rust
// decide which backend to use based on a user-set program argument
let backend = match env::args().skip(1).next() {
    Some(x) => Box::new(PositiveBackend ) as Box<dyn Backend>,
    _ => Box::new(NegativeBackend) as Box<dyn Backend>
};
```
Another example using coercion:
```rust
let shape: Box<dyn Shape> = Box::new(Circle { radius: 5.0 });
```
When using `dyn`, we acknowledge the following about dynamic dispatching:
- `dyn` disables some arithmetic optimizations
- `dyn` disables inlining
- `dyn` slows down code, usually with tolerable impact given the flexibility.

At the end of the day:
One should always profile the application before trying to blindly optimize it.
