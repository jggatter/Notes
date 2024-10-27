# CSS Basics

## Introduction

Cascading Style Sheets (CSS) describes how HTML elements are to be displayed
on screen, paper, or in other media.

It can control the layout of multiple web pages all at once.

External stylesheets are stored in CSS files (.css).

## History

HTML was created to describe the content of a web page.
It was never intended to contain tags for formatting a web page.
Tags like `<font>` were introduced in HTML 3.2 spec, causing nightmares.
The World Wide Web Consortium (W3C) created CSS to resolve the problem.
CSS removed style formatting from HTML pages.

## Syntax

Note this example:
```css
h1 {color:blue; font-size:12px;}
```

Now let's break it down:
```css
   h1                       {color     :blue   ; font-size :12px   ;}
/* <Selector> <Declarations>{<Property>:<Value>; <Property>:<Value>;} */
```

The selector points to the HTML element we want to style.
The declaration block `{}` contains declaration(s) delimited by semi-colon.
Each declaration contains a CSS property and a value separated by colon.

## Selectors

Selectors are used to find or select the HTML elements you want to style.

We can divide selectors into 5 categories:
- Simple: select elements based on name, id, or class
- Combinator: select elements based on specific relationship between them
- Pseudo-class: select elements based on a certain state
- Pseudo-elements: select and style a part of an element
- Attribute selectors: select elements based on an attribute or value

### Simple selectors

#### Element selector

Here we select all paragraphs based on name of the HTML `<p>` element:
```css
p {
    text-align: center;
    color: red;
}
```

#### id selector

Uses id attribute of an HTML element to select specific elements:
```css
#para1 {
    test-align: center;
    color: red;
}
```
Selects:
```HTML
<p id="para1"></p>
```

_Note: id name cannot start with a number_

#### class selector

Selects elements with specific class attribute.
Uses a dot `.` prefix followed by the class name.

```css
.center {
    text-align: center;
    color: red;
}
```

We can also specify that only `<p>` elements should be affected:
```css
p.center {
    text-align: center;
    color: red;
}
```

HTML elements can also refer to more than one class:
```css
<p class="center large">...</p>
```
Here this element will be styled according to class `"center"` and `"large"`.

_Note: class name cannot start with a number!_

#### Universal selector

The universal selector `*` selects all HTML elements on the page.

```css
* {
    text-align: center;
    color: blue;
}
```

#### Grouping selector

Selects all HTML elements with the same style definitions
```css
h1 {
    text-align: center;
    color: red;
}
h2 {
    text-align: center;
    color: red;
}
p {
    text-align: center;
    color: red;
}
```
We can consolidate this example as:
```css
h1, h2, p {
    text-align: center;
    color: red;
}
```

## Inserting CSS

There are three ways to insert CSS:
- External CSS
- Internal CSS
- Inline CSS

### External

External style sheets are separate files where the CSS are declared.

The HTML pages must include a reference to the external style sheet file
within the `<head>` element's `<link>` element.
```html
<!DOCTYPE html>
<html>
  <head>
    <link rel="stylesheet" href="my_style.css">
  </head>
<body>

  <h1>Welcome</h1>
  <p>Lorem Ipsum</p>

</body>
</html> 
```

`my_style.css`:
```css
body {
  background-color: lightblue;
}

h1 {
  color: navy;
  margin-left: 20px;
}
```

### Internal

An internal style sheet can be used if a single HTML page has unique style:
```html
<!DOCTYPE html>
<html>
<head>
<style>
body { 
  background-color: linen;
}

h1 {
  color: maroon;
  margin-left: 40px;
}
</style>
</head>
<body>

  <h1>Welcome</h1>
  <p>Lorem Ipsum</p>

</body>
</html> 
```

### Inline

An inline style may be used to apply a unique style for a single element.
To use inline styles, add the style attribute to the relevant element.
The style attribute can contain any CSS property.

```html
<!DOCTYPE html>
<html>
<body>

  <h1 style="color:blue;text-align:center;">Welcome</h1>
  <p style="color:red;">Lorem Ipsum</p>

</body>
</html> 
```

An inline style loses many advantages of a style sheet
by mixing content with presentation. Use sparingly.

### Multiple style sheets

If some properties have been defined for the same selector (element)
in different style sheets, the value from the last read sheet will be used.

Assume that an external style sheet has the following style for the `<h1>`:
```css
h1 {color: navy;}
```
Then assume that an internal style sheet has the following style for the `<h1>`:
```css
h1 {color: orange;}
```

Whichever is defined last will override the previous declarations.
```html
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="my_style.css">
<style>
h1 {
  color: orange;
}
</style>
</head>
```
Color will be orange.
```html
<!DOCTYPE html>
<html>
<head>
<style>
h1 {
  color: orange;
}
</style>
<link rel="stylesheet" type="text/css" href="my_style.css">
</head>
```
Color will be navy.

### Cascading order

All the styles in a page will "cascade" into a new "virtual" style sheet
by the following rules, where number one has the highest priority. 

1. Inline (within an element)
2. External and internal (within the `<head>` element)
3. Browser default

## Comments

Comments are used to explain code. They're ignored by the browser.
A comment starts and ends with an opening `/*` and a closing `*/`.
Comments can literally be added anywhere within the style sheet.
Comments can span multiple lines.

HTML comments start and end with `<!--` and `-->`.

## Colors

Colors can be specified by
- predefined color names
- RGB or RGBA
- HEX
- HSL or HSLA

### Properties:

- `background-color` can be used to set background color for the element.
- `color` can be used to set the text color.
- Within `border`, the border color can be specified as an argument.

### Values

#### Predefined

Color names by string, e.g. `"Tomato".`
There's a predefined list of about 140 standard colors.

#### RGB and RGBA

RGB by `rgb(<red>, <green>, <blue>)`, e.g. `rgb(255, 99, 71)`
RGBA by `rgba(<red>, <green>, <blue>, <alpha>)`, e.g. `rgb(255, 99, 71, 0.5)`

Each color is a 8-bit unsigned integer.
- `0` is black.
- `255` is the full color.

The alpha channel for RGBA is a number between 0.0 and 1.0.
- `0.0` is fully transparent.
- `1.0` is fully opaque.

#### HSL and HSLA

HSL and HSLA in basically the same way as RGB/RGBA. Does anyone use these?
HSL by hsl(<hue>, <saturation>, <light>)
HSLA by hsla(<hue>, <saturation>, <light>, <alpha>)

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

#### HEX

HEX by `#dddddd`, the hexadecimal value representation of RGB.
`#rrggbb` where `rr`, `gg`, and `bb`, are the hex values between `00` and `ff`
`00` is black, `ff` is the respective full color of red, green, or blue.
Sometimes you will see a 3-digit hex code. This is shorthand for the 6-digit code.
`#rgb`, e.g. `#f0c` which represents `##ff00cc`

## Backgrounds

Background properties are used to add background effects for elements.

### `background-color`

See Colors section for more detail.

Can be set for any HTML element!

The `opacity` property can be additionally specified as an alpha channel value.
Note that all child elements will inherit it, possibly making text hard to read.

### `background-image`

Specifies an image to use as the background of an element.

```css
body {
  background-image: url("paper.gif");
}
```

It can also be set for specific elements like `<p>`.

By default, the image is repeated to cover the entire element,
both horizontally and vertically.
`background-repeat` can control this behavior:
```css
body {
  background-image: url("paper.gif");
  background-repeat: no-repeat; /* or repeat-x or repeat-y */
  background-position: right top;
}
```
`background-position` can control the position of the background image.

`background-attachment` can control whether the image should
should `scroll` or be `fixed` with the rest of the page.


### `background`

The `background` shorthand property can combine these as a single declaration.
```css
body {
  background: #ffffff url("img_tree.png") no-repeat right top;
}
```
This is kinda ugly though.

## Borders

Properties allow us to specify the element border's style, width, or color.

### `border-style`

What kind of border to display. Values:
- `dotted`
- `dashed`
- `solid`
- `double`
- `groove`: 3D grooved border
- `ridge`: 3D ridged border
- `inset`: 3D inset border
- `outset`: 3D outset border
- `none`: No border
- `hidden`: A hidden border

_Note: The 3D borders depend on the `border-color` value._

The `border-style` can accept a value for each border of the element,
The order is clockwise starting with the top border.
If only two arguments given, then the first is top and bottom,
and the latter is the sides.

