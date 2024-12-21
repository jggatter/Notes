# Rust Smart Pointers - Running code on Cleanup with `Drop` trait
#rust #pointers #smartpointers #traits

The second trait important to the smart pointer pattern is `Drop`
`Drop` lets us customize what happens when a value is about to go out of scope.
It can be implemented on any type.
It is can be used to release resources like files or network connections.

With smart pointers, the `Drop` functionality is almost always the same.
E.g. when `Box<T>` is dropped it will deallocate the heap space it points to.

In some languages memory or resources must be explicitly freed.
If the developer forgets, the system might become overloaded and crash.
In Rust, compiler will insert the `Drop` code to clean up automatically.
We don't have to be careful about placing cleanup code everywhere!

When implementing `Drop`, we implement the `drop` method with `&mut self` param:
```rust
struct CustomerSmartPointer {
    data: String,
}

impl Drop for CustomSmartPointer {
    fn drop(&mut self) {
        println!("Dropping with data {}", self.data);
    }
}

fn main () {
    let c = CustomerSmartPointer {
        data: String::from("my stuff");
    };
    let d = CustomerSmartPointer {
        data: String::from("other stuff");
    };
}
```
When the instance goes out of scope, we print some text.
We don't need to call `drop` explicitly.
Variables are dropped in order of creation, so `d` is dropped before `c`.

## Dropping a value early with `std::mem::drop`

We cannot explicitly call a `drop` method since it will still be called automatically.
This would lead to a _double free_ error!

`std::mem::drop` can be used to explicitly drop a value before it goes out of scope.

