# CSS Text Decoration
#css #text #decoration #line #color #style #spacing #font

Text can be decorated with lines, transformed, have spacing, and font properties.

## Decoration lines

`text-decoration-line` adds one or more decoration lines to text.
```css
h1 {
  text-decoration-line: overline underline; /* adds both */
}
p {
  text-decoration-line: line-through;
}
```
_Note: Underlining text can confuse readers into believing it is a link._

`text-decoration-color` is the color of the decoration line.

`text-decoration-style` is the style of the decoration line.
Values are similar to border or outline. `wavy` is a notable one.

`text-decoration-thickness` is the thickness of the decoration line.

`text-decoration` shorthand can be used for the above.
`-line` is the only required,
while `-color`, `-style`, `-thickness` are optional

`text-decoration: none;` may be used to remove decoration lines from links.

## Transformation

`text-transform` can be used to specify case of letters in text. Values:
- `uppercase`: All uppercase
- `lowercase`: All lowercase
- `capitalize`: Capitalize first letter of each word

## Spacing

`text-indent`: length used to indent first line
`letter-spacing`: specify space length between characters
`word-spacing`: specify length between words
`line-height`: specify spacing between lines (e.g. `1.8`)
`white-space`: How whitespace in text is handled, (e.g. `nowrap`)

## Shadow

`text-shadow` specifies shadow dimensions and color.
```css
h1 {
    text-shadow: 2px 2px red;
}
```

## Fonts

In CSS there are 5 font families:
- Serif e.g. Times New Roman, Georgia
- Sans-serif, e.g. Arial, Helvetica, Verdana
- Monospace, e.g. Courier New, Monaco, Lucida Console
- Cursive
- Fantasy, e.g. Copperplate, Papyrus

`font-family` can select the font and additional fallback fonts
that can be used in the event that the browser or OS lack them.
Fonts should be separated by comma.
```css
.p1 {
    font-family: "Times New Roman", Times, serif;
}
```

`font-style` property can be used to specify either:
- `normal` (default)
- `italic`
- `oblique` (leaning)

`font-weight` can specify the weight of a font, e.g. `normal` or `bold`.

`font-variant` is a thing.

`font-size` can set the size of text with absolute or relative size.
Absolute size sets specific size, and doesn't allow user to change.
Useful when the physical sie of the output is known.
Relative size sets it to be relative to the surrounding elements.
It's better for the user, allowing them to change the text size.
Default is `16px` aka `1em`.
`1em` is equal to the current font size, browsers set this as 16px by default.
Conversion is `pixels`/16 = `em`

A `body` `font-size` percentage, e.g. `110%` can be used to set default font size.
Then we can use `em` throughout the page.`

Responsive font size
The `vw` unit, aka "viewport width" can be used to set the size.
This way the text size will scale with the size of the browser window.
1vw = 1% of the viewport width. A 50cm viewport will have 1vw == 0.5cm.
