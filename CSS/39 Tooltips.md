## CSS Tooltips
#css #tooltips #position #pseudo-elements #transition #opacity

A tooltip is often used to specify extra information about something when
a user moves the mouse pointer over the element.

We can create one using CSS:
```css
.tooltip {
  position: relative; /* Needed to position tooltip text (absolute) */
  display: inline-block;
  border-bottom: 1px dotted black; /* If you want dots under the text */
}

.tooltip .tooltip-text {
  visibility: hidden;
  width: 120px;
  background-color: black;
  color: #ffffff;
  text-align: center;
  padding: 5px 0;
  border-radius: 6px;
  position: absolute; /* note: positioning can be improved */
  z-index: 1;
}

.tooltip:hover .tooltip-text {
  visibility: visible;
}
```
```html
<div class="tooltip">Hover over me
  <span class="tooltip-text">Tooltip text</span>
</div>
```

### Positioning tooltips

We can place the tooltip right (`left:105%`) of the hoverable text (`<div>`).
Note that `top: -5px` is used to place it in the middle of its container.
We use the number 5 since the tooltip text has top and bottom padding of `5px`.
If padding increased we'd also increase the `top` value to keep it centered.
```css
.tooltip .tooltip-text {
  top: -5px;
  left: 105%; /* a left tooltip would use `right: 105%;` */
}
```

A top or bottom tooltip would require use of `margin-left`:
Example for top tooltip (which uses `bottom: 100%` of + at parent height):
```css
.tooltip .tooltip-text {
  width: 120px;
  bottom: 100%; /* bottom tooltip would use top: 100% */
  left: 50%;
  margin-left: -60px; /* use half width to center */
}
```

### Tooltip arrows

To create an arrow that should appear from a specific side of the tooltip,
add "empty" content after the tooltip with `::after` with `content`:

Bottom arrow:
```css
.tooltip .tooltip-text::after {
  content: " ";
  position: absolute;
  top: 100%; /* at bottom of tooltip */
  left: 50%; /* center arrow */
  margin-left: -5px;
  border-width: 5px; /* size of arrow, same as margin-left */
  border-style: solid;
  border-color: black transparent transparent transparent; /* arrow! */
}
```

To add arrows to left or right tooltips we change `border-color` and the
positioning properties.
```css
.tooltip .tooltip-text::after {
  content: " ";
  position: absolute;
  top: 50%;
  left: 100%; /* to the right of the tooltip */
  /* for left we use right: 100% */
  margin-top: -5px;
  border-width: 5px;
  border-style: solid;
  border-color: transparent transparent transparent black; /* right arrow */
  /*  for left: transparent black transparent transparent; */
}
```

### Fade in tooltips with animation

We can use `transition` with `opacity` to fade in tooltips:
```css
.tooltip .tooltip-text {
  opacity: 0;
  transition: opacity 0.35s;
}
.tooltip:hover .tooltip-text {
  opacity: 1;
}
```
