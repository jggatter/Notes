# CSS Colors
#css #colors #rgb #hex #hsl #opacity

Colors can be specified by
- predefined color names
- RGB or RGBA
- HEX
- HSL or HSLA

## Properties:

- `background-color` can be used to set background color for the element.
- `color` can be used to set the text color.
- Within `border`, the border color can be specified as an argument.

## Values

### Predefined

Color names by string, e.g. `"Tomato".`
There's a predefined list of about 140 standard colors.

### RGB and RGBA

RGB by `rgb(<red>, <green>, <blue>)`, e.g. `rgb(255, 99, 71)`
RGBA by `rgba(<red>, <green>, <blue>, <alpha>)`, e.g. `rgb(255, 99, 71, 0.5)`

Each color is a 8-bit unsigned integer.
- `0` is black.
- `255` is the full color.

The alpha channel for RGBA is a number between 0.0 and 1.0.
- `0.0` is fully transparent.
- `1.0` is fully opaque.
See [[22 Opacity and Transparency]].

### HSL and HSLA

HSL stands for Hue, Saturation and Lightness.

HSL and HSLA are specified in basically the same way as RGB/RGBA. 
* HSL by `hsl(<hue>, <saturation>, <light>)`
* HSLA by `hsla(<hue>, <saturation>, <light>, <alpha>)`

`hue` is a degree on the color wheel from 0 to 360.
- `0` is red.
- `120` is green.
- `240` is blue.

`saturation` is the intensity of the color, represented as a percentage.
- `0%` means a shade of gray.
- `50%` is half gray, half color.
- `100%` is the full color.

`lightness`, how much light you want to give a color, is a percentage.
- `0%` is black.
- `50%` is neither light or dark.
- `100%` is white.

Shades of gray are often defined by setting hue and saturation to `0`
and adjusting lightness from 0% to 100%.

The alpha channel for HSLA is a number between 0.0 and 1.0.
- `0.0` is fully transparent.
- `1.0` is fully opaque.

### HEX

HEX by `#dddddd`, the hexadecimal value representation of RGB.
`#rrggbb` where `rr`, `gg`, and `bb`, are the hex values between `00` and `ff`
`00` is black, `ff` is the respective full color of red, green, or blue.
Sometimes you will see a 3-digit hex code. This is shorthand for the 6-digit code.
`#rgb`, e.g. `#f0c` which represents `##ff00cc`

### Keyword values for color

The `transparent` keyword value for color fields is equivalent to `rgba(0,0,0,0)`.

The `currentcolor` keyword value is like variable which holds the current color property value of an element.

It can be used to stylize other properties for an element:
```css
div {
  color: blue;  
  border: 10px solid currentcolor;
}  
```
Or properties of another element:
```css
body {  color: purple;}  
div {  background-color: currentcolor;}
```

`inherit` specifies a property should inherit its value from its parent element.

