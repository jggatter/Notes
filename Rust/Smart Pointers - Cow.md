# Rust Smart Pointers: "Clone on write" using `Cow`
#rust #pointers #smartpointers

`Cow` is not covered in the Rust book, but it definitely is in the docs.

`Cow` is a smart pointer that stands for "clone-on-write".
This functionality can enclose and provide immutable access to borrowed data,
and can lazily clone when mutation or ownership is required.
It helps us avoid cloning an object unless it's necessary.

It is designed to work with general and borrowed data via the `Borrow` trait.
It implements `Deref`, so we can call non-mutating methods directly on the data enclosed.
If mutation is desired, `to_mut` will obtain a mutable ref to an owned value,
cloning it if necessary.

Note: If we need ref-counting pointers, `Rc<T>` and `Arc<T>` have `::make_mut`,
which provides this clone-on-write functionality as well.

## Simple example

```rust
use std::borrow::Cow;

fn abs_all(input: &mut Cow<'_, [i32]>) {
    for i in 0..input.len() {
        let v = input[i];
        if v < 0 {
            // Clone into vector if not already owned
            input.to_mut()[i] = -v;
        }
    }
}

fn main() {
    // No clone occurs, `input` doesn't need to be mutated
    let slice = [0, 1, 2];
    let mut input = Cow::from(&slice[..]);
    abs_all(&mut input);

    // Clone occurs because `input` needs to be mutated
    let slice = [-1, 0, 1];
    let mut input = Cow::from(&slice[..]);
    abs_all(&mut input);

    // No clone occurs, `input` is already owned.
    let mut input = Cow::from(vec![-1, 0, 1]);
    abs_all(&mut input);
}
```

## Variants 

`Cow` is actually an enum that has two variants.
In the above example `from` creates either a `Borrow` or an `Owned` variant,
depending whether a value or reference is passed.

`Cow::Borrowed` represents a borrowed reference `&T`.
It is used when we do not need to mutate the value.
Instead of cloning it, we can just use a reference to the value.

`Cow::Owned` represents an owned value `T` (usually owned after cloning).
It is used when we need to mutate the value, which requires cloning (or creating an owned version if it was borrowed).
It allows us to modify the value later on without needing to worry about mutability of a borrowed reference.

See the experimental `is_borrowed` method as an example.
The method returns true if the data is borrowed,
i.e. if `to_mut` would require additional work.
```rust
#![feature(cow_is_borrowed)]
use std::borrow:Cow;

let cow = Cow::Borrowed("moo");
assert!(cow.is_borrowed());

let bull: Cow<'_, str> = Cow::Owned("MOO".to_string());
assert!( !cow.is_borrowed() );
```

See how both are used in this example of method `to_mut`.
The method acquires a mutable ref to the owned form of the data,
i.e. `to_mut` on `Cow<'_, B>` returns `&mut <B as ToOwned>::Owned`
It clones the data if it is not already owned.
```rust
use std::borrow::Cow;

let mut cow = Cow::Borrowed("foo"); // Cow<str> holds borrowed ref to "foo"
                                    // The type of cow is Cow::Borrowed(&str)

cow.to_mut().make_ascii_uppercase(); // clone val, change to Cow::Owned(String)
                                     // now holds String::from("foo")
                                     // (owned value needed for mutation).
                                     // make_ascii_uppercase modifies in-place.

assert_eq!(
    cow,
    Cow::Owned(String::from("FOO")) as Cow<'_, str>  // Cast ensures Cow<str>
);
```


