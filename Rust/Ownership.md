# Rust ownership
#rust #ownership #references

## Ownership for method chaining
    
Consider method chaining with taking ownership of the object:
```rust
trait AppendBar {
    fn append_bar(self) -> Self
}
impl AppendBar for Vec<String> {
    fn append_bar(mut self) -> Self {
        self.push(String::from("Bar"));
        self
    }
}

fn main {
    let mut vec = vec![String::from("Foo")].append_bar().append_bar();
}
```
versus borrowing the object:
```rust
trait AppendBar {
    fn append_bar(&mut self) -> &mut Self
}
impl AppendBar for Vec<String> {
    fn append_bar(&mut self) -> &mut Self {
        self.push(String::from("Bar"));
        self
    }
}

fn main {
    let mut vec = vec![String::from("Foo")].append_bar().append_bar();
}
```

Taking ownership of the object means consuming the original instance,
copying the entire object into the method.
The modified object is returned.

Implications:
For large objects, moving could involve a deep copy of the entire buffer
unless the compiler can optimize it.
If new instances or internal re-allocations are performed within method,
they may add overhead.
The caller loses ownership for the duration of the method.
Efficient for chaning when ownership transference is desired (consuming original and returning new transformed version).
Fine when object is small (e.g. primitives or small structs)
Fine when ownership transfer is required (object no longer needed afterward) or (when chaining) desired.

Borrowing the object modifies the vector in-place using the mutable reference,
returning a mutable reference to the same vector.

Implications:
Avoid object copying as object modified directly -> typically faster and more memory efficient.
However, this can introduce lifetime constraints because the object is borrowed.
So, the caller must ensure it maintains the reference correctly!
Good when object is large or expensive to move (collections like HashMap or Vec)
When we want inplace mutation without transferring ownership.
When we want to chain multiple modifications without creating new instances.

| **Aspect**               | **`mut self -> Self`**                  | **`&mut self -> &mut Self`**           |
|--------------------------|-----------------------------------------|----------------------------------------|
| **Memory Usage**         | Higher (due to ownership transfer)      | Lower (in-place modification)          |
| **Allocation Overhead**  | Potentially higher                      | Minimal                                |
| **Efficiency for Large Data** | Less efficient                       | More efficient                         |
| **Method Chaining**       | Possible                               | Possible                               |
| **Borrowing Complexity** | Simplified (no lifetimes)               | Lifetimes can add complexity           |
