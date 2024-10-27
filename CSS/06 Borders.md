# CSS Borders
#css #border #width #color

Properties allow us to specify the element border's style, width, or color.

## `border-style`

What kind of border to display. Values:
- `dotted`
- `dashed`
- `solid`
- `double`
- `groove`: 3D grooved border
- `ridge`: 3D ridged border
- `inset`: 3D inset border
- `outset`: 3D outset border
- `none`: No border
- `hidden`: A hidden border

_Note: The 3D borders depend on the `border-color` value._

The `border-style` can accept a value for each border of the element,
The order is clockwise starting with the top border.
If only two arguments given, then the first is top and bottom,
and the latter is the sides.

Alternatively, individual `border-<side>-style` properties can be used 
to respectively define the style for a side. Example:
```css
p {
  border-top-style: dotted;
  border-right-style: solid;
  border-bottom-style: dotted;
  border-left-style: solid;
}
```

## `border-width`

The width of the borders.

The specific size in units, or one of three pre-defined values:
- `thin`
- `medium`
- `thick`

Likewise, can be up to four arguments for each border in clockwise order.
Shorthands for each side can be used.

## `border-color`

The color of the borders. If not set, it is inherited.

Likewise, can be up to four arguments for each border in clockwise order.
Shorthands for each side can be used.

## Rounding borders

Use `border-radius` to add rounded borders to an element.
```css
p {
  border: 2px solid navy;
  border-radius: 5px;
}
```