Alternatively, individual `border-<side>-style` properties can be used 
to respectively define the style for a side. Example:
```css
p {
  border-top-style: dotted;
  border-right-style: solid;
  border-bottom-style: dotted;
  border-left-style: solid;
}
```

### `border-width`

The width of the borders.

The specific size in units, or one of three pre-defined values:
- `thin`
- `medium`
- `thick`

Likewise, can be up to four arguments for each border in clockwise order.
Shorthands for each side can be used.

### `border-color`

The color of the borders. If not set, it is inherited.

Likewise, can be up to four arguments for each border in clockwise order.
Shorthands for each side can be used.

### Rounding borders

Use `border-radius` to add rounded borders to an element.
```css
p {
  border: 2px solid navy;
  border-radius: 5px;
}
```

## Box model

From outermost to innermost parts of an element:
1. Margin: space outside of defined borders
2. Border
3. Padding: space inside defined borders, buffering content
4. Content: the good stuff (text, images, etc.)

`width` and `height` properties define the contents width and height.
The total width and height of an element is the sum of all widths and heights.
_excluding_ the margin.
The margin affects how much space the element takes up on the page though.

## Margins

Margins create space around elements, **outside** of any defined borders.

`margin` can be for each side in clockwise order starting from the top.
Or `margin-<side>` can define it for specific sides.

These properties can accept these values:
- `auto`: Browser centers horizontally within container after `width` considered
- The specific length in units `px`, `pt`, `cm`, etc.
- The percentage of the width of the containing element
- `inherit`: The margin should be inherited from the parent element

_Note: No negatives allowed._

### Margin collapse

Top and bottom margins of elements are sometimes collapsed into
whichever is largest.
This doesn't happen to left and right margins.
```css
h1 { margin: 0 0 50px 0; }
h2 { margin: 20px 0 0 0; }
```
The bottom of `h1` is 50 pixels whereas the top of `h2` is 20 pixels.
Common sense would suggest the vertical margin would be the sum of 70 pixels,
but due to margin collapse the actual margin is the larger, 50px.

## Padding

Padding creates space around an element's content **inside** of any defined borders.

For properties, same thing as margins: either 
- `padding` with clockwise arguments
- or shorthands for each side.

Accepted values:
- The specific length
- The percentage of the width of the containing element
- `inherit` from the parent element

_Note: No negatives allowed._

### Padding and element width

The `width` property specifies the width of the element's content area.
The content area is the portion inside the padding, border, and margin.
See the box model.

If an element has a specified `width`, the `padding` will be added to the total.
This is often an undesirable gotcha moment.

`box-sizing` property can be used to maintain the element width despite padding.
Increasing padding will cause the available content space to decrease.
```css
div {
  width: 300px;
  padding: 25px;
  box-sizing: border-box;
}
```

## Height, width, and max-width

### `height` and `width`

`height` and `width` are used to set the height and width of the content area.
See box model. They don't include padding, borders, or margins.

Accepted values:
- `auto` (default): Browser calculates
- Specific length in units
- Percentage of height/width of the containing block
- `initial`: Default value
- `inherit`: Inherit from parent element

### `max-width`

The `max-width` property is used to specify the maximum width of the element.

Accepted values:
- None (default)
- Specific length in units
- Percentage of height/width of the containing block

When a browser window is/becomes smaller than the width of an element,
the browser adds a horizontal scrollbar to the page.
Replacing `width` with `max-width` we can have the element wrap with the
window size.
If both are specified for some reason, only the `max-width` will be considered.

### `min-height` and `min-width`

???

## Outline

The outline is a line drawn outside of the element's border.
It can be used to make the element stand out more.

The `outline-style` and shorthand properties are essentially the same
as the `border-` properties

Outline style must be specified to use optional properties for width or color.
`outline-offset` adds space between an outline and the edge/border of an element.

## Text

### Color

As mentioned earlier, text can be styled with `color` or `background-color`.

### Alignment

It can be aligned using `text-align`:
- `left` or `right`
- `center`
- `justify`: Stretched so every line has equal width and margins are straight

Alignment is left-aligned by default for left-to-right-directed text.
Justified text is like a newspaper or magazine.

`text-align-last` specifies how to align the last line of text.

#### Vertical alignment

`vertical-align` sets vertical alignment of elements that may be within text.

Some accepted values:
- `baseline`: Align with baseline of parent (default)
- `text-top`: Align with top of parent element's font
- `text-bottom`: Align with bottom of parent element's font
- `sub`: with subscript baseline of the parent
- `super`: With superscript baseline of the parent
- Specific length in units to raise/lower by
- Percentage of "line-height" property to raise/lower by

### Direction

The default direction of text is left-to-right.

`direction` and `unicode-bidi` properties can be used to change the direction.
```css
p {
  direction: rtl; /* right to left */
  unicode-bidi: bidi-override;
}
```

## Decoration


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

### Transformation

`text-transform` can be used to specify case of letters in text. Values:
- `uppercase`: All uppercase
- `lowercase`: All lowercase
- `capitalize`: Capitalize first letter of each word

### Spacing

`text-indent`: length used to indent first line
`letter-spacing`: specify space length between characters
`word-spacing`: specify length between words
`line-height`: specify spacing between lines (e.g. `1.8`)
`white-space`: How whitespace in text is handled, (e.g. `nowrap`)

### Shadow

`text-shadow` specifies shadow dimensions and color.
```css
h1 {
    text-shadow: 2px 2px red;
}
```

### Fonts

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

## Icons

The simplest way to add an icon is to use an icon library like Font Awesome.
Add the name of the specified icon class to any inline HTML element,
such as `<i>` or `<span>`.

Sign into fontawesome.com and get a code to source. Then:
```html
<head>
<script src="https://kit.fontawesome.com/yourcode.js" crossorigin="anonymous">
</script>
</head>
<body>

<i class="fas fa-cloud"></i>
<i class="fas fa-heart"></i>
<i class="fas fa-car"></i>
<i class="fas fa-file"></i>
<i class="fas fa-bars"></i>

</body>
</html>
```

## Links

HTML `<a>` elements can be styled with any CSS property.
`color`, `font-family`, `background`, etc.

```css
a {
  color: hotpink;
}
```

Additionally, links can be styled depending on what state they're in.
The four link states are:
- `a:link`: A normal, unvisited link
- `a:visited`: A link the user has visited
- `a:hover`: A link the user mouses over
- `a:active`: A link the moment it is clicked

Example:
```css
a:visited {
  color: green;
}
```

Rules:
- `a:hover` must come after `a:link` and `a:visited`
- `a:active` must come after `a:hover`

### Removing underlines

As mentioned, the `text-decoration: none;` can be used to remove underlines.

### Link buttons

We can combine several CSS properties to display links as boxes/buttons:
```css
a:link, a:visited {
  background-color: #f44336
  color: white;
  padding: 14px 25px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
}

a:hover, a:active {
  background-color: red;
}
```

## Lists

In HTML, there are two main types of lists:
- Unordered lists `<ul>`: Marked with bullets
- Ordered lists `<ol>`: Marked with numbers or letters in order

CSS list properties allow for us to:
- Set different list item markers for lists
- Set an image as the list item marker
- Add background colors to lists and list items

`list-style-type` specifies the type of list item markers. Example values:
- `circle`
- `square`
- `upper-roman`
- `lower-alpha`
- `none`: Removes markers/bullets. Consider `margin` and `padding` of `0`.

`list-style-image` allows an image to be set as a list item marker.
```css
ul { 
  list-style-image: url('square_purple.gif');
}
```

`list-style-position` specifies the position of the list-item marker:
- `outside` (default): Outside the list item
- `inside`: Within the list item (as a part of the text)

`list_style` is the shorthand for all these: `-type`, `-position`, and `-image`.
If any are missing, defaults will be inserted.

## Tables

Table element looks can be greatly improved with CSS.
HTML table elements include:
- `<table>`: The table parent element
- `<tr>`: The table row container
- `<th>`: The table header cell element
- `<td`>: The table data cell, non-header element

There's also `<caption>`, `<colgroup>`, `<col>`, 
`<thead>`, `<tbody>`, and `<tfoot>`.

The `border` property can specify borders for the main table containers.
```css
table, th, td {
  border: 1px solid;
}
```
By default it appears that tables have double borders, but
this is because the `<th>` and `<td>` elements each have separate ones.
`border-collapse: collapse;` on the `<table>` can collapse these into a 
single border.

