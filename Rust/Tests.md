# Rust Tests
#rust #tests #unittests

## Anatomy

A test in Rust is a function that's annotated with the `test` attribute.
Attributes are metadata about pieces of Rust code (e.g. `derive` with structs)

To change a function into a test function, add `#[test]` on the line before the `fn` definition.

`cargo test` command can be used to run tests.
Rust builds a test runner binary that runs the annotated functions.
It reports on whether each test function passes or fails.

Cargo automatically generates a test module containing a test function.
This gives us a template for writing tests.

Example
```bash
cargo new adder --lib  # Create library 'adder' project
cd adder
```
The contents of src/lib.rs:
```rust
pub fn add(left: usize, right: usize) -> usize {
    left + right;
}

#[cfg(test)]
mod tests {
    use super::*; // Use everything from out outer module!

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
```

`assert_eq!` and `assert!` are macros that evaluate the assertion,
passing if the assertion is `true` and panicking if it is`false`.
You could also `panic!` to cause a test failure.

`assert!` accepts a single value arg which evaluates to a boolean.
`assert_eq!` accepts two value args and tests their equality.
`assert_ne!` accepts two value args and tests their inequality.
For the latter two, the args must implement `PartialEq` and `Debug` traits.
Usually this is as straight forward as annotating `#[derive(PartialEq, Debug)]` on the struct or enum definition.

The marcos can also accept an optional custom failure message as an optional arg.
Any args specified afterward are passed to the `format!` macro.
```rust
#[test]
fn greeting_contains_name() {
    let result = greeting("Carol");
    assert!(
        result.contains("Carol"),
        "Greeting did not contain name, value was `{result}`"
    )
}
```

## Checking for Panics with `should_panic`

If we want a test to panic, we can annotate with `#[should_panic]`.
```rust
#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    #[should_panic]
    fn greater_than_100() {
        Guess::new(200);
    }
}
```

We could feed an optional `expected` parameter to `should_panic`.
This would make the panicking more precise, ensuring that the failure message contains the `expected` substring.
```rust
impl Guess {
    pub fn new(value: i32) -> Guess {
        if value < 1 {
            panic!(
                "Must be greater than or equal to 1, got {value}."
            );
        } else if value > 100 {
            panic!(
                "Must be less than or equal to 100, got {value}."
            );
        }
        
        Guess { value }
    }
}

#[cfg(tests)]
mod tests {
    use super::*;

    #[test]
    #[should_panic(expected = "less than or equal to 100")]
    fn greater_than_100() {
        Guess::new(200);       
    }
}
```
Running this test will evoke the expected failure message, and will pass.

## Using `Result<T, E>` in Tests

We can return a `Result`, `Ok` or `Err`, instead of panicking.
This will also let us use the `?` operator to early return an `Err`.

Such tests will do not allow annotation with `#[should_panic]`.
If we want to test for an `Err`, we would not use the `?` operator,
but rather use `assert!(value.is_err())`.

