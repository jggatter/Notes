# CSS Attribute Selectors
#css #selectors #attributes

We can style HTML elements that have specific attributes or attribute values.
Attribute selectors can be useful for styling forms without class or ID.

The `[attribute]` selector is used to select elements with specific attributes.
```css
a[target] { /* Select all <a> with `target` */
  background-color: yellow;
}
```

The `[attribute="value"]` selector can select elements with a specified
attribute and value
```css
a[target="_blank"] {
  background-color: yellow;
}
```

The `[attribute~="value"]` selector can select elements with an
attribute value containing the specified word:
```css
[title~="flower"] {
  border: 5px solid yellow
}
```
We'd match "summer flower" or "flower new".
It's a whole word matching, so no matches for "my-flower" or "flowers".

The `[attribute|="value"]` selector can select elements with the specified
attribute whose value can be _exactly_ the specified value, or 
the specified value followed by a hyphen.
```css
[class|="top"] {
  background: yellow;
}
```
The value has to be a whole word or followed by a hyphen and another word.
E.g. `top` or `top-text`.

The `[attribute^="value"]` selector selects element with the specified 
attribute whose value _starts with_ the specified value.
```css
[class^="top"] {
  background-color: yellow;
}
```
The value doesn't have to be a whole word.

The `[attribute$="value"]` selector selects elements with the specified
attribute whose value _ends with_ the specified value.
```css
[class$="test"] {
  background-color: yellow;
}
```
The value does not have to be a whole word.

The `[attribute*="value"]` selector selects elements whose attribute value
_contains_ the specified value.
```css
[class*="te"] {
  background-color: yellow;
}
```
The value does not have to be a whole word.
