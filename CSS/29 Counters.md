# CSS Counters
#css #counters #pseudo-elements #variables #lists #headers #html

Counters are "variables" maintained by CSS whose value can be incremented
by CSS rule (to track how many times they are used).

Counters let you adjust the appearance of content based on its 
placement within the document.

## Automatic numbering with Counters

To work with CSS counters, we will use the following properties:
- `counter-reset`: Creates or resets a counter
- `counter-increment`: Increment a counter value
- `content`: Inserts generated content
- `counter()` or `counters()` to add the value of a counter to an element

To use a counter, it must first be created with `counter-reset`.   

This example creates a counter for the page, then increments the value
for each `<h2>` and adds "Section <value of counter>:" to the start
of each `<h2>`:
```css
body {
  counter-reset: section;
}
h2::before {
  counter-increment: section;
  content: "Section " counter(section) ": ";
}
```
So we get automatic numbering of headers.


## Nesting Counters

The following creates one counter for the page (section) 
and one counter for each subsection.

```css
body {
  counter-reset: section;
}
h1 { 
  counter-reset: subsection;
}

h1::before {
  counter-increment: section;
  content: "Section " counter(section) ". ";
}

h2::before {
  counter-increment: subsection;
  content: counter(section) "." counter(subsection) " ";
}
```

A counter can also be used for numbering in nested lists
because a new instance is automatically created in each child element

Here we simply use one counter for the list `<ol>`:
```css
ol {
  counter-reset: section;
  list-style-type: none;
}
li::before {
  counter-increment: section;
  content: counters(section, ".") " ";
}
```
