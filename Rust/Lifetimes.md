# Rust Lifetimes
#rust #lifetimes #generics

Lifetimes are another kind of generic we've already been using.

Rather than ensure a type has the behavior we want,
lifetimes ensure that references are valid as long as we need them to be.

Every reference in Rust has a _lifetime_:
the scope for which that reference is valid.

Most of the time, lifetimes are implicit and inferred,
just as how most of the time types are are inferred.
We must annotate types only when multiple types are possible.
Similarly, we must annotate types when the lifetimes of references could be
related in a few different ways.
Rust requires us to annotate the relationships using generic lifetime params
to ensure the actual references at runtime are assured to be valid.

Annotating lifetimes is an uncommon concept in programming languages.

## Prevent dangling references with lifetimes

The main aim of lifetimes is to prevent _dangling references_,
which cause a program to reference data other than the data it's intended to reference.

Consider the following example with an outer and inner scope:
```rust
fn main() {
    let r; // Note: Rust will raise an error if we use before assigning val
    
    {
        let x = 5;
        r = &x; // attempt to set r as reference to x
    } // x goes out of scope, is dropped here

    println!("r: {r}");
}
```
This code won't compile because the value of `r` in the inner scope goes out of scope before we try to use it.
i.e. "`x` does not live long enough"
`r` is still valid for the outer scope.
Because its scope is larger, we say it "lives longer".

If Rust allowed the code to work, `r` would reference memory that was deallocated when `x` went out of scope.
Anything we'd try to do with `r` wouldn't work correctly.

Rust determines cases like these as invalid using the borrow checker.

## The Borrow Checker

The Rust compiler has a borrow checker that compares scopes
to determine whether all borrows are valid.

Let's annotate to show lifetimes of the variables:
```rust
fn main() {
    let r;                // ---------+-- 'a
                          //          |
    {                     //          |
        let x = 5;        // -+-- 'b  |
        r = &x;           //  |       |
    }                     // -+       |
                          //          |
    println!("r: {r}");   //          |
}                         // ---------+
```
Here we've annotated `r` with lifetime `'a`,
and `x` with lifetime `'b`.

The rust compiler compares the sizes of each lifetime.
It sees the lifetime of `r` is `'a`,
but `r` references memory with a lifetime of `'b`!
The program is rejected because `'b` is shorter than `'a`;
the subject of the reference doesn't life as long as the reference.

This example fixes the problem:
```rust
fn main() {
    let x = 5;            // ---------+-- 'b
                          //          |
    let r = &x;           // -+-- 'a  |
                          //  |       |
    println!("r: {r}");   //  |       |
}                         // -+-------+
```
Here `x` has lifetime `'b`, which is greater than `'a`.
This means `r` can reference `x`
because Rust knows the reference in `r` will always be valid while `x` is valid.

## Generic Lifetimes in Functions

Consider:
```rust
fn longest(x: &str, y: &str) -> &str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```
The compiler will error since it does not know
whether the reference returned refers to `x` or `y`.
We don't know whether `x` lives longer than `y` and vice versa.

We'll add generic lifetime parameters that define the relationship among the references so the borrow checker can perform its analysis:
```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    // ...
}
```

## Lifetime Annotation Syntax

Lifetime annotations don't change how long any references live.
Rather, they describe the lifetimes of multiple references relative to each other without affecting them.

Just as functions accept any type when the signature specifies a generic type parameter,
they can accept references with any lifetime by specifying a generic lifetime parameter

Lifetime annotation syntax is slightly unusual:
- must start with an apostrophe `'`
- usually all lowercase and very short
- It goes right after the `&` of a reference, separated by type with a space

```rust
&i32        // a ref
&'a i32     // a ref with explicit lifetime
&'a mut i32 // a mutable ref with an explicit lifetime
```

One lifetime annotation by itself doesn't have much meaning,
because annotations are meant to explain relationship among multiple references.

## Lifetime annotations in Function Signatures

To use lifetime annotations in function signatures,
we need to declare the generic lifetime parameters within angle brackets,
just as we do with generic type parameters.
```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```
In the above example the compiler needs to know how the return reference
relates to the parameters in terms of lifetime.
We annotate each with `'a` since either `x` or `y` can be the returned ref.

In this example we do not annotate `y`, since it has no relationship with the lifetime of `x` or the return value.
```rust
fn longest<'a>(x: &'a str, y: &str) -> &'a str {
    x
}
```

