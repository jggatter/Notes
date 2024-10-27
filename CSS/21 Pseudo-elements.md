# CSS Pseudo-elements
#css #pseudo-elements #selectors #pseudo-classes #html 

A pseudo-element is used to style specific parts of an element.

Syntax (Notice the double-colon notation):
```css
selector::pseudo-element {
  property: value;
}
```
In previous versions of CSS (< 3) the single-colon notation could be used
for both pseudo-elements and -classes.
This backwards compatibility is maintained for older pseudo-elements.

## `::first-line` and `::first-letter`

Used to add special style to the first line of a text.

Example, formats the first line of the text in all `<p>` elements.
```css
p::first-line {
  color: #ff0000;
  font-variant: small-caps;
}
```

Likewise `::first-letter` can be used to select the first letter of a `<p>`

## Pseudo-elements and HTML classes

As pseudo-classes can be combined with HTML classes,
likewise can pseudo-elements with HTML classes:
```css
p.intro::first-letter {
  color: #ff0000;
  font-size: 200%;
}
```
Here we select the first letter of the paragraph with `class="intro"`.

## Multiple Pseudo-elements

Multiple pseudo-elements can be combined in separate declarations.
```css
p::first-letter {
  color: #ff0000;
  font-size: xx-large;
}
p::first-line {
  color: #0000ff;
  font-variant: small-caps;
}
```

## `::before` and `::after`

Can be used to insert content before the content of an element:
```css
h1::before {
  content: url(smiley.gif);
}
```
Similarly `::after` can be used to insert content after the content.

## `::marker`

Selects the markers of list items.
```css
::marker {
  color: red;
  font-size: 23px;
}
```

## `::selection`

Matches portion of element that is selected by a user.
Can apply `color`, `background`, `cursor`, and `outline` to it.
```css
::selection {
  color: red;
  background: yellow;
}
```

## `::backdrop`

Selects the backdrop, or space behind, a dialog element.

Style the background behind a dialog element.
```css
dialog::backdrop {
  background-color: lightgreen;
}
```
```html
<button id="dialogBtn">Show dialog</button>
<dialog id="myDialog">
  <form>
    <p>The background behind this dialog is a backdrop</p>
  </form>
</dialog>
<script>
const dialogBtn = document.getElementById('dialogBtn');
const dialog = document.getElementById('myDialog');

dialogBtn.addEventListener('click', () => myDialog.showModal());
</script>
```

## `::placeholder`

Selects the placeholder text of `<input>` or `<textarea>` elements.