# Rust Conversions
#rust #conversion #casting #coercion

We can change a type from one type to another using a variety of different techniques.

## Casting

We can use the `as` keyword to _cast_ the value.
```rust
fn average(values: &[f64]) -> f64 {
    let total = values.iter().sum::<f64>();
    // TODO: Make a conversion before dividing.
    total / values.len() as f64
}
```
Here we cast the `values.len()` of type `usize` to `f64`.

## Coercions

We can also coerce values.

## `ToString` and `fmt::Display`

To convert any type to a `String`, we simply implement `ToString`.
Rather than do so directly, we should implement `fmt::Display`,
which automatically provides `ToString` and allows printing the type.

## `From` and `Into`

The `From` trait is used for value-to-value conversion.

If `From` is implemented, `Into` is automatically implemented as well.
This allows us to convert using the `from` function or `into` method.
`Into` will call into the `From` implementation.
Note that implementing `Into` does not automatically implement `From`.

Example:
```rust
#[derive(Debug)]
struct Person {
    name: String,
    age: u8,
}

// ... implementations ...

fn main() {
    // Use the `from` function.
    let p1 = Person::from("Mark,20");
    println!("{p1:?}");

    // Since `From` is implemented for Person, we are able to use `Into`.
    let p2: Person = "Gerald,70".into();
    println!("{p2:?}");
}
```

The `From` trait implementation:
```rust
// Note: Default is a trait that was implemented to afford `default`.
impl From<&str> for Person {
    fn from(s: &str) -> Self {
        let elements: Vec<&str> = s.split(',').collect();
        if elements.len() != 2 {
            return Self::default()
        }

        let name = elements[0];
        if name.is_empty() {
            return Self::default();
        }

        let Ok(age) = elements[1].parse() else {
            return Self::default();
        };

        Self {
            name: name.into(), // Coincidentally we use &str into()
            age,
        }
    }
}
```

## `TryFrom` and `TryInto` and `FromStr`

The `TryFrom` and `TryInto` traits are similar to `From` and `Into`.
`try_from` and `try_into` are the functions to implement.
They're used for fallible conversions, thus they return `Result`s.

The `FromStr` trait is similar, letting us use `from_str` to convert from `str`.
It is used implicitly by `str`'s `parse` to convert to the implementing type.
It notably returns `Result<Self, E>` for handling any parsing errors.

## Converting Errors

`.map_err` can be used to convert a `Result<T, E>`
to a different `Err` by applying a function, resulting in `Result<T, F>`.
```rust
// Note: ParseInt accepts an argument, here the original error
let age = age.parse().map_err(ParsePersonError::ParseInt)?;
```

## `AsRef` and `AsMut`

`AsRef` and `AsMut` allow for cheap reference-to-reference conversions.
By "cheap" we mean it costs essentially nothing computationally to pass and convert a reference,
in constrast to the data conversions done and ownership taken by `From`/`Into`.

They allow us convert generic ref inputs to a concrete ref type to work with:
```rust
fn byte_counter<T: AsRef<str>>(arg: T) -> usize {
    arg.as_ref().len()
}
```
We use trait-bound syntax to require the reference type has the `AsRef` trait,
and we specifically require it to be able to convert to a `str` reference.

We do the same thing here but for `AsMut` to convert a mutable reference.
```rust
fn num_sq<T: AsMut<u32>>(arg: &mut T) {
    let arg = arg.as_mut();
    *arg *= *arg;
}
```

We can also use them generally change the behavior of passing a ref type.
Example where we want a `Moderator` to work with funcs that accept `User`:
```rust
// https://stackoverflow.com/a/66029109
// ...

#[derive(Default)]
struct Moderator {
    user: User, // Moderator is composed of an underyling User
    privileges: Vec<Privilege>,
}

impl AsRef<User> for Moderator {
    fn as_ref(&self) -> &User {
        &self.user
    }
}

fn takes_user(user: &User) {}

fn main() {
    let user = User::default();
    let moderator = Moderator::default();

    takes_user(&user);
    takes_user(&moderator); // Instead of needing to pass &moderator.user
}
```

