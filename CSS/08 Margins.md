# CSS Margins
#css #box-model #margin #width #height

Margins create space around elements, **outside** of any defined borders.

`margin` can be for each side in clockwise order starting from the top.
Or `margin-<side>` can define it for specific sides.

These properties can accept these values:
- `auto`: Browser centers horizontally within container after `width` considered
- The specific length in units `px`, `pt`, `cm`, etc.
- The percentage of the width of the containing element
- `inherit`: The margin should be inherited from the parent element

_Note: No negatives allowed._

## Margin collapse

Top and bottom margins of elements are sometimes collapsed into
whichever is largest.
This doesn't happen to left and right margins.
```css
h1 { margin: 0 0 50px 0; }
h2 { margin: 20px 0 0 0; }
```
The bottom of `h1` is 50 pixels whereas the top of `h2` is 20 pixels.
Common sense would suggest the vertical margin would be the sum of 70 pixels,
but due to margin collapse the actual margin is the larger, 50px.
