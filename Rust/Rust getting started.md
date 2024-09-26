#rust

## Install

On unix-like system:
````sh
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
````

You will also need a _linker_, which is a program that Rust uses to join its compiled outputs into one file. It is likely you already have one. If you get linker errors, you should install a C compiler, which will typically include a linker. A C compiler is also useful because some common Rust packages depend on C code and will need a C compiler.

On macOS, you can get a C compiler by running:

```console
$ xcode-select --install
```

Linux users should generally install GCC or Clang, according to their distribution’s documentation. For example, if you use Ubuntu, you can install the `build-essential` package.

## Update

As packages drop support for older software in the Rust toolchain, it can be a good idea to update to the latest versions:
```sh
rustup update
```

Then update any programs, e.g.
```sh
cargo install lsd
```

## Without `cargo`: `rustc`

Make project directory:
```sh
mkdir hello_world
cd hello_world
```

Enter code:
```rust
// The `main` function is special: it is always the first code that runs in every executable Rust program.
fn main() {
    println!("Hello, world!");
}
```

Compile:
```sh
rustc main.rs
```
Run:
```sh
./main
```

## `cargo`

Cargo is Rust’s build system and package manager.

Make project:
```sh
cargo new hello_cargo
cd hello_cargo
```

Cargo has generated two files and one directory for us: a _Cargo.toml_ file and a _src_ directory with a _main.rs_ file inside.
* *Cargo.toml*: This file is in the [_TOML_](https://toml.io) (_Tom’s Obvious, Minimal Language_) format, which is Cargo’s configuration format.
* Cargo expects your source files to live inside the _src_ directory. The top-level project directory is just for README files, license information, configuration files, and anything else not related to your code.
* It has also initialized a new Git repository along with a _.gitignore_ file. Git files won’t be generated if you run `cargo new` within an existing Git repository

Build:
```sh
# cd hello_cargo
cargo build
```

The build command also has created: _Cargo.lock_. This file keeps track of the exact versions of dependencies in your project. It's automatically managed.

Run:
```sh
./target/debug/hello_cargo
```

**(RECOMMENDED)** Compile and run:
```sh
cargo run
```
The `cargo run` command compiles and runs the code in one go

Check to compile but do not produce executable:
```sh
cargo check
```
Faster than `cargo build`

Compile with optimizations for an intended release:
```sh
cargo build --release
```