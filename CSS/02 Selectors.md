# CSS Selectors
#css #selectors

Selectors are used to find or select the HTML elements you want to style.

We can divide selectors into 5 categories:
- Simple: select elements based on name, id, or class
- Combinator: select elements based on specific relationship between them
- Pseudo-class: select elements based on a certain state
- Pseudo-elements: select and style a part of an element
- Attribute selectors: select elements based on an attribute or value

## Simple selectors

### Element selector

Here we select all paragraphs based on name of the HTML `<p>` element:
```css
p {
    text-align: center;
    color: red;
}
```

### id selector

Uses id attribute of an HTML element to select specific elements:
```css
#para1 {
    test-align: center;
    color: red;
}
```
Selects:
```HTML
<p id="para1"></p>
```

_Note: id name cannot start with a number_

### class selector

Selects elements with specific class attribute.
Uses a dot `.` prefix followed by the class name.

```css
.center {
    text-align: center;
    color: red;
}
```

We can also specify that only `<p>` elements should be affected:
```css
p.center {
    text-align: center;
    color: red;
}
```

HTML elements can also refer to more than one class:
```css
<p class="center large">...</p>
```
Here this element will be styled according to class `"center"` and `"large"`.

_Note: class name cannot start with a number!_

### Universal selector

The universal selector `*` selects all HTML elements on the page.

```css
* {
    text-align: center;
    color: blue;
}
```

### Grouping selector

Selects all HTML elements with the same style definitions
```css
h1 {
    text-align: center;
    color: red;
}
h2 {
    text-align: center;
    color: red;
}
p {
    text-align: center;
    color: red;
}
```
We can consolidate this example as:
```css
h1, h2, p {
    text-align: center;
    color: red;
}
```