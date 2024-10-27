# CSS Animations
#css #animations #transitions

We can animate HTML elements without using JavaScript!

An animation lets an element gradually change from one style to another.

We can change as many properties as we want, as many times as we want.

We must first specify keyframes for the animation.

Keyframes hold what styles the elements will have at certain times.

## The `@keyframes` Rule

When we specify styles inside a `@keyframes` rule, the animation
will gradually change from the current style to the new style.
When the animation is finished, it reverts to its original style.

To get it to work, we must bind the animation to an element.

Let's bind it to a `<div>` element.
```css
/* animation code */
@keyframes example {
 from {background-color: red;}
 to {background-color: yellow;}
}

/* element to apply animation to */
div {
  width: 100px;
  height: 100px;
  background-color: red;
  animation-name: example;
  animation-duration: 4s;
}
```
Note: The `animation-duration` property defines how long an animation should
take to complete. If its not specified, no animation will occur
since the default is 0.

We specify when the style will change using 
the `from` and `to` keywords, which represent 0% (start) and 100% (end).

We can specify percentages instead of these keywords.
That way we can have as many changes as we like whenever we like.

```css
@keyframes example {
  0% {background-color: red;}
  25% {background-color: yellow;}
  50% {background-color: blue;}
  100% {background-color: green;}
}

div {
  width: 100px;
  height: 100px;
  background-color: red;
  animation-name: example;
  animation-duration: 4s;
}
```

We can change more than one property per keyframe:
```css
@keyframes example {
  0% {background-color: red; left: 0px; top: 0px;}
  25% {background-color: yellow; left: 200px; top: 0px;}
  50% {background-color: blue; left: 200px; top: 200px;}
  75% {background-color: green; left: 0px; top: 200px;}
  100% {background-color: red; left: 0px; top: 0px;}
}

div {
  width: 100px;
  height: 100px;
  position: relative;
  background-color: red;
  animation-name: example;
  animation-duration: 4s;
}
```
This causes the div to move 4 times in a square to get back to its start.

## Properties 

`animation-delay` delays the start of an animation.
The value is the number of seconds, e.g. `2s`.
Negative values are allowed, and behave as if the animation has already
been playing for the inputted number of seconds.

`animation-iteration-count` specifies the number of times an animation runs.
E.g. `3` will make the animation loop 3 times before it stops.
`infinite` will make it loop forever.

`animation-direction` specifies the direction or cycling of an animation:
- `normal` (default): played forwards, as normally
- `reverse`: played in reverse, (backwards)
- `alternate`: played forwards, then backwards
- `alternate-reverse`: played backwards then forwards

`animation-timing-function` specifies the speed curve of the animation.
This is the same experience as the `transition-timing-function` for transitions:
- `ease` (default): animation with slow start, then fast, then slow
- `linear`: animation with same speed from start to end
- `ease-in`: animation with slow start
- `ease-out` animation with slow end
- `ease-in-out` animation with slow start and end
- `cubic-bezier(n,n,n,n)`: Define our own values in a cubic-bezier function

## Specifying the Fill-mode

Animations do not affect an element before the first keyframe plays or 
after the last keyframe plays.

`animation-fill-mode` can override this behavior, specifying a style
when the animation is not playing (before, after, or both):
- `none` (default): Do not apply styles before or after animation
- `forwards`: retain style values set by last keyframe*
- `backwards`: retain style set by first keyframe*
- `both`: retain styles set by first and last keyframes
_Note (*): The direction and iteration count of the animation affect this!_

```css
div {
  width: 100px;
  height: 100px;
  background: red;
  position: relative;
  animation-name: example; 
  animation-duration: 3s;
  animation-delay: 2s;
  animation-fill-mode: both;
}
```
Animation begins after 2 seconds, last for 3, and retains style from before
and after last keyframes.

## `animation` shorthand

This example:
```css
div {
  width: 100px;
  height: 100px;
  background: red;
  position: relative;
  animation-name: example; 
  animation-duration: 5s;
  animation-timing-function: linear;
  animation-delay: 2s;
  animation-iteration-count: infinite;
  animation-fill-mode: alternate;
}
```
Can be consolidated under the shorthand `animation` property:
```css
div {
  width: 100px;
  height: 100px;
  background: red;
  position: relative;
  animation: example 5s linear 2s infinite alternate;
}
```