`width` and `height` define the width and height of the table.
`width: 100%` can make a `<table>` span the whole width of the screen.
```css
table {
  width: 100%;
}
th {
  height: 70%;
}
```

For text within cells, alignment properties like `vertical-align` can be used.
`padding` can be applied as well.

`border-bottom` for `<th>` and `<td>` can be used for horizontal dividers.
```css
th, td {
  border-bottom;
}e
```

`:hover` selector on a `<tr>` can be used to highlight table rows on mouse hover.
```css
tr:hover {
  background-color: coral;
}
```

For "zebra-striped" tables, `nth-child()` selector can be used:
```css
tr:nth-child(even) {
  background-color: #f2f2f2;
  color: white;
}
```

A responsive table displays a horizontal scrollbar if the screen is too small.
A container element needs to be stylized with `overflow-x:auto`.
```html
<div style="overflow-x:auto;">
  <table>
    <!-- table content -->
  </table>
</div>
```

Other properties:
`border-spacing`: the distance between borders of adjacent cells
`caption-side` Where the table caption is placed
`empty-cells`: whether to display borders/backgrounds of empty cells
`table-layout`: The layout algorithm to be used

## Layout

The `display` property is the most important property for controlling layout.
Every HTML element has a default display value, depending on the type of element.
The default for most elements is either `block` or `inline`.

### Block-level

Block-level elements **always** start on a new line
and take up the full width available.

Block-level elements include:
- `<div>`
- Headers, e.g. `<h1>`
- `<p>`
- `<form>`
- `<header>`
- `<footer>`
- `<section>`

### Inline elements

Inline elements do **not** start on a new line
and only take up as much width as necessary.

Examples include:
- `<span>`
- `<a>`
- `<img>`

### `display` values

`display` has many values:
- `inline`: as inline element
- `block`: as block element
- `contents`: make container disappear, making child elements children of
the element next up in the DOM.
- `flex`: as block-level [[flex]]() container
- `grid`: as block-level [[grid]]() container
- `inline-block`: as inline-level block container; the element itself
is formatted as an inline element but height/width values can be applied.
- `inline-flex`: as inline-level flex container
- `inline-grid`: as inline-level grid container
- `inline-table` as inline-level table
- `run-in`: either as block or inline, depending on context
- `initial`: set to its initial value
- `inherit`: inherit from parent
- `none`: Completely hide the element

As opposed to `visibility:hidden`, `display:none` takes up no space.

There are also values that cause the element to be displayed like other elements:
- `list-item`: display like `<li>`
- `table`: display like `<table>`
And so on for `table-caption`, `table-column-group`, `table-header-group`,
`table-footer-group`, `table-row-group`, `table-cell`, `table-column`,
`table row`

The `display` value can be overridden.
A common example is for making horizontal menus:
```css
li {
  display: inline;
}
```

### `display: inline-block`

Compared to `inline`, the `inline-block`:
- allows us to set a width and height on the element.
- The top and bottom margins/padding are respected.

Compared to `block`, the `inline-block` does not add a line-break
after the element, so the element can sit next to other elements.

One common use for the value is to display list items horizontally
instead of vertically. Unlike the aforementioned example using `inline`
it's blockier.

### `width`, `max-width` and `margin:auto`

A block-level element always takes up the full width available to it.
Setting `width` will prevent it, then `margin:auto` centers it horizontally
within its container.
The remaining space is split equally between the two margins.

If the screen is too small, like on a phone, then the div might not wrap properly
We can use the `max-width` instead of `width` to improve handling.

### `position`

The `position` property specifies the type of position method used.
There are 5 different values:
- `static` (default)
- `relative`
- `fixed`
- `absolute`
- `sticky`

Elements are then positioned using `top`/`bottom`/`left`/`right` properties.
However, the `position` must be specified first.
The `position` value also influences the behavior of these properties.

#### Static positioned elements

Static positioned elements aren't affected by `top`/`bottom`/`left`/`right` properties.
Nothing special. It's always positioned according to normal page flow.

#### Relative positioned elements

Relative positions relative to its normal position
Setting `top`/`bottom`/`left`/`right` cause it to be adjusted away from normal position.
Other content will not be adjusted to fit into any gap left by the element.
```css
div.relative {
  position: relative;
  left: 30px;
  border: 3px solid #73AD21
}
```

#### Fixed positioned elements

Fixed positioned elements are positioned relative to the view port.
It always stays in the same place even if the page is scrolled.
`top`/`bottom`/`left`/`right` are used to position the element.
It does not leave a gap in the page where it normally would be located.

#### Absolute positioned elements

Absolute positioned are relative to the nearest positioned ancestor
(instead of relative to viewport, like `fixed`).
However, if an absolute positioned element has no positioned ancestors,
it uses the document body and moves along with page scrolling.
Absolute positioned are removed from normal flow, and can overlap elements
```css
/* 
   These two overlap,
   lining up on the right border of the relative div
*/
div.relative {
  position: relative;
  width: 400px;
  height: 200px;
  border: 3px solid #73AD21;
}

div.absolute {
  position: absolute;
  top: 80px;
  right: 0;
  width: 200px;
  height: 100px;
  border: 3px solid #73AD21;
}
```

#### Sticky positioned elements 

Sticky positioned are positioned based on the user's scroll position.
Element toggles between `relative` and `fixed` based on scroll position.
It is relative until a given offset is met in the viewport,
then it "sticks" in place like `fixed`.
`top`/`bottom`/`left`/`right` must be specified for it to work.

### `z-index` property

When elements are positioned, they can overlap with other elements.

Specifies the stack order of an element; which element should be placed
in front of or behind others.
Elements with a greater stack order always are in front of 
those with a lower stack order.

An element can have a positive or negative stack order.
```css
img {
  position: absolute;
  left: 0px;
  top: 0px;
  z-index: -1;
}
```
This image will be placed behind text with a `z-index` > -1.

The `z-index` only works on positioned elements (not `static`)
and flex items; direct children of `display: flex` elements.

If two positioned elements overlap each other without a `z-index` specified.
The element defined last in the HTML will be shown on top.

### Overflow

`overflow` property controls what happens to content
that's too big to fit into an area.

`overflow` only works for block elements with a specified height.

It has the following values:
- `visible` (default): overflow is not clipped, content renders outside box
- `hidden`: overflow is clipped, the remaining content will be invisible
- `scroll`: overflow is clipped, a scrollbar is added to see the remainder
- `auto`: similar to `scroll` but adds scrollbars only when necessary

_Note: macOS seems to add scrollbars only when necessary._

#### `overflow-x` and `overflow-y`

Specifies whether to change the overflow of content
just horizontally, or just vertically, or both.
```css
div {
  overflow-x: hidden;
  overflow-y: scroll;
}
```

#### `overflow-wrap`

Let the browser be allowed to break lines with long words if they overflow.

Values:
- `normal` (default): Disables
- `break-word`: Enables
- `anywhere`: Same thing?

### `float` and `clear`

`float` specifies how an element should float.
`clear` specifies what elements can float beside the clear element,
and on what side

#### `float`

Used for positioning and formatting content
e.g. let an image float left to the text in a container

Values:
- `left`: element floats to the left of its container
- `right`: element floats to the right of its container
- `none` (default): element does not float, just displayed where it is
- `inherit`: element inherits value from its parent

Example:
```html
<!DOCTYPE html>
<html>
<head>
<style>
div {
  float: left;
  padding: 15px; /* gives width to each div */
}
.div1 {
  background: red;
}
.div2 {
  background: yellow;
}
.div3 {
  background: green;
}
</style>
</head>
<body>
  <h2>Float next to each other!</h2>
  <div class="div1">Div 1</div>
  <div class="div2">Div 2</div>
  <div class="div3">Div 3</div>
</body>
</html>
```

#### `clear`

When we use `float`, and we want the next element below (not right/left)
then we have to use `clear`.

`clear` specifies what should happen with the element that is next to a
floating element. It can have any of the following values:
- `none` (default): element is not pushed below left or right floated elements
- `left`: pushed below left floated elements
- `right`: pushed below right floated elements
- `both`: pushed below both left and right floated elements
- `inherit`: inherit value from parent element

When clearing floats, we should match the clear to the float.
If an element is floated left, then you should clear left.
```css
div1 {
  float: left;
}
div2 {
  clear: left;
}
```
The floated element will continue to float but the cleared elements
will appear below it on the page.

##### clearfix hack

