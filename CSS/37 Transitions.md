# CSS Transitions

Transitions allow changing values smoothly over a given duration.

To create a transition we must specify two things:
1. the property we want to add an affect to
2. the duration of the effect (default value of 0)

_Note: If duration is not specified, transition will have no effect_

Example: 100px by 100px red `<div>` expanding width over 2 seconds:
```css
div {
  width: 100px;
  height: 100px;
  background: red;
  transition: width 2s;
}
```
The transition won't take effect until the `width` is changed.
```css
div:hover {
  width: 300px;
}
```
Now on mouse hover, the transition will trigger.

We can specify multiple properties to change with a single `transition`:
```css
div {
  transition: width 2s, height 4s, transform 2s;
}
```
The transitions are delimited by comma.

## Specify the speed curve of the transition

`transition-timing-function` property specifies 
the speed curve of the transition effect.

- `ease` (default): effect with slow start, then fast, then slow
- `linear`: effect with same speed from start to end
- `ease-in`: effect with slow start
- `ease-out` effect with slow end
- `ease-in-out` transition with slow start and end
- `cubic-bezier(n,n,n,n)`: Define our own values in a cubic-bezier function

The `transition-delay` property specifies a delay for the transition effect.
```css
div {
  transition-delay: 1s;
}
```

## Individual transition properties

`transition` is actually shorthand for individual transition properties:

We could individually specify them:
```css
div {
  transition-property: width;
  transition-duration: 2s;
  transition-timing-function: linear;
  transition-delay: 1s;
}
```
Which is the same as this shorthand:
```css
div {
  transition: width 2s linear 1s;
}
```