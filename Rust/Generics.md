# Rust Generics
#rust #generics

Generic data types are used to create definitions like function signatures or structs
which can then be used with many different concrete types

Example:
We can replace the following:
```rust
fn largest_i32(list: &[i32]) -> &i32 {
    ...
}

fn largest_char(list: &[char]) -> &char {
    ...
}
```
with a single function which uses a generic type `T`:
```rust
fn largest<T>(list: &[T]) -> &T {
   ...
}
```

In most cases, the compiler can infer the concrete types.
But sometimes the compiler needs to know more about the generic type.
We can use type definitions to give it more info:
```rust
type T = i16;

fn main() {
    let n1: u8 = 255;
    let n2: i8: 127;

    let mut numbers = Vec::<T>::new();
    // or
    //let mut numbers: Vec<T> =  Vec::new();
    // The i16 type could also be used directly instead of T

    numbers.push(n1.into());
    numbers.push(n2.into());
}
```
Here `.into()` converts the numbers to the type inferred by the compiler.
See `Into` trait for more info.

We can define structs that use generics:
```rust
struct Wrapper<T> {
    value: T,
}

impl<T> Wrapper<T> {
    fn new(value: T) -> Self {
        Wrapper { value }
    }
}

#[cfg(tests)]
mod tests {
    use super::;

    #[test]
    fn store_u32_in_wrapper {
        assert_eq!(Wrapper::new(42).value, 42);
    }

    #[test]
    fn store_str_in_wrapper {
        assert_eq!(Wrapper::new("Foo").value, "Foo");
    }
}
```
Notice that `impl` needs to define generics used so that we can feed this to the type of `Wrapper`.