If a floated element is taller than its containing element
it will "overflow" outside of the container.

We add a "clearfix" hack to solve the problem:
```css
.clearfix {
  overflow: auto;
}
```
This works as long as we can keep control of margins and padding.
This modern clearfix hack is safer to use:
```css
.clearfix::after { /* `::after` is a pseudo-element */
  content: "";
  clear: both;
  display: table;
}
```

##### `box-sizing`

_Note to self: Flexbox or grid is probably a better solution_

We could easily create three floating boxes side by side.
However, when you add something that enlarges the width of each box,
like padding or borders, the box will break.

`box-sizing` allows us to include the padding and border in the box's
total width (and height), making sure the padding stays inside the box
and that the box does not break.

```css
* {
  box-sizing: border-box;
}

.box {
  float: left;
  width: 33.33%; /* three boxes */
  padding: 50px; /* if we want space between the image */
}
```

### Horizontal and Vertical Align

#### Horizontally align

##### Set margin(s) to `auto`

To center a block element, like `<div>`, use `margin: auto`.
Setting the width of the element will prevent it from stretching
out to the edges of its container.

The element will then take up the specified width, and the remaining space
will be split equally between the two margins.
```css
.center {
  margin: auto;
  width: 50%;
  border: 3px solid green;
  padding: 10px;
}
```
_Note: center aligning has no affect if `width` is not set, or is `100%`._

As mentioned previously, `text-align: center` can be used to center text.

For images, set left and right margin to `auto` and make it a `block`.
```css
img {
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: 40%;
}
```

##### Using `position`

Use `position: absolute`:
```css
.right {
  position: absolute;
  right: 0px; /* This right-aligns it */
  width: 30px;
  border: 3px solid #73AD21;
  padding: 10px;
}
```

##### Using `float`

Or use `float`:
```css
.right {
  float: right;
  width: 300px;
  border: 3px solid #73AD21;
  padding: 10px
}
```
_Note: Remember the clearfix hack for resolving overflow issues_

#### Vertically

##### Using padding

Top and bottom padding can be used:
```css
.center {
  padding 70px 0;
  border 3px solid green;
}
```

##### Using Flexbox

```css
.center {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 200px;
  border: 3px solid green;
}
```

##### Using line-height

A trick is to use `line-height` with a value equal to `height`:
```css
.center {
  line-height: 200px;
  height: 200px;
  border: 3px solid green;
  text-align: center;
}
/* If text has multiple lines, add: */
.center p {
  line-height: 1.5;
  display: inline-block;
  vertical-align: middle;
}
```

##### Using `position` and `transform`

If `padding` and `line-height` are not options, another solution
is to use `position` and `transform`
```css
.center {
  position: relative;
  height: 200px;
  border: 3px solid green;
  text-align: center;
}

.center p {
  margin: 0;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
```

## Combinators

A combinator explains the relationship between selectors.

A CSS selector can contain more than one simple selector.
Between the simple selectors, we can include a combinator.

There are four different combinators in CSS:
- Descendent combinator (`<space>`)
- Child combinator (`>`)
- Next sibling combinator (`<`)
- Subsequent sibling combinator (`~`)

### Descendent combinator

Matches all elements that are descendants
Example: select all `<p>` inside `<div>` elements
```css
div p {
  background-color: yellow;
}
```
```html
<p>Paragraph 1.</p>

<div>
  <p>Paragraph 2.</p> <!-- YELLOW! -->
  <section>
    <p>Paragraph 2a</p> <!-- YELLOW! -->
</div>

<p>Paragraph 3.</p>
```

### Child combinator

Selects all elements that are children of a specified element.
Example: select all `<p>` that are children of a `<div>`
```css
div > p {
  background-color: yellow;
}
```
```html
<p>Paragraph 1.</p>

<div>
  <p>Paragraph 2.</p> <!-- YELLOW! -->
  <section>
    <p>Paragraph 2a</p>
</div>

<p>Paragraph 3.</p>
```
### Next sibling combinator

Selects an element that is directly after another specific element.
Sibling elements must have the same parent element,
and "adjacent" means "immediately following".

The following selects the first `<p>` element that are placed immediately
after `<div>` elements (`</div>` tags):
```css
div + p {
  background-color: yellow;
}
```
```html
<div>
  <p>Paragraph 1 in the div.</p>
  <p>Paragraph 2 in the div.</p>
</div>

<p>Paragraph 3. After a div.</p> <!-- YELLOW! -->
<p>Paragraph 4. After a div.</p>

<div>
  <p>Paragraph 5 in the div.</p>
  <p>Paragraph 6 in the div.</p>
</div>

<p>Paragraph 7. After a div.</p> <!-- YELLOW! -->
<p>Paragraph 8. After a div.</p>
```

### Subsequent-sibling combinator

Selects all elements that are next-siblings of a specified element.
Example: select all `<p>` that are next-siblings of `<div>` elements.
```css
div ~ p {
  background-color: yellow;
}
```
```html
<p>Paragraph 1.</p>

<div>
  <p>Paragraph 2.</p>
</div> <!-- All adjacent paragraphs afterwards are affected! -->

<section>
  <p>Not adjacent! Not affected!</p>
</section>

<p>Paragraph 3.</p> <!-- YELLOW! -->
<code>Some code.</code>  

<p>Paragraph 4.</p> <!-- YELLOW! -->
```

### Selector list

Can select all of different element types using a `,` as a delimiter.
```css
div, p {
  background-color: yellow;
}
```
### Namespace separator

Do I know what namespaces are right now? Not yet. Anyways.

Namespace separator `ns | h2`: Select all h2 elements inside namespace `ns`.

## Pseudo-classes

A pseudo-class is used to define a special state of an element.

For example, it can be used to style:
- an element when a mouse cursor hovers over it 
- visited and unvisited links
- an element when it gets focus
- valid/invalid/required/optional form elements

Syntax:
```css
selector:pseudo-class {
  property: value;
}
```

### Anchor Pseudo-classes

Pseudo-classes for links can impact the styling:
```css
/* unvisited link */
a:link {
  color: #FF0000;
}

/* visited link */
a:visited {
  color: #FF0000;
}

/* mouse over link */
a:hover {
  color: #FF0000;
}

/* active link */
a:active {
  color: #FF0000;
}
```
Note the order above matters! 
- `a:hover` must come after `a:link` and `a:visited` to be effective!
- `a:active` must come after `a:hover` to be effective!

### Input pseudo-classes

When we click an input field, it gets focus.
`:focus` allows styling in this state.
```css
input:focus {
  background-color: yellow;
}
```

We can disable an input field, disallowing text entry:
```css
input:disabled {
  background-color: gray;
}
```
Or set it back to its default pseudo-class, `:enabled`.

Similarly we can set it to `:read-only` to keep text but disallow alteration

`:required` selects those that are `required`
`:checked` selects radio buttons or checkboxes that are already checked.
`:placeholder-shown` can select where the `placeholder` attribute is specified
`:out-of-range` can select where `type="number" and the `max` and `min` attributes are violated

### Pseudo-classes with HTML classes

Pseudo-classes can be combined with HTML classes.
When you hover over `<a class="highlight" href=...>` it will change color:
```css
a.highlight:hover {
  color: #ff0000;
}
```

### Hover

Example: paragraph descendants of div will be display when hovering over div
```css
p {
  display: none;
  background-color: yellow;
  padding: 20px;
}

div:hover p {
  display: block;
}
```


### First-child and last-child pseudo-classes

The `:first-child` pseudo-class matches a specified element that is first
child of another element.

```css
/* matches the first <p> of any element */
p:first-child {
  color: blue;
}
/* matches first <i> in all <p> */
p i:first-child {
  color: blue;
}
/* matches all <i> in first child <p> */
p:first-child i {
  color: blue;
}
```

The `:last-child` pseudo-class can do the opposite, selecting the last child.

### Language pseudo-class

`:lang` allows us to define special rules for different languages.
```css
q:lang(no) {
  quotes: "~" "~";
}
```
```html
<p>
  Some text:
  <q lang="no">A quote in a paragraph</q>
  Some text.
