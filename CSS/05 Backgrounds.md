# CSS Backgrounds
#css #background #colors #images

Background properties are used to add background effects for elements.

## `background-color`

See Colors section for more detail.

Can be set for any HTML element!

The `opacity` property can be additionally specified as an alpha channel value.
Note that all child elements will inherit it, possibly making text hard to read.

## `background-image`

Specifies an image to use as the background of an element.

```css
body {
  background-image: url("paper.gif");
}
```

It can also be set for specific elements like `<p>`.

By default, the image is repeated to cover the entire element,
both horizontally and vertically.
`background-repeat` can control this behavior:
```css
body {
  background-image: url("paper.gif");
  background-repeat: no-repeat; /* or repeat-x or repeat-y */
  background-position: right top;
}
```
`background-position` can control the position of the background image.

`background-attachment` can control whether the image should
should `scroll` or be `fixed` with the rest of the page.


## `background`

The `background` shorthand property can combine these as a single declaration.
```css
body {
  background: #ffffff url("img_tree.png") no-repeat right top;
}
```
This is kinda ugly though.
