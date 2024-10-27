# CSS Units
#css #units #length #width #margin #padding #font

CSS has several different units for expressing a length.

Many properties take "length" values such as:
- `width`
- `margin`
- `padding`
- `font-size`

Length is a number followed by a unit, such as `10px`, `2em`, etc.

_Note: Whitespace cannot appear between the number and the unit.
However if the value is `0` then the units can be omitted._

For some CSS properties, negative values are allowed.

There are two types of length units: `absolute` and `relative`.

## Absolute units

Absolute length units are fixed and a length expressed in any of these
will appear as exactly that size.

Absolute length units are not recommended for use on screen,
because screen sizes vary so much.

However, they can be used if the output medium is known,
such as for print layout.

Units:
- `cm`: centimeters
- `mm`: millimeters
- `in`: inches (`1in` = `96px` = `2.54cm`)
- `px`: pixels (`1px` = 1/96 of `1in`)
- `pt`: points (`1px` = 1/72 of `1in`)
- `px`: picas (`1pc` of `12pt`)

Note: pixels are relative to the viewing device.
For low-dpi devices, 1px is one device pixel (dot) of the display.
For printers and high-res screens, `1px` implies multiple device pixels.

## Relative lengths

Relative length units specify a length relative to another length property.
Relative length units scale better between different rendering mediums.

Units:
- `em`: relative to font-size of element (`2em` = twice size of current font)
- `ex`: relative to x-height of the current font (rarely used)
- `ch`: relative to width of "0"
- `rem`: relative to font-size of the root element
- `vw`: relative to 1% of width of viewport
- `vh`: relative to 1% of the height of viewport
- `vmin`: relative to 1% of the smaller dimension of viewport
- `vmax`: relative to the 1% of the larger dimension of viewport
- `%`: relative to the parent element

`em` and `rem` are practical in creating a perfectly scalable layout.