</p>
```

## Pseudo-elements

A pseudo-element is used to style specific parts of an element.

Syntax (Notice the double-colon notation):
```css
selector::pseudo-element {
  property: value;
}
```
In previous versions of CSS (< 3) the single-colon notation could be used
for both pseudo-elements and -classes.
This backwards compatibility is maintained for older pseudo-elements.

### `::first-line` and `::first-letter`

Used to add special style to the first line of a text.

Example, formats the first line of the text in all `<p>` elements.
```css
p::first-line {
  color: #ff0000;
  font-variant: small-caps;
}
```

Likewise `::first-letter` can be used to select the first letter of a `<p>`

### Pseudo-elements and HTML classes

As pseudo-classes can be combined with HTML classes,
likewise can pseudo-elements with HTML classes:
```css
p.intro::first-letter {
  color: #ff0000;
  font-size: 200%;
}
```
Here we select the first letter of the paragraph with `class="intro"`.

### Multiple Pseudo-elements

Multiple pseudo-elements can be combined in separate declarations.
```css
p::first-letter {
  color: #ff0000;
  font-size: xx-large;
}
p::first-line {
  color: #0000ff;
  font-variant: small-caps;
}
```

### `::before` and `::after`

Can be used to insert content before the content of an element:
```css
h1::before {
  content: url(smiley.gif);
}
```
Similarly `::after` can be used to insert content after the content.

### `::marker`

Selects the markers of list items.
```css
::marker {
  color: red;
  font-size: 23px;
}
```

### `::selection`

Matches portion of element that is selected by a user.
Can apply `color`, `background`, `cursor`, and `outline` to it.
```css
::selection {
  color: red;
  background: yellow;
}
```

### `::backdrop`

Selects the backdrop, or space behind, a dialog element.

Style the background behind a dialog element.
```css
dialog::backdrop {
  background-color: lightgreen;
}
```
```html
<button id="dialogBtn">Show dialog</button>
<dialog id="myDialog">
  <form>
    <p>The background behind this dialog is a backdrop</p>
  </form>
</dialog>
<script>
const dialogBtn = document.getElementById('dialogBtn');
const dialog = document.getElementById('myDialog');

dialogBtn.addEventListener('click', () => myDialog.showModal());
</script>
```

## `::placeholder`

Selects the placeholder text of `<input>` or `<textarea>` elements.

## Opacity and transparency

`opacity` specifies the opacity and conversely transparency of an element.
It can take a value from 0.0 to 1.0, where lower values are more transparent
All child elements inherit the same transparency.

`opacity` is often used with `:hover` to change the opacity on mouse-over.

As seen with colors, `rgba()` and `hsla()` have alpha channel arguments.
Notably these do not apply opacity to child elements.
For example you could apply opacity for div background color and not text.

## Navigation Bars

Navigation bars are basically lists of links:
```html
<ul>
  <li><a href="default.asp">Home</a>></li>
  <li><a href="news.asp">News</a>></li>
  <li><a href="contact.asp">Contact</a>></li>
  <li><a href="about.asp">About</a>></li>
```

Bullets, padding, and margins can be removed:
```css
ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
}
```

### Vertical

For vertical navigation bars, we can further add:
```css
li a {
  display: block; /* Make box = whole link area clickable and stylize as box */
  width: 60px; /* Block elements take up full width by default */
} /* We could instead set width on the `<ul>` ancestor instead */
```

We can add mouse hover to change the colors:
```css
ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
  width: 200px;
  background-color: #f1f1f1;
}

li a {
  display: block;
  color: #000000;
  padding: 8px 16px;
  text-decoration: none;
}

li a:hover {
  background-color: #555555;
  color: white;
}
```

An `.active` class selection on the current link could inform the user
what page they're currently on.

We can create a fixed side nav bar:
```css
ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
  width: 200px;
  background-color: #f1f1f1;
  height: 100%; /* Full height */
  position: fixed; /* Stick even on scroll */
  overflow: auto; /* Enable scrolling if navbar has too much content */
}
```

## Horizontal

There are two ways to create horizontal nav bars.

Using `inline`:
```css
li {
  display: inline;
}
```
 By converting the `<li>` from inline to block, we remove the line breaks
before and after each item to display them on a single line.

Using `float`:
```css
li {
  float: left;
}
a {
  display: block;
  padding: 8px;
  background-color: #dddddd; /* For full-width move this to <ul> */
}
```

Some links or elements can be right-aligned:
```html
 <ul>
  <li><a href="#home">Home</a></li>
  <li><a href="#news">News</a></li>
  <li><a href="#contact">Contact</a></li>
  <li style="float:right"><a class="active" href="#about">About</a></li>
</ul>
```

Borders could be created with `border-right`:
```css
li {
  border-right: 1px solid #bbbbbb;
}
li:last-child {
  border-right: none;
}
```

The navigation bar can be fixed to stay at the top or bottom:
```css
ul {
  position: fixed;
  top: 0; /* could change property to bottom */
  width: 100%;
}
```
Note: Fixed position might not work properly on mobile.

A sticky navbar that doesn't fix until a given offset position is met in 
the viewport is met can be accomplished using `position: sticky`.
```css
ul {
  position: -webkit-sticky; /* Safari */
  position: sticky;
  top: 0;
}
```

### Responsive Navbar

It's common to have horizontal or side navbars for computer screens, 
and vertical nav bars for mobile screens.
This responsive navbar can be accomplished via media queries.

### Dropdown Navbar

Basically the idea is that one of the `<li>` can contain a
`<div>` that has `<a>` which also have `display: none;`
Upon `:hover` the display for the div is set to block
and the display of the anchors are set to in-line block.
```css
ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
  overflow: hidden; 
  background-color: #38444d;
}
li {
  float: left; /* Float for horizontal navbar */
}

li a, .drop-button { /* Navbar link boxes*/
  display: inline-block;
  color: white;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
}
li a:hover, .dropdown:hover .drop-button {
  background-color: red; /* Mouse over of navbar link boxes */
}
li.dropdown {
  display: inline-block;
}

.dropdown-content {
  display: none; /* Hide dropdown div (and children) by default */
  position: absolute;
  background-color: white;
  min-width: 160px;
  box-shadow: 0px 8px 16px 0px;
}
.dropdown-content a { /* the dropdown links */
  color: black;
  padding: 12px 16px;
  text-decoration: none;
  display: block;
  text-align: left;
}
/* Make dropdown visible */
.dropdown-content a:hover {
  background-color: #f1f1f1; /* and change link bg color upon hovering */
}
.dropdown:hover .dropdown-content {
  display: block;
}
```
```html
<ul>
  <li><a href="#home">Home</a></li>
  <li><a href="#news">News</a></li>
  <li class="dropdown">
    <a href="javascript:void(0)" class="drop-button">Dropdown</a>
    <div class="dropdown-content">
      <a href="#">Link 1</a>
      <a href="#">Link 2</a>
      <a href="#">Link 3</a>
    </div>
  </li>
</ul>
```

## Dropdowns

Dropdowns are boxes that appear when the user moves the mouse over an element.

Use any element to open dropdown content.
Use a container element e.g. `<div>` to create the dropdown and add whatever
you want inside of it.

`:hover` and combinators allow us to change the visibility of the dropdown
content when we hover over the dropdown button itself.
```css
.dropdown {
  position: relative;
  display: inline-block;
}

.dropdown-content {
  display: none;
  position: absolute;
  min-width: 160px;
  box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
  padding: 12px 16px;
  z-index: 1;
}

.dropdown:hover .dropdown-content { /* descendants of dropdown:hover */
  display: block; /* make visible */
}
```
```html
<div class="dropdown">
  <span>Mouse over me</span>
  <div class="dropdown-content">
    <p>Hello world!</p>
  </div> 
</div>
```
The `.dropdown` uses `position: relative` which allows us to place dropdown
content under the dropdown button.

Changing the dropdown content `min-width` to `width: 100%` would make it 
as wide as the dropdown button.

`overflow: auto` would enable scroll on small screens.

The `box-shadow` makes the dropdown menu look like a "card".

Using `right: 0` would make the dropdown menu right-aligned.

## Image Gallery

 ```css
div.gallery {
  margin: 5px;
  border: 1px solid #cccccc;
  float: left;
  width: 180px;
}
div.gallery:hover {
  border: 1px solid #777777;
}
div.gallery img {
  width: 100%;
  height: auto;
}
div.gallery desc {
  padding: 15px;
  text-align: center;
}
```
```html
<div class="gallery">
  <a target="_blank" href="img_5terre.jpg">
    <img src="img_5terre.jpg" alt="Cinque Terre" width="600" height="400">
  </a>
  <div class="desc">Add a description of the image here>
</div>
<div class="gallery">
  <!-- ... -->
