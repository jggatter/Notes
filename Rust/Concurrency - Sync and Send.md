# Rust Concurrency: Extensible concurrency with `Sync` and `Send` Traits
#rust #concurrency #threads #traits

Most concurrency features of Rust are in the std library and not the language.

Two concurrency concepts are embedded in the language:
`std::marker` traits `Sync` and `Send`.

## Allowing transference of ownership between threads with `Send`

The `Send` marker trait indicates
that ownership of values of the implementing type
can be transferred between threads.

Almost every Rust type is `Send` with some exceptions such as `Rc<T>`.
If we cloned an `Rc<T>` and transferred the clone to another thread,
both threads might try and update the ref count at the same time.
`Arc<T>`, which is `Send`, should be used instead.

Any type composed entirely of `Send` types is marked as `Send` too.
Almost all primitives are `Send`, aside from raw pointers.

## Allowing access from multiple threads with `Sync`

`Sync` marker trait indicates it's safe for the implementing type to be referenced from multiple threads.
In other words, any type `T` is `Sync` if immutable ref `&T` is `Send`,
meaning the ref can be sent safely to another thread.

Similar to `Send`, primitive types are `Sync`,
and types composed entirely of `Sync` are also `Sync`.

`Rc<T>` is also not `Sync` (same reasons as why it's not `Send`).
`RefCell<T>` and its `Cell<T>` family are also not `Sync`.
The borrow checking it does at runtime isn't thread-safe.
`Mutex<T>` is `Sync` and can be used across threads.

## Implementing `Send` and `Sync` manually is unsafe

Because types made up of `Send`/`Sync` are automatically `Send`/`Sync`,
we don't have to manually implement those traits.

As marker traits, they don't have any methods to implement.
They're just useful for enforcing invariants related to concurrency.

Manually implementing these involves writing unsafe Rust code.
It requires careful thought to uphold safety guarantees.