When returning a reference, the lifetime param for the return type needs to match the lifetime param for one of the parameters.
If the reference returned does not relate to the parameters,
then it'd have to refer to a value created within the function
However, the value would be scoped to the function and would go out of scope at the end! Dangling reference!

The below example won't compile:
```rust
fn longest<'a>(x: &str, y: &str) -> &'a str {
    let result = String::from("really long string");
    result.as_str()
}
```
There's no way to fix this using generic lifetime annotations.
The best fix would be to change the function to return an owned data type,
making the calling function responsible for cleaning up the value.

## Lifetime annotations in struct definitions

Structs generally hold owned types.
We can define structs to hold references,
but we'd need to add lifetime annotations for each ref in the struct def.
```rust
struct ImportantExcerpt<'a> {
    part: &'a str,
}

fn main {
    let novel = String::from("Call me Ishmael. Some years ago...");
    let first_sentence = novel.split('.').next().unwrap();
    let i = ImportantExcerpt { part: first_sentence };
}
```
Again as we did with functions,
and as we do for structs accepting generic data types,
we declare the lifetime annotation in the angle brackets.
This annotation means an instance of `ImportantExcerpt` can't outlive its references annotated with the same annotations, i.e. `part`.

Since `novel` doesn't go out of scope until after `ImportantExcerpt` does, the reference in `ImportantExcerpt` is valid.

## Lifetime Elision

Consider the following code, which compiles without lifetime annotations:
```rust
fn first_word(s: &str) -> &str {
    let bytes = s.as_bytes();
    
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..1];
        }
    }
    
    &s[..]
}
```

Before Rust 1.0, the code would have required annotations to compile:
```rust
fn first_word<'a>(s: &'a str) -> &'a str { ... }
```

Over time, the same situations and patterns emerged,
and developers were able to program the patterns into the compiler
so that the borrow checker could infer the lifetimes.
These patterns are called the _lifetime elision rules_.

The rules do not provide full inference.
If there's still ambiguity, the compiler won't guess for you.

Lifetimes on function/method params are called _input lifetimes_.
Lifetimes on return values are called _output lifetimes_.

Rules:
1. Compiler assigns a different lifetime param per reference. First gets `'a`, next gets `'b`, and so on.
2. If there's only one input lifetime parameter, e.g. `'a`, that param is assigned to all output lifetime params.
3. If there are multiple input lifetime params, but one of them is `&self` or `&mut self` (i.e. this is a method), the lifetime of `self` is assigned to all output lifetime parameters.

These rules do a lot to help improve readability!

## Lifetime annotations in method definitions

We have to always declare the lifetime params after `impl` and then pass them to the struct's type.
```rust
impl<'a> ImportantExcerpt<'a> {
    fn level(&self) -> i32 {
        3
    }
}
```
The method signatures might be tied to the lifetime references of the struct's fields, or they might be independent (such as above).

In the above example, the first elision rule applies so we don't have to annotate the lifetime of `&self`. `i32` isn't a reference so we don't have to concern ourselves with this.

Here's an example where the third rule applies:
```rust
impl<'a> ImportantExcerpt<'a> {
    fn announce_and_return_part(&self, announcement: &str) -> &str {
        println!("Attention please: {announcement}");
        self.part
    }
}
```
There are two input lifetimes, so the first rule applies
but also so does the third because of `&self`.
So `&self` and `announcement` have different lifetimes (same length) but the return type gets the same lifetime as `&self`.
Now all lifetimes are accounted for!

## The Static Lifetime

`'static` is a special lifetime.
It denotes that the affected lifetime can live for the entire program.

All string literals have the `'static` lifetime.
They can be annotated as follows:
```rust
let s: &'static str = "I have a static lifetime.";
```

The text of the string is stored directly in the program's binary,
so that is always available.
Therefore, the lifetime of all string literals is `'static`.

Sometimes an error message may suggest using `'static` as a fix.
Before doing so, consider whether your ref truly lives for the entire program.
In many cases, the answer is to ignore this and use another fix.

## Generic Type Params, Trait Bounds, and Lifetimes together

Here's an example using all three!
```rust
use std::fmt::Display;

fn longest_with_an_announcement<'a, T>(
    x: &'a str,
    y: &'a str,
    ann: T,
) -> &'a str
where T: Display {
    println!("Announcement! {ann}");
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```