</div>
```

### Responsive image gallery

Use media queries to make the content adjust for both desktops and mobile.
_Note: Flexbox is the more modern way of creating responsive layouts_

We introduce another div with class `"responsive"` to wrap the gallery.
```html
<div class="responsive">
  <div class="gallery">
    <a target="_blank" href="img_5terre.jpg">
      <img src="img_5terre.jpg" alt="Cinque Terre" width="600" height="400">
    </a>
    <div class="desc">Add a description of the image here</div>
  </div>
</div>
<div class="responsive"><!-- ... --></div>
<div class="responsive"><!-- ... --></div>
<div class="responsive"><!-- ... --></div>

<div class="clearfix"></div>
```

```CSS
/* gallery container */
div.gallery {
  border: 1px solid #ccc;
}
div.gallery:hover {
  border: 1px solid #777;
}

/* gallery content */
div.gallery img {
  width: 100%;
  height: auto;
}
div.desc {
  padding: 15px;
  text-align: center;
}
/* Include padding and border in total width and height for all elements */
* {
  box-sizing: border-box;
}

/* default responsive wrapper */
.responsive {
  padding: 0 6px;
  float: left;
  width: 24.99999%; /* 4 galleries per row */
}
/* Desktop smaller size:  add margins and 2 galleries per width */
@media only screen and (max-width: 700px) {
  .responsive {
    width: 49.99999%;
    margin: 6px 0;
  }
}
/* Mobile size: 1 gallery stretches the whole row */
@media only screen and (max-width: 500px) {
  .responsive {
    width: 100%;
  }
}

/* clearfix hack */
.clearfix:after {
  content: "";
  display: table;
  clear: both;
}
```

## Image sprites

An image sprite is a collection of images put into a single image.
A web page with many images can take a long time to load and generate
multiple server requests.
Using image sprites will reduce the number of requests and save bandwidth.

Instead of using 3 separate images we can use a single one that contains 3:
```css
#home {
  width: 43px;
  height: 44px;
  background: url(img_nav_sprites.gif) 0 0;
}
#prev {
  width: 43px;
  height: 44px;
  background: url(img_nav_sprites.gif) -47px 0;
}
#next {
  width: 43px;
  height: 44px;
  background: url(img_nav_sprites.gif) -91px 0;
}
```
```html
<img id="home" src="img_trans.gif" width="1" height="1">
<img id="prev" src="img_trans.gif" width="1" height="1">
<img id="next" src="img_trans.gif" width="1" height="1">
```
This could be used to create a navigation list.

If we had a 2x3 sprite sheet, where the first row contains the regular
sprites and the second row contains darker versions, we could use
the `:hover` pseudo-class to replace lighter sprites with their
darker counterparts.
```css
#home a:hover {
  background: url('img_nav_sprites_hover.gif') 0 -45px;
}
#prev a:hover {
  background: url('img_nav_sprites_hover.gif') -47px -45px;
}
#next a:hover {
  background: url('img_nav_sprites_hover.gif') -91px -45px;
}
```

## Attribute Selectors

We can style HTML elements that have specific attributes or attribute values.
Attribute selectors can be useful for styling forms without class or ID.

The `[attribute]` selector is used to select elements with specific attributes.
```css
a[target] { /* Select all <a> with `target` */
  background-color: yellow;
}
```

The `[attribute="value"]` selector can select elements with a specified
attribute and value
```css
a[target="_blank"] {
  background-color: yellow;
}
```

The `[attribute~="value"]` selector can select elements with an
attribute value containing the specified word:
```css
[title~="flower"] {
  border: 5px solid yellow
}
```
We'd match "summer flower" or "flower new".
It's a whole word matching, so no matches for "my-flower" or "flowers".

The `[attribute|="value"]` selector can select elements with the specified
attribute whose value can be _exactly_ the specified value, or 
the specified value followed by a hyphen.
```css
[class|="top"] {
  background: yellow;
}
```
The value has to be a whole word or followed by a hyphen and another word.
E.g. `top` or `top-text`.

The `[attribute^="value"]` selector selects element with the specified 
attribute whose value _starts with_ the specified value.
```css
[class^="top"] {
  background-color: yellow;
}
```
The value doesn't have to be a whole word.

The `[attribute$="value"]` selector selects elements with the specified
attribute whose value _ends with_ the specified value.
```css
[class$="test"] {
  background-color: yellow;
}
```
The value does not have to be a whole word.

The `[attribute*="value"]` selector selects elements whose attribute value
_contains_ the specified value.
```css
[class*="te"] {
  background-color: yellow;
}
```
The value does not have to be a whole word.

## Forms

The look of forms can be greatly improved with CSS.

We can use the `width` to determine the width of an input field.
```css
input {
  width: 100%;
}
```

We can use attribute selectors to apply to specific types of inputs:
- `input[type=text]`: Text fields
- `input[type=password]`: Password fields
- `input[type=number]`: Number fields
- etc.

We can use `padding` to add space inside a text field.
With many inputs one after another, you might want to add `margin` to keep
them a bit separated:
```css
input[type=text] {
  width: 100%;
  padding: 12px 20px;
  margin: 8px 0;
  box-sizing: border-box;
}
```

The `border` and `border-radius` properties can be used together to
add rounded corners:
```css
inp#ut[type=text] {
  border: 2px solid red;
  border-radius: 4px;
}
```

If we only wanted a bottom border, we could use `border-bottom`:
```css
input[type=text] {
  border: none;
  border-bottom: 2px dotted blue;
}
```
Maybe a bit unintuitive in modern design?

We can add colored backgrounds and inputs:
```css
input[text=type] {
  background-color: #3CBC8D;
  color: white;
}
```

With `:focus` we can style when the element gets clicked on.
```css
input[type=text] {
  border: 3px solid #777777
}
input[type=text]:focus {
  border: 3px solid #555555; /* Darker border */
}
```

We can put an icon inside the input using `background-image` and 
`background-position` properties:
```css
input[type=text] {
  background-color: white;
  background-image: url('search_icon.png'); /* Magnifying glass */
  background-position: 10px 10px;
  background-repeat: no-repeat;
  padding-left: 40px;
}
```

Animated search input can be accomplished using `transition`.
We can animate the width of the input when it gets focus:
```css
input[type=text] {
  transition: width 0.4s ease-in-out; /* animate width */
}
input[type=text]:focus { /* on focus */
  width: 100%; /* to full width */
}
```

We can use the `resize` property to prevent `<textarea>`s from being resized.
This disables the "grabber" in the bottom right which allows resizing.
```css
textarea {
  resize: none;
  width: 100%;
  height: 150px;
  padding: 12px 20px;
  box-sizing: border-box;
  border: 2px solid #cccccc;
  border-radius: 4px;
  background-color: #f8f8f8;
}
```

We can also style `<select>` menus similarly to `<input>`.
We can also style buttons via `input[type=...]`, where `type` is:
- `button`
- `submit`
- `reset`

Media queries can be used to make responsive layouts that have forms.

There are a number of pseudo-classes for input. See prior section about
pseudo-classes.

## Counters

Counters are "variables" maintained by CSS whose value can be incremented
by CSS rule (to track how many times they are used).

Counters let you adjust the appearance of content based on its 
placement within the document.

### Automatic numbering with Counters

To work with CSS counters, we will use the following properties:
- `counter-reset`: Creates or resets a counter
- `counter-increment`: Increment a counter value
- `content`: Inserts generated content
- `counter()` or `counters()` to add the value of a counter to an element

To use a counter, it must first be created with `counter-reset`.   

This example creates a counter for the page, then increments the value
for each `<h2>` and adds "Section <value of counter>:" to the start
of each `<h2>`:
```css
body {
  counter-reset: section;
}
h2::before {
  counter-increment: section;
  content: "Section " counter(section) ": ";
}
```
So we get automatic numbering of headers.


### Nesting Counters

The following creates one counter for the page (section) 
and one counter for each subsection.

```css
body {
  counter-reset: section;
}
h1 { 
  counter-reset: subsection;
}

h1::before {
  counter-increment: section;
  content: "Section " counter(section) ". ";
}

