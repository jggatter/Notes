# CSS Object Fit and Position
#css #object #fit #position #images #videos

## `object-fit`

The `object-fit` specifies how an `<img>` or `<video>` should be resized
to fit its container.

We can "preserve that aspect ratio"
or "stretch up and take up as much space as possible"


Resizing a 400 x 300 pixel photo to be half its width will squish it.
The original aspect ratio is destroyed!
We can use `object-fit` to amend this.

Values:
- `fill` (default): resize to fill given dimension, if necessary stretch/squish
- `contain`: keep aspect ratio but resize to fit within given dimension
- `cover`: keep aspect ratio and fill given dimension, but clip to fit
- `none`: Image isn't resized
- `scale-down`: Imag is scaled down to smallest version of `none` or `contain`

`cover` can be used for responsive layouts. 

## object-position

`object-position` specifies where the image/video should be
position with X and Y coordinates inside its own container.

When we use `object-fit: cover` to maintain the aspect ratio
and fill the given dimension, the clipped fit might
not show the part of the image we want.

We can position the image to show the right part:
```css
img {
  width: 200px;
  height: 300px;
  object-fit: cover;
  object-position: 80% 100%
}
```

Or the left part:
```css
img {
  width: 200px;
  height: 300px;
  object-fit: cover;
  object-position: 15% 100%
}
```
