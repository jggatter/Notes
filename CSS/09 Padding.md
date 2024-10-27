# CSS Padding
#css #padding #box-model #width #height

Padding creates space around an element's content **inside** of any defined borders.

For properties, same thing as margins: either 
- `padding` with clockwise arguments
- or shorthands for each side.

Accepted values:
- The specific length
- The percentage of the width of the containing element
- `inherit` from the parent element

_Note: No negatives allowed._

## Padding and element width

The `width` property specifies the width of the element's content area.
The content area is the portion inside the padding, border, and margin.
See the box model.

If an element has a specified `width`, the `padding` will be added to the total.
This is often an undesirable gotcha moment.

`box-sizing` property can be used to maintain the element width despite padding.
Increasing padding will cause the available content space to decrease.
```css
div {
  width: 300px;
  padding: 25px;
  box-sizing: border-box;
}
```