h2::before {
  counter-increment: subsection;
  content: counter(section) "." counter(subsection) " ";
}
```

A counter can also be used for numbering in nested lists
because a new instance is automatically created in each child element

Here we simply use one counter for the list `<ol>`:
```css
ol {
  counter-reset: section;
  list-style-type: none;
}
li::before {
  counter-increment: section;
  content: counters(section, ".") " ";
}
```

## Units

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

### Absolute units

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

### Relative lengths

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

## Specificity

If there are two or more rules that point to the same element,
the selector with the highest specificity value will win and apply its style.

Think of specificity as a score or rank that determines which style
declaration is ultimately applied to an element.

The more specific a selector is, the higher the specificity of the declaration.
```css
.im-specific {color: green;}
p {color: red;}
```
For `<p class="im-specific">` elements, they will be green rather than red
despite later declaring of red color for general `<p>` elements.

More thorough example:
```html
<html>
  <head>
    <style>
      #more-specific {color: blue;}
      .specific {color: green};
      p {color: red;}
    </style>
  </head>
  <body>

    <p id="more-specific" class="test" style="color: pink;">Hello!</p>

  </body>
</html>
```
ID selectors are more specific than class selectors,
but here the color will be pink and not blue, nor green, nor red.
In-line styles are given highest priority.

### Specificity Hierarchy

Every selector has its place in the hierarchy.

There are four categories which define the specificity level of a selector.
In order of specificity from highest to lowest:
1. Inline styles
2. IDs
3. classes, pseudo-classes, and attribute selectors
4. elements and pseudo-elements

_Note: ID selectors get higher specificity than attribute selectors for `id`._


### Calculating specificity

The total specificity of a declaration is the some of all selectors' specificity

Here are some examples of how to calculate specificity:

| Selector                   | Specificity Value | Calculation   |
| -------------------------- | ----------------- | ------------- |
| `*`                        | 0                 | 0 (ignored)   |
| `p`                        | 1                 | 1             |
| `.some-class`              | 10                | 10            |
| `p.some-class`             | 11                | 1 + 10        |
| `#some-id`                 | 100               | 100           |
| `p#some-id`                | 101               | 1 + 100       |
| `#some-id1 p#some-id2`     | 201               | 100 + 1 + 100 |
| `<p style="color: pink;>`  | 1000              | 1000          |
| `p.some-class.some-class2` | 21                | 1 + 10 + 10   |

Highest specificity applies to an element.
If there are ties, the winner is the latest declaration.

_Note: The `!important` rule is the exception as it will override
even inline styles!_

### The `!important` Rule

The `!important` rule adds more importance to a property/value than normal.

It will override ALL previous styling rules for that specific element.
```css
#some-id {
  background-color: blue;
}

.some-class {
  background-color: gray;
}

p { /* lowest specificity selector */
  background-color: red !important;
}
```
The background color will be red.

The only way to override an `!important` is to include another
`!important` in a declaration with the same or higher specificity

Usage of the `!important` rule can lead to confusion
so it's generally recommended to avoid using it.

## Math

CSS math functions allow mathematical expressions
to be used as property values

### `calc()`

`calc()` performs a calculation to be used as a property value.
`calc()` accepts an expression using `+`, `-`, `*`, or `/` operators

Example:
```css
#div1 {
  position: absolute;
  left: 50px;
  width: calc(100% - 100px);
  border: 1px solid black;
  background-color: yellow;
  padding: 5px;
}
```

## `max()` and `min()`

`max()` uses the largest submitted value as the property value.
`max()` accepts a comma-delimited list of values.
```css
#div1 {
  background-color: yellow;
  height: 100px;
  width: max(50%, 300px);
}
```

`min()` works the same way but the lowest submitted value is the result.

## Media queries

The `@media` rule was introduced in CSS2, making it possible to define
different style rules for different media types.

It was expanded in CSS3 to, instead of looking for device type, look at
device capabilities.

Media queries can be used to check many things such as:
- width and height of viewport
- orientation of the viewport
- resolution

Media queries are popular for delivering tailored style sheets to
desktops, laptops, tablets, and mobile phones.

Media queries accommodating style for these devices can produce
responsive layouts.
_Note: Flexbox is the modern solution for column layouts_

### Media types

`all`: Used for all devices
`print`: Used for print preview mode
`screen`: Used for computer screens, tablets, smart-phones, etc.

### Common media features

Commonly used media features:
- `orientation` of viewport, i.e. landscape or portrait
- `max-height` of viewport
- `min-height` of viewport
- `height` of viewport (including scrollbar)
- `max-width` of viewport
- `min-width` of viewport
- `width` of viewport (including scrollbar)

### Query Syntax

A media query consists of a media type and can contain one or more features
which can either resolve to true or false.
```css
@media not|only mediatype and (media feature) and (media feature) {
  /* corresponding style rules to apply if query result is true */
}
```
`mediatype` is optional, having a default of `all`.
If `not` or `only` are used, you must specify `mediatype`

Meaning of keywords:
- `and`: combines a media type and one or more media features
- `not`: inverts result of entire meaning query
- `only`: prevents old browsers which don't support media queries

A query result is true if the media type matches the type of device 
that the document is being displayed on and all media features are true.

When a media query is true, the corresponding style sheet or rules apply
following the normal cascading rules.

### Linking style sheets for different media

We can link to different stylesheets for different media and viewport settings:
```html
<link rel="stylesheet" media="print" href="print.css">
<link rel="stylesheet" media="screen" href="screen.css">
<link rel="stylesheet" media="screen and (min-width: 480px)" href="example1.css">
<link rel="stylesheet" media="screen and (min-width: 701px) and (max-width: 900px)" href="example2.css">
```

### Simple query example

If viewport is 480 pixels wide or wider, viewport will turn light green:
```css
body {
  background-color: pink;
}
@media screen and (min-width: 480px) {
  body {
    background-color: lightgreen;
  }
}
```

### Use cases

- Horizontal vs. vertical menu / navbar / dropdown layouts.
- (Flexbox advised instead) Column layouts
- Hiding elements
- Changing font size
- Resizing image galleries? (Flexbox or grid?)
- Generally making responsive layouts

### Orientation

If the viewport is wider than its height, we're in landscape orientation.
Otherwise we're in portrait.

We can use `orientation` to query:
```css
@media only screen and (orientation: landscape) {
  body {
    background-color: lightblue;
  }
}
```

### Multiple queries

We can set minimum and maximum widths to change style for a "middle" size:
```css
/* When width is between 600 and 900 pixels */
@media screen and (max-width: 900px) and (min-width: 600px) {
  div.example {
    font-size: 50px;
    padding: 50px;
    border: 8px solid black;
    background: yellow;
  }
}
```
Additionally we can add an additional media query:
```css
/* When width is between 600 and 900, or above 1100 pixels */
@media screen and (max-width: 900px) and (min-width: 600px), (min-width: 1100px) {
  div.example {
    font-size: 50px;
    padding: 50px;
    border: 8px solid black;
    background: yellow;
  }
}
```

## Flexbox

Before the Flexbox Layout module, there were four layout modes:
- Block, for sections in a webpage
- Inline, for text
- Table, for two-dimensional data
- Positioned, for explicit position of an element

The Flexible Box Layout Module made it easier to design flexible layout
structures without using `float` or positioning-related properties,

### Flex container

A flex container contains flex items.
A container can be made flex container using `display: flex`:
```css
.flex-container {
  display: flex;
}
```

The flex container properties are:
- `flex-direction`
- `flex-wrap`
- `flex-flow`
- `justify-content`
- `align-items`
- `align-content`

#### `flex-direction`

`flex-direction` defines the direction in which the container
wants to stack its flex items.

`column` value stacks items vertically top to bottom,
while `column-reverse` stacks them bottom to top,

`row` stacks items horizontally, left to right,
while `row-reverse` stacks them right to left.

#### `flex-wrap`

`flex-wrap` specifies whether flex items should wrap their content
with the changing of the container size or not.

The default, `nowrap` specifies that items will not wrap.

A value of `wrap` specifies the items will wrap if necessary:
```css
.flex-container {
  display: flex;
  flex-wrap: wrap;
}
```

`wrap-reverse` specifies the items will wrap only if necessary,
but in reverse order:

#### `flex-flow`

`flex-flow` is a shorthand for setting both `flex-direction` and `-wrap`!
```css
.flex-container {
  display: flex;
  flex-flow: row wrap;
}
```

#### `justify-content`

`justify-content` is used to align flex items:
- `center`: aligns at center of container
- `flex-start` (default): aligns at beginning of container
- `flex-end`: aligns at end of container
- `space-around`: displays with space before, between, and after lines
- `space-between`: displays with space between lines

