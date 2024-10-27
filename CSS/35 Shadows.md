# CSS Shadows
#css #shadows #text #cards

We can add drop shadow to text and other elements.

## Text shadows

Note: Kinda ugly in most cases, but I can't lie,
white text with shadows look kinda good.
See multiple shadows section for example.

We can apply shadows to text using `text-shadow`.
Simplest case: just specify horizontal and vertical shadow width:
```css
h1 {
  text-shadow: 2px 2px;
}
```

We can also add color to the shadow:
```css
h1 {
  text-shadow: 2px 2px red;
}
```

We can add a blur effect by squeezing in another width for blur:
```css
h1 {
  text-shadow: 2px 2px 5px red;
}
```

### Multiple shadows

We can add multiple shadows as a comma-delimited list of shadow parameters:
```css
h1 {
  text-shadow: 0 0 3px #FF0000, 0 0 5px #0000FF;
}
```

White text with black shadow and blurrier blue shadow (kinda cool):
```css
 h1 {
  color: white;
  text-shadow: 1px 1px 2px black, 0 0 25px blue, 0 0 5px darkblue;
}
```

### Shadow as a text border outline

We can also use `text-shadow` to create a plain border around some text:
```css
h1 {
  color: coral;
  text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black;
}
```
Notice we have a shadow for each side.

I made the top shadow much thicker and the others less than subtle.
```css
h1 {
  color: coral;
  text-shadow: -0.01rem 0 black, 0 0.01rem black, 0.01rem 0 black, 0 -0.05rem black;
}
```

## Box Shadow

`box-shadow` can apply one or more shadows to an element.

### Standard parameters

Simplest case, just specify a horizontal and vertical shadow width.
The default color of the shadow is the current text color.
```css
div {
  box-shadow: 10px 10px;
}
```

We can give our shadow some color:
```css
div {
  box-shadow: 10px 10px lightblue;
}
```

We can give it some blur by squeezing in a radius:
```css
div {
  box-shadow: 10px 10px 5px lightblue;
}
```
Here the blur radius is 5 pixels. It appears more transparent.
The higher the blur radius, the more blurred the shadow will be.

### Spread

We can also set the `spread` parameter to define the spread radius,
which is how far out the shadow spreads.
The higher the radius, the farther it will reach.
A negative value will decrease the size of the shadow.
```css
div {
  box-shadow: 10px 10px 5px 12px lightblue;
}
```
Here the spread is 12 pixels; a bigger shadow.

### Inset

The `inset` parameter can change the shadow from an outer (default) shadow
to an inner shadow (spreads towards top-left instead of bottom-right).

The value `inset` will accomplish this:
```css
div {
  box-shadow: 10px 10px 5px lightblue inset;
}
```

### Multiple shadows

An element can also have multiple shadows delivered
as a comma-delimited list of shadow parameters.
```css
box-shadow: 5px 5px blue, 10px 10px red, 15px 15px green;
```

### Cards

This is practically used for cards; which are usually interactable
image galleries or collections of other interactable elements.

```css
div.card {
  width: 250px;
  box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
  text-align: center;
}
```

