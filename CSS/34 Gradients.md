# CSS Gradients
#css #gradients #colors #todo

Gradients allow us to display smooth transitions between two or more colors.

There are three types of gradients:
- Linear gradients (goes down/left/right/diagonally)
- Radial gradients (defined by their center)
- Conic gradients (rotated around a center point)

## Linear gradients

We must define two or more color stops to make a linear gradient.

Color stops are colors you want to render smooth transitions among.

We can set a starting point and a direction (or angle)
along with the gradient effect.

### Keyword directions

The syntax is:
```css
background-image: linear-gradient(direction, color-stop1, color-stop2, ...);
```

Top-to-bottom direction is default.
```css
#grad {
  /* Red top transitions to yellow bottom */
  background-image: linear-gradient(red, yellow);
}
```

Left-to-right direction can be specified using `to right` as the first value:
```css
#grad {
  background-image: linear-gradient(to right, red, yellow);
}
```

And diagonal by specifying horizontal and vertical starting positions:
```css
#grad {
  background-image: linear-gradient(to bottom right, red, yellow);
}
```

### Angle direction

We can specify an angle as the direction to get more control:
- `0deg` is equivalent to `to top`
- `90deg` is equivalent to `to right`
- `180deg` is equivalent to `to bottom`
- `270deg` is equivalent to `to left`
- and we can specify whatever angle we want to get specific diagonal angles

Example equivalent to `to bottom`:
```css
#grad {
  background-image: linear-gradient(180deg, red, yellow);
}
```

### Multiple color stops

We can keep specifying colors to add more color stops:
```css
#grad {
  /* red to yellow to green */
  background-image: linear-gradient(red, yellow, green);
}
```

We could add all the colors of the rainbow to get the visible color spectrum.

### Transparency

We can also use transparency to create fading effects.

We can use `rgba()` to define color stops with transparency.
```css
#grad {
  /* red with no opacity to fully opaque red */
  background-image: linear-gradient(to right, rgba(255,0,0,0), rgba(255,0,0,1);
}
```

### Repeating a linear gradient

We can repeat a linear gradient using `repeating-linear-gradient()`:
```css
#grad {
  /* red to yellow to green */
  background-image: repeating-linear-gradient(red, yellow 10%, green 20%);
}
```

Slanted yellow and red lines:
```css
#grad5 {
  background-image: repeating-linear-gradient(45deg, red 0px, red 10px, yellow 10px, yellow 20px);
}
```

## Radial gradients

TODO

## Conical gradients 

TODO

