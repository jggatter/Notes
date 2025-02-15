# CSS Variables aka Custom Properties
#css #variables #customproperties

The `var()` function is used to insert values of a CSS variable.

CSS variables have access to the DOM,
which means that you can create variables with local or global scope,
change the variables with JavaScript,
and change the variables based on media queries.

Reusing colors across a design is a common use of CSS variables.

## Syntax

The `var()` function is used to insert value of a CSS variable.

The syntax of `var()` function is as follows:
```css
var(--name, value)
```
where `name` (required) is the variable name,
and `value` (optional) is the fallback value used if the variable is not found.

_Note: The name is case-sensitive and must start with two dashes `--`._

## How `var()` works

First of all: CSS variables can have a global or local scope.

Global variables can be accessed/used through the entire document.
Local variables can only be used inside the selector where it is declared.

To create a variable with global scope, declare it inside the `:root` selector.
The `:root` selector matches the document's root element.

To create a variable with local scope,
declare it inside the selector that is going to use it

For example, we declare two global variables, `--blue` and `--white`.
Then we use `var()` to insert the variables later in the style sheet.
```css
:root {
  --blue: #1e90ff;
  --white: #ffffff;
}

body {
  background-color: var(--white);
}

h2 {
  border-bottom: 2px solid var(--blue);
}
```

## Advantages of using `var()`

- Makes the code easier  to read (more understandable)
- Makes it much easier to tweak color values

## Overriding global variables with local variables

Sometimes we want variables to change only in a specific section of the page.

Assume we want a different color of blue for button elements.
We re-declare `--blue` inside the button selector.

```css
:root {
  --blue: #1e90ff;
  --white: #ffffff;
}

body {
  background-color: var(--white);
}

h2 {
  border-bottom: 2px solid var(--blue);
}

button {
  --blue: #0000ff; /* local var overrides global var */
  background-color: var(--white);
  color: var(--blue);
  border: 1px solid var(--blue);
  padding: 5px;
}
```

Alternatively, we could have also declared a local var by a different name,
such as `--button-blue`.
