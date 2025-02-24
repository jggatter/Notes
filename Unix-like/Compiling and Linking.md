# Compiling and Linking
#unix #linux #c #go

## Compiling

Compilation converts source files (`.c`) into machine code (`.o`) files (objects).
```bash
gcc -c main.c foo.c bar.c
```
Generates `main.o`, `foo.o`, and `bar.o`.

Technically the phases of compiling are:

Preprocessor converts source (`.c`) to preprocessed file (`.i`)
Compiler converts preprocessed file (`.i`) to assembly code (`.s`).
Assembler converts assembly to object code (`.o`) 

Then linking happens, where compiled binary objects (`.o`, `so`, `.a`)
are combined to produce an executable.

### Header files

Header files (`.h`) in C and C++ contain declarations of
functions, macros, types, and global variables.

They do not contain the actual implementations of functions,
which are in `.c`/`.so` files,
but they tell the compiler how to use those functions.

The compiler needs function prototypes and type info before linking.
Specifically it needs:
- The function name
- The parameters and the return type

For example,
```c
#include <stdio.h>

int main() {
    printf("Hello world!\n"); // Where is printf() defined?
    return 0;
}
```
The function `printf` is defined in compiled library `libc.so`.
But the compiler doesn't know what `printf` looks like without a declaration!
The declaration is found in the header file, `<stdio.h>`:
```c
int printf(const char *format, ...);
```
Without it, the compiler would not know how to generate the correct machine code.

This allows for a separation of compiling and linking.
Compiler sees only reads source code, `c` and `.h` files,
not binary `.so`/`.o`/`.a` files.

To compile a program that uses a 3rd party library,
we must include the library's header files:
```bash
gcc -Iinclude -c main.c main.o
```
This includes a directory `include/` where the library headers are located.

And then we can link the object and the library to produce an executable:
```bash
gcc main.o -Llib -ltiledb -o myprogram
```

Alternatively, both compile and link in one command:
```bash
gcc -Iinclude -Llib -ltiledb -o myprogram main.c
```

## Linking 

Linking combines objects and resolves function calls 
to generate a single executable or shared library.

`gcc` does linking via `ld`, the GNU link editor.
It resolves symbols across different object files and libraries,
it merges multiple objects into a single executable or library,
it also determines where code and data will be placed in memory.

Linking happens in two main forms: static and dynamic.

### Static linking 

Static linking takes all necessary code from libraries
and copies it into a final, self-contained executable at _compile_ time.

Example where multiple object files are copied into an executable.
```bash
gcc main.o foo.o bar.o -o myprogram
```

Another example pulling from an object file and a static library:
```bash
gcc main.c libmylib.a -o myprogram
```
`libmylib.a` is a static library,
and all required functions are embedded in `myprogram`.

### Dynamic linking

Dynamic linking does not copy code from libraries,
but rather the executable only references the necessary functions,
which are then loaded from a shared object at runtime.

Example of dynamic linking:
```bash
gcc main.c -L. -lmylib -o myprogram
```
Dynamically links `myprogram` to `libmylib.so`,
which must be present at runtime.

Explanation:
- `gcc` does dynamic linking by default
- `main.c` is compiled _and_ linked in this one command to `myprogram`
- `-L.` indicates the compiled library is in the current directory
- `-l<libr>` searches for a library named `lib<libr>.so` or `lib<libr>.a`

#### Loading

Loading, as mentioned, happens only for dynamic linked executables,
When the executable runs, the dynamic linker aka loader `ld.so` 
finds and loads required `.so` libraries into memory.

`LD_LIBRARY_PATH` can be set to allow temporary location of a library:
```bash
export LD_LIBRARY_PATH=$PWD/lib:$LD_LIBRARY_PATH
./myprogram
```

Alternatively, `rpath` can be used to embed the library path in the executable:
```bash
gcc main.o -Llib -ltiledb -Wl,-rpath,$PWD/lib -o myprogram
```
Now `myprogram` always finds `libtiledb.so` in `lib/`.
This is recommended for  non-system installs.

Alternatively, we can install a library system-wide.
```bash
sudo cp lib/libtiledb.so* /usr/local/lib/
sudo ldconfig
```
This permanently registers `libtiledb.so` system-wide,
no longer requiring us to modify `LD_LIBRARY_PATH`.

## Libraries

Object (`.o`) files can be bundled to create a library.

Instead of incuding individual object files everytime we compile a program,
we can bundle them in a library for easier and more efficient linking.

When the libraries are created,
the `.o` files are not consumed, but are no longer needed.

### Static Libraries

A static library (`.a` file) is a collection of object files (`.o` files)
that are linked into an executable at _compile_ time.

The linker copies the relevant functions from the static library
directly into the executable,
increasing the size of the binary.

Once the executable is built, it does not depend on the static library anymore.

The extension on Unix-like systems is typically `.a`, which stands for "archive".
E.g. The C math library is `libm.a`.

#### Example

Creating:
```bash
# Compile source files into object files
gcc -c foo.c bar.c 

# Archive object files into a static library
ar rcs libmylib.a foo.o bar.o
```

Linking:
```bash
gcc -o myprogram myprogram.c -L. -lmylib
```

### Shared Objects

A shared object (`.so` file) aka shared library
is dynamically linked to an executable at _runtime_.

The executable only contains references to functions in the shared library,
and the actual function implementations remain in the shared object file.

The shared object is typically found in standard locations
like `/lib`, `/usr/lib`, or specified by env variables like `LD_LIBRARY_PATH`.

A common example is the GNU C Library, `libc.so`.

#### Example

Creating:
```bash
gcc -fPIC -c foo.c bar.c
gcc -shared -o libmylib.so foo.o bar.o
```
Note: Position-independent code (PIC)
makes generate machine code independent of being located at specific address.

Linking
```bash
gcc -o myprogram myprogram.c -L. -lmylib

# Ensure the loader finds it by appending pwd to LD_LIBRARY_PATH
export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
```

### Pros and cons of static libraries vs. shared objects

Static libraries execute faster since there is no runtime lookup for symbols.

The executable is self-contained and doesn't require dependencies at runtime.

However, the executable size is large
due to embedding all library code as opposed to references.

Furthermore, updating a static library requires recompiling all dependent programs.

Shared objects do not require recompiling all programs 
(as long as they remain compatible).
There can be potential version mismatches if a shared library
is updated in an incompatible way (ABI changes).

Shared objects can also be shared by multiple running programs!
This reduces memory usage.

## CGO

Cgo enables the creation of Go packages that call C code.

We can set environment variables
to locate C headers for compilation and the library for linking. 
```bash
export LD_LIBRARY_PATH=$PWD/lib:$LD_LIBRARY_PATH
export CGO_CFLAGS="-I$PWD/include"
export CGO_LDFLAGS="-L$PWD/lib -ltiledb"

go build github.com/jggatter/myprogram
```
