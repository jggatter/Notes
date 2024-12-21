# Rust Smart Pointers
#rust #pointers

Generally, a _pointer_ is a variable containing an address in memory
which points to some other data.

The most common kind of pointer in Rust is a reference,
which are indicated by the `&` symbol
and borrow the value they point to.
They don't have special capabilities other than referring to data,
and they have no overhead.

_Smart pointers_ are data structures that act like a pointer,
but also have additional metadata and capabilities.
The concept originated in C++ and exists in other languages.
Rust has a variety of smart pointers defined in the standard library.
These provide functionality beyond that of references.

For example, the _reference counting_ smart pointer type allows data
to have multiple owners by keeping track of the number of owners.
When no owners remain, the data is cleaned up.

Rust, with its concept of ownership and borrowing,
has an additional difference between references and smart pointers:
while references only borrow data,
in many cases, smart pointers _own_ the data they point to.

A few smart pointers include `String` and `Vec<T>`.
They own some memory and allow us to manipulate it.
They also have metadata and extra capabilities or guarantees.
For example, `String` stores its capacity as metadata,
and has the extra ability to ensure its data will always be valid UTF-8.

Smart pointers are usually implemented using structs.
Unlike an ordinary struct, they implement `Deref` and `Drop` traits.
`Deref` allows a smart pointer struct instance to behave like a reference,
allowing our code to work with either references or smart ponters.
`Drop` lets us customize clean-up behavior when a smart ptr goes out of scope.

Some of the most common smart pointers in the standard library:
- `Box<T>`: For allocating values on the heap.
- `Rc<T>`: A reference counting type enabling multiple ownership
- `Ref<T>` and `RefMut<T>`, accessed through `RefCell<T>`, a type that enforces borrowing rules at runtime instead of compile time.

Additionally discussed is the _interior mutability_ pattern:
where an immutable type exposes an API for mutating an interior value.

Likewise discussed is _reference cycles_:
how they can leak memory and how to prevent them.



