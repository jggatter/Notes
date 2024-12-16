# Rust Traits
#rust #traits

A type's behavior consists of the methods we can call on that type.
Different types share the same behavior we can call the same methods on all of those types.

Trait definitions are a way to group method signatures together
to define a set of behaviors necessary to accomplish the same purpose.

## Defining and implementing traits

E.g. let's say we have `struct NewsArticle` and `struct Tweet` which hold text.
We can define `trait Summary` with `fn summarize` for both.

We define the trait:
```rust
pub trait Summary { // pub exposes trait to other crates
    fn summarize(&self) -> String;
}
```

We then use a separate `impl` block to implement the trait methods for each struct:
```rust
pub struct NewsArticle {
    pub headline: String;
    pub location: String;
    pub author: String;
    pub content: String;
}

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!(
            "{}, by {} ({})",
            self.headline,
            self.author,
            self.location,
        )
    }
}

pub struct Tweet {
    pub username: String,
    pub content: String,
    pub reply: String,
    pub retween: String,
}

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!(
            "{}: {}",
            self.username,
            self.content,
        )
    }
}
```

We can implement traits for existing types!
```rust
trait AppendBar {
    fn append_bar(self) -> Self;
}

impl AppendBar for String {
    // TODO: Implement `AppendBar` for the type `String`.
    fn append_bar(self) -> Self {
        self + "Bar"
    }
}
```

## Default implementations

We can have default behaviors for some or all methods in a trait.
This way we don't have to redundantly specify the same impl on every type.
The default behaviors can be overridden if desired.

```rust
pub trait Summary {
    fn summarize_author(&self) -> String

    fn summarize(&self) -> String {
        format!("(Read more from {}..."), self.summarize_author())
    }
}

impl Summary for NewsArticle {}

impl Summary for Tweet {
    fn summarize_author(&self) -> String {
        format!("@{}", self.username)
    }
}

let article = NewsArticle {
    headline: String::from("Penguins win the Stanley Cup!")
    // ...
}

println!("New article available! {}", article.summarize());
```

## Traits as Parameters

For the structs `NewsArticle` and `Tweet` which both implement `Summary`,
we could pass either of these types to a function using a trait.
We specify the `impl` keyword and the trait name,
allowing us to pass whatever implements this trait.
```rust
pub fn notify(item: &impl Summary) {
    println!("Breaking news! {}", item.summarize());
}

fn main {
    let tweet = Tweet {...};
    notify(&tweet);

    let news_article = NewsArticle {...};
    notify(&news_article);
}
```
In the body, we can call any functions that come from the `Summary` trait.

### Trait Bound Syntax

What is shown above is just syntactic sugar.
The longer form _trait bound_ syntax looks like:
```rust
pub fn notify<T: Summary>(item: &T) {
    println!("Breaking news! {}", item.summarize());
}
```
This is just more verbose, using a generic type that has been annotated with the trait.

In the event of multiple parameters, the generics versus `impl` syntax allow for different levels of control.
We could require that every parameter has to have the same type `T`,
or we can flexibly allow whatever type by using `impl`.

Here's another example where we use trait bound syntax in an `impl` block:
```rust
struct ReportCard<G> {
    grade: G,
    student_name: String,
    student_age: u8,
}

// We state G is a type that implements Display
impl<G: std::fmt::Display> ReportCard<G> {
    fn print(&self) -> String {
        format!(
            "{} ({}) - achieved a grade of {}",
            &self.student_name, &self.student_age, &self.grade,
        )
    }
}
```

### Requiring multiple traits

We can use `+` to require multiple traits to be implemented on a parameter:
```rust
pub fn notify(item: &(impl Summary + Display)) { ... }
```
```rust
pub fn notify<T: Summary + Display>(item: &T) { ... }
```

### Clearer Trait Bound with `where` clauses

Using too many tait bounds has its downsides.
When specifying too many can hurt readability.
```rust
fn some_func<T: Display + Clone, U: Clone + Debug>(t: &T, u: &U) -> i32 { ... }
```

For this scenario, Rust allows `where` clauses for cleaner code:
```rust
fn some_func<T, U>(t: &T, u: &U) -> i32 
where 
    T: Display + Clone,
    U: Debug + Clone,
{ ... }
```

### Using Trait Bounds to conditionally implement methods

We can conditionally implement methods for types with the specified traits
```rust
use std::fmt::Display;

struct Pair<T> {
    x: T,
    y: T,
}

// We implement this for all types
impl<T> Pair<T> {
    fn new(x: T, y: T) -> Self {
        Self { x, y }
    }
}

// We also implement this but only for types 
// where Display and PartialOrd are implemented
impl<T: Display + PartialOrd> Pair<T> {
    fn cmpl_display(&self) {
        if self.x >= self.y {
            println!("The largest member is x = {}", self.x);
        } else {
            println!("The largest member is y = {}", self.y);
        }
    }
}
```

#### Blanket implementations

We also can conditionally implement a trait for any type that implements specified traits.

This is from the standard library:
```rust
impl<T :Display> ToString for T {
    // ...
}
```
Allowing us to `let s = 3.to_string();`.

