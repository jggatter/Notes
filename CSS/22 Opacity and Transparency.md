# CSS Opacity and Transparency
#css #opacity #colors #rgb #hsl

`opacity` specifies the opacity and conversely transparency of an element.
It can take a value from 0.0 to 1.0, where lower values are more transparent
All child elements inherit the same transparency.

`opacity` is often used with `:hover` to change the opacity on mouse-over.
```css
 img {
  opacity: 0.5;
}

img:hover {
  opacity: 1.0;
}
```

As seen with colors, `rgba()` and `hsla()` have alpha channel arguments.
Notably these do not apply opacity to child elements.
For example you could apply opacity for div background color and not text.
