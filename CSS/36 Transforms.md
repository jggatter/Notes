# CSS Transforms
#css #transforms #translate #scale #rotate #2d #3d #degrees

## 2D Transforms

`transform` allows moving, rotating, scaling, and skewing of elements in 2D.

### `translate()`

`translate()` moves an element from its current position 
to a new position as determined by adding the inputted X and Y lengths.
```css
div {
  transform: translate(50px, 100px); /* 50 pixels right, 100 down */
}
```
Negative values for X move left,
and negative values for Y move up.
Tip: (0, 0) coords are top-left. Positive values progress us thru the page.

`translateX` and `translateY` are individual functions for each axis.

### `rotate()`

Rotates an element clockwise/counter-clockwise according to inputted degree.
```css
div {
  transform: rotate(20deg); /* 20 degrees clockwise */
}
```
Negative values will rotate counter-clockwise.

### `scale()`, `scaleX()`, and `scaleY()`

`scale()` increases or decreases the size of an element
according to parameters given for width and height.

```css
div {
  transform: scale(2, 3); /* become 2 times wider, 3 times taller */
}
```
Floats are allow. E.g. `scale(0.5, 0.5)` would make half as wide and tall.

`scaleX()` increases or decreases the width only.
`scaleY()` increases or decreases the height only.

### `skew`, `skewX()` and `skewY()`

`skew()` skews an element along both X and Y axes by the given angles.
```css
div {
  transform: skew(20deg, 10deg); /* 20 x-axis, 100 y-axis */
}
```
Default values are 0.

`skewX()` skews an element along the X-axis by the given angle.
```css
div {
  transform: skewX(20deg); /* skew 20 degrees along x-axis */
}
```

`skewY()` skews an element along the Y-axis by the given angle.
```css
div {
  transform: skewY(20deg); /* skew 20 degrees along y-axis */
}
```

### `matrix()` method

The `matrix()` method combines all 2D transform methods into one.
```
matrix(scaleX(), skewY(), skewX(), scaleY(), translateX(), translateY())
```

## 3D Transforms

We can also transform elements in 3D.

We likewise use the `transform` property.

### `rotateX()`, `rotateY`, and `rotateZ`

Rotates an element around its x-axis for the given degree.
```css
div {
  transform: rotateX(150deg);
}
```

`rotateY()` does the same but on the y-axis.
`rotateZ()` does the same but on the z-axis.
`rotate3d()` is shorthand for all three.

### 3D counterparts of `scale`, `translate`, and `matrix`

Likewise, we can scale or translate objects along the Z axis.
These functions have Z axis functions and 3d shorthands.

matrix has a 3d counterpart

Does any of this make sense or is useful? Idk.

### Other stuff?

There are some other properties like 
- `perspective`: specifies perspective view for a 3D-transformed element
- `backface-visibility`: whether should be visible when not facing screen

There is also a `perspective()` method.
