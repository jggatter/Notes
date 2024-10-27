# CSS Text
#css #text #color #alignment #direction

## Color

As mentioned earlier, text can be styled with `color` or `background-color`.

## Alignment

It can be aligned using `text-align`:
- `left` or `right`
- `center`
- `justify`: Stretched so every line has equal width and margins are straight

Alignment is left-aligned by default for left-to-right-directed text.
Justified text is like a newspaper or magazine.

`text-align-last` specifies how to align the last line of text.

### Vertical alignment

`vertical-align` sets vertical alignment of elements that may be within text.

Some accepted values:
- `baseline`: Align with baseline of parent (default)
- `text-top`: Align with top of parent element's font
- `text-bottom`: Align with bottom of parent element's font
- `sub`: with subscript baseline of the parent
- `super`: With superscript baseline of the parent
- Specific length in units to raise/lower by
- Percentage of "line-height" property to raise/lower by

## Direction

The default direction of text is left-to-right.

`direction` and `unicode-bidi` properties can be used to change the direction.
```css
p {
  direction: rtl; /* right to left */
  unicode-bidi: bidi-override;
}
```
