# Rust Macros
#rust #macros

_macro_ refers to a family of features which include:
- _declarative_ macros with `macro_rules!`
- three kinds of _procedural_ macros

The three kinds of procedural macros:
- Custom `#[derive]` macros that specify code added with the `derive` attr used on structs and enums
- Attribute-like macros that define custom attrs usable on any item
- Function-like macros that look like function calls but operate on tokens specified as their arguments.

## Difference between macros and functions

Fundamentally macros are a way of writing code that writes other code.
This is known as metaprogramming.

Examples:
The `derive` attribute generates an implementation of various traits for us.
The `println!` and `vec!` macros expand to produce more code than what we've written manually

Metaprogramming reduces the amount of code we have to write and maintain.
This is also one of the roles of functions,
however macros have some additional powers that functions do not.

A function signature must declare the number and type of params it has.
Macros can take a variable number of params.
E.g. `println!("hello")` and `println!("hello {}", name)`

Macros can also be expanded before the compiler interprets the code,
so for example, we can implement a trait on a given type.
A function cannot, since it's called at runtime while the trait is implemented at compile time.

The downside to implementing marcos instead of functions
is that macro definitions are more complex than function definitions;
we're writing Rust code that writes Rust code.
Macro definitions are generally more difficult to read, understand, and maintain.

We must define macros or bring them into scope before we call them in a file.
Functions, in contrast, can be defined anywhere and called anywhere.

## Declarative macros with `macro_rules!` for general metaprogramming

Declarative macros are the most widley used form of macros in Rust.
Known also as "macros by example", "`macro_rules!` macros", or simply "macros".

Declarative macros let us write something similar to a `match` expression.
Macros also compare a value to patterns associated with particular code.
In this situation, the value is actually the Rust source code passed!
The patterns are compared to the structure of the source code,
and code associated with the pattern, when matched,
replaces the code passed to the macro.
This all happens during compilation.

We define declarative macros using `macro_rules!`. Example for `vec!`:
```rust
let v: Vec<u32> = vec![1, 2, 3];
```
We could instead pass different numbers or types to `vec!`,
e.g. two integers or five string slices.
This wouldn't be possible with a function.

This is a simplified definition of `vec!`:
```rust
#[macro_export]
macro_rules! vec {
    ( $( $x:expr ), * ) => {
        {
            let mut temp_vec = Vec::new();
            $(
                temp_vec.push($x);
            )*
            temp_vec
        }
    };
}
```
`#[macro_export]` indicates the macro should be made available whenever the crate in which it's defined is brought into scope.
Without it, it cannot be brought into scope.

The macro def starts with `macro_rules!` and the name of the macro (no `!`).
Within the curly braces is the body of the definition.

The structure in the body is similar to that of a `match` expression.
Here we have one arm with the pattern `( $( $x:expr ), * )` followed by `=>`,
and the block of code associated with this pattern.
If the pattern matches, the associated block of code will be emitted.
There's only one pattern here, so only one valid way to match;
any other pattern will result in an error.
More complex macros will have more than one arm.

We use a set of parentheses to encompass the whole pattern.
We use a `$` to declare a variable in the macro system
that will contain the Rust code matching the pattern.
The `$` indicates it is a macro variabble as opposed to a regular Rust variable.

Next comes another set of parentheses that captures values 
that match the pattern within the parentheses
for use in the replacement code.
Within `$()` is `$x:expr` which matches and binds any Rust expr to expr `$x`.

The comma after `$()` indicates a literal comma separator could appear
after the code that matches the code in `$()`.
The `*` specifies the pattern matches zero or more of whatever precedes `*`.

In the example of `vec![1, 2, 3]`,
`$x` pattern matches three times with the expressions `1`, `2,` and `3`.

In the code body of the matching arm, we see `temp_vec.push($x);` within `$()*`.
This means this code is generated for each part that matches `$()` in the pattern zero or more times.
`$x` is replaced with each expression matched.
```rust
{
    let mut temp_vec = Vec::new()
    temp_vec.push(1);
    temp_vec.push(2);
    temp_vec.push(3);
    temp_vec
}
```

## Procedural macros for generating code from attributes

Procedural macros act more like a function (and is a type of procedure).
Rather than matching against patterns and replacing code as declarative macros,
they accept some code as input, operate on that code, and output some code.

The three kinds are:
- custom derive
- attribute-like
- function-like
These work in a similar fashion.

When creating procedural macros,
the definitions must reside in their own crate with a special crate type.
Rust hopes to eliminate this restriction in the future.

We use `proc_macro`, included in Rust, for creating a procedural macro.
We define a macro where `some_attribute` is a placeholder
for using a specific macro variety:
```rust
use proc_macro;

#[some_attribute]
pub fn some_name(input: TokenStream) -> TokenStream {
}
```
The function that defines the macro accepts a `TokenStream` and outputs one too.
The `TokenStream` type is defined by the `proc_macro` crate.
It represents a sequence of tokens.

The source code the macro is opeating on makes up the input `TokenStream`.
The code the macro produces is the output `TokenStream`.
The function also has an attribute to specify which procedural macro type.
We can have multiple kinds of procedural macros in the same crate.

### How to write a custom `derive` macro

