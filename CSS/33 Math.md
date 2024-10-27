# CSS Math
#css #math

CSS math functions allow mathematical expressions
to be used as property values

## `calc()`

`calc()` performs a calculation to be used as a property value.
`calc()` accepts an expression using `+`, `-`, `*`, or `/` operators

Example:
```css
#div1 {
  position: absolute;
  left: 50px;
  width: calc(100% - 100px);
  border: 1px solid black;
  background-color: yellow;
  padding: 5px;
}
```

## `max()` and `min()`

`max()` uses the largest submitted value as the property value.
`max()` accepts a comma-delimited list of values.
```css
#div1 {
  background-color: yellow;
  height: 100px;
  width: max(50%, 300px);
}
```

`min()` works the same way but the lowest submitted value is the result.