Because of the padding, `space-around` is more centered 
and results in an more evenly spaced look than `space-between`.

#### `align-items`

`align-items` is used to align flex items in the other direction.
- `stretch`(default): stretches items to fill container
- `center`: aligns items in middle of container
- `flex-start`: aligns at top of container
- `flex-end`: aligns at the bottom of the container
- `baseline`: aligns such that item baselines align (think box plots)

#### `align-content`

`align-content` is used to align the flex lines of items (content):
- `space-between`: displays lines with equal space between them
- `space-around`: displays lines with space before, between, and after them
- `stretch` (default): stretches lines to take up the remaining space
- `center`: displays lines in the middle of the container
- `flex-start`: displays lines at the start of the container
- `flex-end`: displays lines at the end of the container

#### Perfect centering

Setting `justify-content` and `align-items` to `center` will perfectly
center an element.

### Flex items

The direct child elements of a flex container automatically become
flexible items.

The flex item properties are:
- `order`
- `flex-grow`
- `flex-shrink`
- `flex-basis`
- `flex`
- `align-self`

### `order`

`order` specifies the order of the items. The default value is 0.
A lower order will appear before a higher order.

E.g. for items with text numbered 1, 2, 3, and 4.
we can change the order of their appearance.
```html
<div class="flex-container">
  <div style="order: 3"> 1 </div>
  <div style="order: 2"> 2 </div>
  <div style="order: 4"> 3 </div>
  <div style="order: 1"> 4 </div>
</div>
```
They will now appear left to right as 4, 2, 1, 3.

### `flex-grow`

`flex-grow` specifies how much a flex item will grow relative to the rest.
By default, the value is 0.

```html
<div class="flex-container">
  <div style="flex-grow: 1"> 1 </div> 
  <div style="flex-grow: 1"> 2 </div> 
  <div style="flex-grow: 8"> 3 </div> 
</div>
```
Div 3 will grow 8 time faster than the other items.

### `flex-shrink`:

Specifies how much a flex item will shrink relative to the rest.
By default, the value is 1.

```html
 <div class="flex-container">
  <div>1</div>
  <div>2</div>
  <div style="flex-shrink: 0">3</div>
  <div>4</div>
</div> 
```
Don't let div 3 shrink as fast as the others.

### `flex-basis`

`flex-basis` specifies the initial length of a flex item.
```html
 <div class="flex-container">
  <div>1</div>
  <div>2</div>
  <div style="flex-basis: 200px">3</div>
  <div>4</div>
</div> 
```
Div 3's initial length is 200px.

### `flex` shorthand

The `flex` property is shorthand for `flex-grow`, `flex-shrink`, and
`flex-basis` properties.

```html
 <div class="flex-container">
  <div>1</div>
  <div>2</div>
  <div style="flex: 0 0 200px">3</div>
  <div>4</div>
</div> 
 ```
Make the third div not growable, shrinkable, and with initial length 200px.

### `align-self`:

`align-self` specifies alignment for the selected item.
It overrides the default alignment set by the container's `align-items`.


### Responsive Flexbox

Media queries can be used with Flexbox to create responsive layouts.

For example, we could change multi-column layouts to a one-column
layout for small screen sizes by changing `flex-direction`:
```css
.flex-container {
  display: flex;
  flex-direction: row;
}

@media (max-width: 800px) {
  .flex-container {
    flex-direction: column;
  }
}
```

Or change the percentage of the `flex` values of flex items to create
layouts for different screen sizes. We need to use `flex-wrap: wrap` too.
```css
.flex-container {
  display: flex;
  flex-wrap: wrap;
}

.flex-item-a {
  flex: 50%;
}
.flex-item-b {
  flex: 50%;
}

@media (max-width: 800px) {
  .flex-item-a, .flex-item-b {
    flex: 100%
  }
}
```

## Grid

TODO:

## 2D Transforms

`transform` allows moving, rotating, scaling, and skewing of elements in 2D.

### `translate()`

`translate()` moves an element from its current position 
to a new position as determined by adding the the inputted X and Y lengths.
```css
div {
  transform: translate(50px, 100px); /* 50 pixels right, 100 down */
}
```
Negative values for X move left,
and negative values for Y move up.
Tip: (0, 0) coords are top-left. Positive values progress us thru the page.

`translateX` and `translateY` are individual functions for each axis.

### `rotate()`

Rotates an element clockwise/counter-clockwise according to inputted degree.
```css
div {
  transform: rotate(20deg); /* 20 degrees clockwise */
}
```
Negative values will rotate counter-clockwise.

### `scale()`, `scaleX()`, and `scaleY()`

`scale()` increases or decreases the size of an element
according to parameters given for width and height.

```css
div {
  transform: scale(2, 3); /* become 2 times wider, 3 times taller */
}
```
Floats are allow. E.g. `scale(0.5, 0.5)` would make half as wide and tall.

`scaleX()` increases or decreases the width only.
`scaleY()` increases or decreases the height only.

### `skew`, `skewX()` and `skewY()`

`skew()` skews an element along both X and Y axes by the given angles.
```css
div {
  transform: skew(20deg, 10deg); /* 20 x-axis, 100 y-axis */
}
```
Default values are 0.

`skewX()` skews an element along the X-axis by the given angle.
```css
div {
  transform: skewX(20deg); /* skew 20 degrees along x-axis */
}
```

`skewY()` skews an element along the Y-axis by the given angle.
```css
div {
  transform: skewY(20deg); /* skew 20 degrees along y-axis */
}
```

### `matrix()` method

The `matrix()` method combines all 2D transform methods into one.
```
matrix(scaleX(), skewY(), skewX(), scaleY(), translateX(), translateY())
```

## 3D Transforms

We can also transform elements in 3D.

We likewise use the `transform` property.

### `rotateX()`, `rotateY`, and `rotateZ`

Rotates an element around its x-axis for the given degree.
```css
div {
  transform: rotateX(150deg);
}
```

`rotateY()` does the same but on the y-axis.
`rotateZ()` does the same but on the z-axis.
`rotate3d()` is shorthand for all three.

### 3D counterparts of `scale`, `translate`, and `matrix`

Likewise, we can scale or translate objects along the Z axis.
These functions have Z axis functions and 3d shorthands.

matrix has a 3d counterpart

Does any of this make sense or is useful? Idk.

### Other stuff?

There are some other properties like 
- `perspective`: specifies perspective view for a 3D-transformed element
- `backface-visibility`: whether should be visible when not facing screen

There is also a `perspective()` method.

## Transitions

Transitions allow changing values smoothly over a given duration.

To create a transition we must specify two things:
1. the property we want to add an affect to
2. the duration of the effect (default value of 0)

_Note: If duration is not specified, transition will have no effect_

Example: 100px by 100px red `<div>` expanding width over 2 seconds:
```css
div {
  width: 100px;
  height: 100px;
  background: red;
  transition: width 2s;
}
```
The transition won't take effect until the `width` is changed.
```css
div:hover {
  width: 300px;
}
```
Now on mouse hover, the transition will trigger.

We can specify multiple properties to change with a single `transition`:
```css
div {
  transition: width 2s, height 4s, transform 2s;
}
```
The transitions are delimited by comma.

### Specify the speed curve of the transition

`transition-timing-function` property specifies 
the speed curve of the transition effect.

- `ease` (default): effect with slow start, then fast, then slow
- `linear`: effect with same speed from start to end
- `ease-in`: effect with slow start
- `ease-out` effect with slow end
- `ease-in-out` transition with slow start and end
- `cubic-bezier(n,n,n,n)`: Define our own values in a cubic-bezier function

The `transition-delay` property specifies a delay for the transition effect.
```css
div {
  transition-delay: 1s;
}
```

### Individual transition properties

`transition` is actually shorthand for individual transition properties:

We could individually specify them:
```css
div {
  transition-property: width;
  transition-duration: 2s;
  transition-timing-function: linear;
  transition-delay: 1s;
}
```
Which is the same as this shorthand:
```css
div {
  transition: width 2s linear 1s;
}
```
## Animations

We can animate HTML elements without using JavaScript!

An animation lets an element gradually change from one style to another.

We can change as many properties as we want, as many times as we want.

We must first specify keyframes for the animation.

Keyframes hold what styles the elements will have at certain times.

### The `@keyframes` Rule

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

### Properties 

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

### Specifying the Fill-mode

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

### `animation` shorthand

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

## CSS Tooltip

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