We'll create a crate `hello_macro` defining trait `HelloMacro`.
`HelloMacro` has an associated function `hello_macro`.
We'll provide a procedural macro so users can `#[derive(HelloMacro)]`,
getting a default implementation of the function.
The default implementation will print "I'm TypeName" where "TypeName" is the name of the type on which the macro is defined

Example of use by a user:
```rust
use hello_macro::HelloMacro;
use hello_macro_derive::HelloMacro;

#[derive(HelloMacro)]
struct Pancakes;

fn main() {
    Pancakes::hello_macro();
}
```

First, we need to create a new library crate:
```sh
cargo new hello_macro --lib`.
```

Next we'll define `HelloMacro` trait and its associated function:
```rust
// in src/lib.rs
pub trait HelloMacro {
    fn hello_macro();
}
```

Due to Rust's restrictions we need to put the procedural macro in its own crate:
```sh
cargo new hello_macro_derive --lib
```
Since it's tightly related, we create it in the same dir as our other crate.

The two crates will need to be published separately.
We could make the `derive` crate a dependency of the first crate and re-export the procedural macro code.
However, we want users to be able to use the first crate without the `derive`.

`hello_macro_derive` needs to be declared as a procedural macro crate.
We make our Cargo.toml file:
```toml
[lib]
proc-macro = true

[dependencies]
syn = "2.0"
quote = "1.0"
```

We still need to define `impl_hello_macro`,
but here we start defining the procedural macro:
```rust
// hello_macro_derive/src/lib.rs
use proc_macro::TokenStream;
use quote::quote;

#[proc_macro_derive(HelloMacro)]
pub fn hello_macro_derive(input: TokenStream) -> TokenStream {
    // Construct representation of Rust code as syntax we can manipulate
    let ast = syn::parse(input).unwrap();

    // Build the trait implementation
    impl_hello_macro(&ast)
}
```
We parse the `TokenStream` as an abstract syntax tree using `syn::parse`,
and process it using `impl_hello_macro` (which is not yet defined).
Later, the `quote` crate  will turn `syn` data structures back into Rust code.
Notice we included `quote` and `syn` in the dependencies of our Cargo.toml.

When we parse our example `Pancakes` instance, we get:
```output
DeriveInput {
    // ...

    ident: Ident {
        ident: "Pancakes",
        span: #0 bytes(95..103)
    },
    data: Struct(
        DataStruct {
            struct_token: Struct,
            fields: Unit,
            semi_token: Some(
                Semi
            )
        }
    )
}
```
We have a unit struct with ident "Pancakes".

```rust
fn impl_hello_macro(ast: &syn::DeriveInput) -> TokenStream {
    let name = &ast.ident; // Ident
    let gen = quote! {
        impl HelloMacro for #name {
            fn hello_macro() {
                println!("I'm {}", stringify!(#name));
            }
        }
    }
    gen.into()
}
```
We get `Ident` containing the name of the annotated type, e.g. "Pancakes".
The `quote!` macro lets us define the Rust code we want to return.
`stringify!` built-in macro converts to a string literal `&str` at compile time.
We call `into` to convert to the expected return type, `TokenStream`.

`quote!` allows for some cool templating mechanics:
we can enter `#name` to replace the value with the variable `name`.
See its docs for more information.

`cargo build` should complete successfully for both crates.
Then we hook them up to a new project `cargo new pancakes`.
We add them as dependencies in the Cargo.toml.
If publishing to crates.io, they would be regular dpendencies.
If not, you can specify them as `path` dependencies:
```toml
hello_macro = { path = "../hello_macro" }
hello_macro_derive = { path = "../hello_macro/hello_macro_derive" }
```
We put our main code in src/main.rs and `cargo run`.

### Attribute-like macros

Attribute-like macros are similar to custom derive macros.
Instead of generating code for the `derive` attribute,
they allow you to create new attributes.
They're also more flexible: `derive` only works for structs and enums,
but attributes can be applied to other items as well, such as functions.

Say we have an attribute `route` that annotates a function like in a web app:
```rust
#[route(GET, "/")]
fn index() {
    // ...
}
```

The attribute is defined by the framework as a procedural macro.
The signature of the macro definition looks like this:
```rust
#[proc_macro_attribute]
pub fn route(attr: TokenStream, item: TokenStream) -> TokenStream {
    // ...
}
```
Here we have two params of type `TokenStream`.
First is for the first part, `GET, "/"`, the contents of the attribute.
Second is for the body of the item the attribute is attached to, `fn index() {}` and its body.

Apart from that, attribute-like macros work the same as custom derive macros:
You create a crate with the `proc-macro` type,
then you implement a function that generates the code you want.

### Function-like macros

Function-like macros define macros that look like function calls.

Similar to `macro_rules!` macros, they're more flexible than functions.
For example, they can take an unknown number of arguments.
However, `macro_rules!` macros can be defined only using `match`-like syntax.

As other procedural macros do, function-like macros take a `TokenStream` param
and manipulates that `TokenStream` using Rust code.

An example is `sql!`:
```rust
let sql = sql!(SELECT * FROM posts WHERE id=1);
```
This macro would parse the SQL statement, checking it is correct.
This is much more complex than what a `macro_rules!` macro can do.

The `sql!` macro would be defined as this:
```rust
#[proc_macro]
pub fn sql(input: TokenStream) -> TokenStream {
    // ...
}
```
Similar to a custom derive signature,
we receive the tokens inside the parentheses and return the code we want added.

