# CSS Masking
#css #masking #images #gradients

We can create a mask layer to place over an element to partially
or fully hide portions of the element.

`mask-image` specifies a mask layer image. It can be a:
- PNG image
- SVG image
- CSS gradient
- SVG `<mask>` element

`mask-repeat` can specify how the mask will be repeated.
By default, a mask will be repeated.
A value of `no-repeat` indicates the image will only be shown once.

An example using a gradient that fades the image nicely:
```css
.mask1 {
  mask-image: linear-gradient(black, transparent);
}
```

A radial gradient can act as a clear spotlight and fade the rest:
```css
.mask2 {
  /* Note: can use `ellipse` instead of `circle` */
  mask-image: radial-gradient(circle, black 50%, rgba(0,0,0,0.5) 50%);
}
```

As noted we can use an SVG `<mask>`. Here's a triangle:
```html
<svg width="600" height="400">
  <mask id="svgmask1">
    <polygon fill="#ffffff" points="200 0, 400 400, 0 400"></polygon>
  </mask>
  <image
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xlink:href="img_5terre.jpg"
    mask="url(#svgmask1)"
  ></image>
</svg>
```

## Other mask properties 

There are other masking properties such as:
- `mask-clip`: which area is affected by a mask image
- `mask-composite`: compositing operation for multiple mask layers
- `mask-mode`: whether mask is treated as luminance or as alpha
- `mask-origin`: origin position (mask position area) of mask
- `mask-size`: size of mask

