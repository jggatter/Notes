[Tutorial](https://linuxhandbook.com/awk-command-tutorial/)
## Predefined/Automatic Variables

AWK supports a few predefined and automatic variables to help you write your programs.

- `RS` - (Input) Record Separator character: the delimiter used to split input data into records to be processed one at a time. By default, this is the newline character, `\n`.
- `ORS` - Output Record Separator: the character used to join records for output. By default this is the newline character `\n`.
- `NR` - The current input record number.
- `FS` - (Input) Field Separator character: the delimiter used to split records into fields. By default, this is whitespace.
- `OFS` - Output Field Separator character: the character to use to join fields for output. Usually the same as `FS`. By default, this is whitespace.
- `NF` - Number of fields in the current record.

## Basic usage

AWK programs are made of one or many `pattern { action }` statements.

If for a given record (i.e. line, by default), the pattern evaluates to a non-zero value, i.e. "true", the commands in the corresponding _action_ block are executed.

Below you'll see the `1` constant is used to trigger the `print` action within the action block.

```bash
# Print all lines
awk '1 { print }' file
```

`{ print} ` is the default action, so the following is also equivalent:

```bash
awk 1 file
```

When a pattern is not specified, `1` is assumed! So, this is also equivalent:

```bash
awk file
```

### Remove a file header

```bash
awk 'NR>1' file
# equivalent to
awk 'NR>1 { print }' file
```

### Print lines within a range

```bash
# Prints line 4 from output of grep of file
grep "hello" file | awk 'NR==4'

# Prints lines 2 and 3 from file
awk 'NR>1 && NR < 4' file
```

### Remove whitespace-only lines

```bash
awk 'NF' file
```

Since `FS` is one or several whitespace characters (i.e. spaces, tabs, etc.), any record containing at least one non-zero whitespace character will contain at least one field.

In other words, the only case where `NF` is 0 ("false") is when the record contains only whitespace.

### Remove blank lines

In POSIX terminology, a blank line is a completely empty line. Lines that contain only whitespace aren't blank.

```bash
awk '1' RS='' file
```

Based on an obscure POSIX rule that specifies if the `RS` is set to the empty string, then the records are separated by sequences consisting of a newline plus one or more blank lines.

### Extracting fields

`$0` is the entire record.
`$1`, `$2`, and so on refer to the 1st, 2nd and so on field values

```bash
# Print first and third fields for each line, delimit by comma
awk '{ print $1, $3}' FS=, OFS=, file
```

Here we explicitly set the input and output separators to the `,` character. Another option would have been to use a `BEGIN` block within the the program.

```bash
awk 'BEGIN { FS=OFS="," } NF { print $1, $3 }' file
```

You may also use `END` blocks to perform some tasks after the last record has been read.

## Performing calculations column-wise

AWK supports the standard arithmetical operators. It will convert values between text and numbers automatically depending on the context. Also, you can use your own variables to store intermediate values.

Variables do not need to be declared before usage. An undefined variable is assumed to hold an empty string or equivalently, the number 0.

```bash
# Aggregate field 1 and use the END block to print it in the end
awk '{ SUM=SUM+$1 } END { print SUM }' FS=, OFS=, file

# Equivalently we can use += operator
awk '{ SUM+=$1 } END { print SUM }' FS=, OFS=, file
```


### Counting the number of non-empty lines

```bash
# Regular expression pattern matching via `//`
# We match the pattern `.` aka at least one character
awk '/./ { COUNT+=1 } END { print COUNT }' file
```

The result is only correct here if you define an empty line as POSIX does. If you wanted to also consider whitespace-only lines as empty:

```bash
awk 'NF { COUNT+=1 } END { print COUNT }' file
```

If we only wanted to count lines that contain data, i.e. no headers, blank lines, whitespace-only, we can use the unary `+` operator to force the evaluation of the first field as a number:
```bash
awk '+$1 { COUNT+=1 } END { print COUNT }' file
```

The non-data records contain text or nothing which convert to 0 in a numerical context.

## Arrays

All arrays in AWK are _associative_ arrays, so they allow associating an arbitrary string with another value. In other programming languages these may be known as dictionaries, maps, hashes, or associative tables.

A simple example:

```bash
awk '+$1 { CREDITS[$3]+=$1 }
     END {for (NAME in CREDITS) print NAME, CREDITS[NAME] }' FS=, file
```

## Identifying duplicate lines

Arrays, just like other AWK variables, can be used both in action blocks as well as in patterns.

Taking benefit of that, we can write a command to print only duplicate lines:
```bash
awk 'a[$0]++' file
```

The `++` operator is the post-increment operator. It increments a variable by 1, but only after its value has been taken for evaluation by the englobing expression

So `a[$0]` is evaluated to see whether the record will be printed, and in any case, the array entry is incremented.

The first time a record is read, `a[$0]` is undefined, and thus equivalent to 0, so it is not written but its value is incremented to 1.

Later when an equivalent record is read, the value is 1 so it will be written. The array entry is updated from 1 to 2.

### Removing duplicate lines

```bash
awk '!awk[$0]++' file
```

The logical not operator `!` reverses the truth value of the expression. It has no bearing on the `++` operator.

## Field and record separator magic

### Changing `FS` and `OFS`

Here we set the input field separator as a comma and the output as a semi-colon. Since AWK does not change the output record as long as you did not change a field, we use the `$1=$1` trick to force the program to break up the record and reassemble it using the `OFS`.

```bash
# Note: ; has to be quoted to avoid the shell from interpreting it its own way.
awk '$1=$1' FS=, OFS=';' file
```

Empty lines also get removed by this due to the fact that empty strings are "false". The `$1=$1` expression alters the reference to the first field, but it's still an expression. When it evaluates to false it won't execute the action.

We can do this for all lines:
```bash
# Note: `||` is logical OR
awk '($1=$1) || 1 { print }' FS=, OFS=';' file
```

### Removing multiple spaces

By leaving the `FS` and `OFS` as default values, only a single space will be used to delimit fields within a record.

```bash
awk '$1=$1' file
```

### Joining lines using `ORS`

We will use `ORS` to specify the output record separator.

```bash
awk '{ print $3 }' FS=, ORS=' ' file; echo
```

Now our output records will appear delimited by single spaces instead of newlines.

This example doesn't discard whitespace-only lines. You may want to use regex for this.
```bash
awk '/[^[:space:]]/ { print $3 }' FS=, ORS=' ' file; echo
```

## Field formatting

Using the `printf` function, we can produce a fixed-width tabular output. The function accepts an optional width parameter.

```bash
awk '+$1 { printf("%10s | %4d\n",  $3, $1) }' FS=, file
```

`%10s` formats the string with padding for up to 10 characters. Likewise, `%4d` pads the number for display up to 4 digits.

We can pad with zeroes instead:
```bash
awk '+$1 { printf("%-10s | %04d\n",  $3, $1) }' FS=, file
```

### Dealing with floating point numbers

With `%f` format, you almost always want to explicitly set the field width and precision of the displayed result for the sake of brevity:
```bash
awk '+$1 { SUM+=$1; NUM+=1 } END { printf("AVG=%6.1f",SUM/NUM); }' FS=, file
```

Here the field width is 6, padded with spaces. The `.1` precision means that we want to display the number with 1 decimal number after the dot.

## Using string functions

We can use other functions than just `printf`!

The `gawk` implementation of AWK tends to have a richer set of internal functions at the cost of lower portability.

Still, with `awk` we have a few POSIX-defined functions.

### Converting to uppercase

```bash
awk '$3 { print toupper($0); }' file
```

### Extracting a substring

```bash
awk '{ $3 = toupper(substr($3,1,1)) substr($3,2) } $3' FS=, OFS=, file
```

`substr` accepts the initial string, the one-based index of the first character to extract and optionally the number of characters to extract. If the last argument is not specified, it will extract all characters following the initial position.

### Splitting a field into multiple fields
```bash
awk '+$1 { split($2, DATE, " "); print $1,$3, DATE[2], DATE[3] }' FS=, OFS=, file
```

`split` accepts the field, a new array reference to which the output will be bound, and the delimiter by which to split the field. The delimiter can be a regex pattern:

```bash
awk '+$1 { split($4, GRP, /:+/); print $3, GRP[1], GRP[2] }' FS=, file
```

### Searching and replacing

Instead of piping to `sed`to do a global substitution (i.e. `s///g`), we can use the `gsub` function.
`
```bash
awk '+$1 { gsub(/ +/, "-", $2); print }' FS=, file
```

`gsub` accepts a regular expression for pattern matching, a replacement string. and the variable containing the text to be modified in-place. If no variable is given, it will assume the entire record `$0`.

## Transforming a CSV

Transform the first two columns of a csv:
```bash
awk -F, 'NR==1{split($0,a);next} NR==2{split($0,b);next} {for(i=1;i<=NF;i++) print a[i]"\t"b[i]}' Model.csv
```