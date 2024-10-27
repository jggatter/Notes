# CSS Pseudo-classes
#css #pseudo-classes #selectors #anchors #inputs #html #class

A pseudo-class is used to define a special state of an element.

For example, it can be used to style:
- an element when a mouse cursor hovers over it 
- visited and unvisited links
- an element when it gets focus
- valid/invalid/required/optional form elements

Syntax:
```css
selector:pseudo-class {
  property: value;
}
```

## Anchor Pseudo-classes

Pseudo-classes for links can impact the styling:
```css
/* unvisited link */
a:link {
  color: #FF0000;
}

/* visited link */
a:visited {
  color: #FF0000;
}

/* mouse over link */
a:hover {
  color: #FF0000;
}

/* active link */
a:active {
  color: #FF0000;
}
```
Note the order above matters! 
- `a:hover` must come after `a:link` and `a:visited` to be effective!
- `a:active` must come after `a:hover` to be effective!

## Input pseudo-classes

When we click an input field, it gets focus.
`:focus` allows styling in this state.
```css
input:focus {
  background-color: yellow;
}
```

We can disable an input field, disallowing text entry:
```css
input:disabled {
  background-color: gray;
}
```
Or set it back to its default pseudo-class, `:enabled`.

Similarly we can set it to `:read-only` to keep text but disallow alteration

`:required` selects those that are `required`
`:checked` selects radio buttons or checkboxes that are already checked.
`:placeholder-shown` can select where the `placeholder` attribute is specified
`:out-of-range` can select where `type="number" and the `max` and `min` attributes are violated

## Pseudo-classes with HTML classes

Pseudo-classes can be combined with HTML classes.
When you hover over `<a class="highlight" href=...>` it will change color:
```css
a.highlight:hover {
  color: #ff0000;
}
```

## Hover

Example: paragraph descendants of div will be display when hovering over div
```css
p {
  display: none;
  background-color: yellow;
  padding: 20px;
}

div:hover p {
  display: block;
}
```


## First-child and last-child pseudo-classes

The `:first-child` pseudo-class matches a specified element that is first
child of another element.

```css
/* matches the first <p> of any element */
p:first-child {
  color: blue;
}
/* matches first <i> in all <p> */
p i:first-child {
  color: blue;
}
/* matches all <i> in first child <p> */
p:first-child i {
  color: blue;
}
```

The `:last-child` pseudo-class can do the opposite, selecting the last child.

## Language pseudo-class

`:lang` allows us to define special rules for different languages.
```css
q:lang(no) {
  quotes: "~" "~";
}
```
```html
<p>
  Some text:
  <q lang="no">A quote in a paragraph</q>
  Some text.
</p>
```
