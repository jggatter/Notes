# Rust Iterators
#rust #iterators #functional

Iterators are a way of processing a series of elements.
Along with closures, iterators are a functional programming pattern.

Iterators allows us to perform some task on a sequence of items in turn.
An iterator is responsible for the logic of iterating over elements,
and determining when the sequence has finished.
This saves us from having to implement this logic ourselves.

In Rust, iterators are _lazy_.
They have no effect until you call methods that consume the iterator.
```rust
let v1 = vec![1, 2, 3];
let v1_iter = v1.iter();
```
This code doesn't do anything but create the iterator.
We'd have to use a method, maybe with a loop, to iterate over elements.
Iterating over the elements consumes the iterator.
```rust
let v1 = vec![1, 2, 3];
let v1_iter = v1.iter();

for val in v1_iter {
    println!("Got: {val}");
}
```
## Iterator Trait and the `next` method

All iterators implement the `Iterator` trait from the standard library.
Its definition looks like:
```rust
pub trait Iterator {
    type Item;
    
    fn next(&mut self) -> Option<Self::Item>;

    // ... some methods with default implementations
}
```
Implementing an iterator requires that we also define an `Item` type.
The `Item` type is used in the return type of the `next` method,
i.e. the `Item` type will be the type returned from the iterator.

The trait only requires implementors to define the `next` method,
which returns a single item wrapped in `Some`.
When the iteration is over, `None` is returned.

Using `next` with an iterator requires that the iterator be mutable.
This is because `next` consumes the iterator.
With a `for` loop, the loop took ownership of the iterator and made it mutable behind the scenes.

Note that the values we get from calls to next are immutable.
`iter()` produces an iterator over immutable references.
If we want to take ownership and returned owned values, we'd use `into_iter()`.
If we wanted to iterate over mutable references, we can call `iter_mut()`.

## Methods that consume the iterator

The `Iterator` trait has a number of different methods with default implementations.

Any that use `next` will consume the iterator.
Some do by default, this is why you need to implement `next`.

Methods that call `next` are _consuming adapters_,
because calling them uses up the iterator.

Such methods that take ownership of the iterator and use it up
do not allow us to use the iterator further.

One example is `sum`.
Others are `fold` or `reduce` (see Range Expressions for example)

### `flatten` 

`flatten` can reduce an iterator of iterators/iterables by a single level:
```rust
let data = vec![vec![1, 2, 3, 4], vec![5, 6]];
let flattened = data.into_iter().flatten().collect::Vec<u8>>
assert_eq!(flattened, &[1, 2, 3, 4, 5, 6]);
```

It can also work on `Option` or `Result`,
filtering out `None` or `Err` before `collect`ing.

## Methods that produce other Iterators

_Iterator adapters_ are methods defined on the `Iterator` trait
that don't consume the iterator, instead producing a different iterator.

For example, `map` takes a closure to call on each item as we iterate.
`map` returns a new iterator that will produce the modified items.
```rust
let v1: Vec<i32> = vec![1, 2, 3];
v1.iter().map(|x| x + 1); // Lazy, not yet used.
```
We need to consume the iterator via `collect`, producing the modified items:
```rust
let v2: Vec<_> = v1.iter().map(|x| x + 1).collect();
```

### `flat_map`

One could `map` to produce an iterator per item,
then flatten:
```rust
let words = ["alpha", "beta", "gamma"];
let merged: String = words.iter()
                          .map(|s| s.chars())
                          .flatten()
                          .collect();
assert_eq!(merged, "alphabetagamma");
```

This mapping then flattening can be better expressed as `flat_map`:
```rust
let words = ["alpha", "beta", "gamma"];
let merged: String = words.iter()
                          .flat_map(|s| s.chars())
                          .collect();
assert_eq!(merged, "alphabetagamma");
```

It's best to think of `flat_map` as `map(f).flatten()`.
Alternatively, you can think of it compared to `map` alone:
`map`'s closure returns one _item_ for each element,
while `flat_map`'s closure returns an _iterator_ for each element.

## Notes on `collect`

Like some other functions in Rust, the compiler infers the behavior and return type of `collect` based on type annotations/subsequent usage. Otherwise the type can be explicitly specified: `collect::<...>()`.

Furthermore, if the return type is `Result`:
- If any elements are `Err(...)`, collect will return the first `Err` encountered.
- If all elements are `Ok(...)`, collect will return them as `Ok(Vec<T>)`.

## Using Closures that capture their environments

Many iterator adapters take closures as arguments.
Commonly, the closures we specify are those that "capture their environment":
using other variables from outside of the closure.
```rust
#[derive(PartialEq, Debug)]
struct Shoe {
    size: u32,
    style: String,
}

fn shoes_in_size(shoes: Vec<Shoe>, shoe_size: u32) -> Vec<Shoe> {
    shoes.into_iter().filter(|s| s.size == shoe_size).collect()
}
```
The `shoes_in_size` func takes ownership of a vector of shoes and a shoe size as params.
It returns a vector containing only shoes of the specified size.
`into_iter` takes ownership of the vector,
and `filter` adapts the iterator into a new iterator that only contains elements for which the closure returns `true`.

The closure captures `shoe_size` from the environment.
`collect` gathers the values returned by the adapted iterator into a vector.

## Range Expressions

Range expressions construct `Range` object variants.
These objects are essentially iterators.

Range expressions are constructed from a start and an end number.
The numbers must be positive.
An unspecified start is 0,
and an unspecified end will be the length of the collection.

`..` syntax entails an inclusive start and exclusive end,
e.g. `1..2` will start at 1 and stop before 2 (at 1).

`..=` syntax has an inclusive start _and_ inclusive end,
e.g. `1..=2` will start at 1 and stop at 2.

```rust
1..2;   // start from 1, stop before 2 at 1 // std::ops::Range
3..;    // start from 3, stop at end        // std::ops::RangeFrom
..4;    // start at 0, stop before 4 at 3   // std::ops::RangeTo
..;     // start from 0, go the full range  // std::ops::RangeFull
5..=6   // start from 5, stop at 6          // std::ops::RangeInclusive
..=7;   // start from 0, stop at 7          // std::ops::RangeToInclusive
```

We can use ranges as iterators.
```rust
// Factorial of num
let product = (2..num).fold(1, |acc, x| acc * x);
```

