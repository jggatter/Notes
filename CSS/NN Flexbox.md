# CSS Flexbox
#css #flexbox #float #position

Before the Flexbox Layout module, there were four layout modes:
- Block, for sections in a webpage
- Inline, for text
- Table, for two-dimensional data
- Positioned, for explicit position of an element

The Flexible Box Layout Module made it easier to design flexible layout
structures without using `float` or positioning-related properties,

The [Flexbox Froggy](https://flexboxfroggy.com/) game is a great way
to learn and refresh yourself on Flexbox!

## Flex container

A flex container contains flex items.
A container can be made flex container using `display: flex` (block)
or `display: inline-flex` (inline):
```css
.flex-container {
  display: flex; /* block flex container */
}
```

Whether the container itself is block or inline does not affect the items.
Flex items always will have block (and some inline block) properties.

## Axes

![Flexbox Axes](https://css-tricks.com/wp-content/uploads/2018/11/00-basic-terminology.svg)
[Source: css-tricks.com article on terminology](https://css-tricks.com/snippets/css/a-guide-to-flexbox/#aa-basics-and-terminology)

The size across the main axis of flexbox is called the main size, the other direction is the cross size. Those sizes have a main start, main end, cross start, and cross end.

Items will be laid out following either the `main axis` (from `main-start` to `main-end`) or the cross axis (from `cross-start` to `cross-end`).

- __main axis__ – The main axis of a flex container is the primary axis along which flex items are laid out. Beware, it is not necessarily horizontal; it depends on the `flex-direction` property (see below).
- __main-start | main-end__ – The flex items are placed within the container starting from main-start and going to main-end.
- __main size__ – A flex item’s width or height, whichever is in the main dimension, is the item’s main size. The flex item’s main size property is either the ‘width’ or ‘height’ property, whichever is in the main dimension.
- __cross axis__ – The axis perpendicular to the main axis is called the cross axis. Its direction depends on the main axis' direction.
- __cross-start | cross-end__ – Flex lines are filled with items and placed into the container starting on the cross-start side of the flex container and going toward the cross-end side.
- __cross size__ – The width or height of a flex item, whichever is in the cross dimension, is the item’s cross size. The cross size property is whichever of ‘width’ or ‘height’ that is in the cross dimension.

## Properties

The flex container properties are:
- `flex-direction`
- `flex-wrap`
- `flex-flow`
- `justify-content`
- `align-items`
- `align-content`

### `flex-direction`

`flex-direction` defines the direction in which the container
wants to stack its flex items.

`column` value stacks items vertically top to bottom,
while `column-reverse` stacks them bottom to top,

`row` stacks items horizontally, left to right,
while `row-reverse` stacks them right to left.

### `flex-wrap`

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

### `flex-flow`

`flex-flow` is a shorthand for setting both `flex-direction` and `-wrap`!
The two properties are used often together.

E.g. set rows and wrap them:
```css
.flex-container {
  display: flex;
  flex-flow: row wrap;
}
```

### `justify-content`

`justify-content` aligns items __horizontally__ along the _main axis_.

Values:
- `center`: aligns at center of container
- `flex-start` (default): aligns at beginning of container
- `flex-end`: aligns at end of container
- `space-around`: displays with space before, between, and after lines
- `space-between`: displays with space between lines

Because of the padding, `space-around` is more centered 
and results in an more evenly spaced look than `space-between`.

### `align-items`

`align-items` aligns items __vertically__ along the _cross axis_.

Values:
- `stretch`(default): stretches items to fill container
- `center`: aligns items in middle of container
- `flex-start`: aligns at top of container
- `flex-end`: aligns at the bottom of the container
- `baseline`: aligns such that item baselines align (think box plots)

### `align-content`

`align-content` determines the spacing between flex lines 
The flex lines are lines of flex items, i.e. the content.
When there is only one line, `align-content` has no effect.

In contrast, `align-items` determines how the items as a whole are aligned within the container.

Values of `align-content`:
- `flex-start`: pack lines at the start/top of the container
- `flex-end`: pack lines at the end/bottom of the container
- `center`: pack lines at the vertical center/middle of the container
- `space-between`: displays lines with equal space between them
- `space-around`: displays lines with space before, between, and after them
- `stretch` (default): stretches lines to take up the remaining space

### Perfect centering

Setting `justify-content` and `align-items` to `center` will perfectly
center an element.

## Flex items

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

Sometimes reversing the row or column order of a container is not enough.

`order` specifies the order of the items.
A lower order item will appear before a higher order item.
By default, items have a value of 0, but the property
can be set to a positive or negative integer value (-2, -1, 0, 1, 2, etc.).
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
It's a proportion so it accepts a unit-less value.
It dictates what amount of space within the flex container it should take up.
By default, the value is 0.

If all items have `flex-grow` of 1, the remaining space will be distributed
equally to all children.
If one value has a value of `2`, that child would take up twice as much space
as any of the others (or it will try to, at least).

```html
<div class="flex-container">
  <div style="flex-grow: 1"> 1 </div> 
  <div style="flex-grow: 1"> 2 </div> 
  <div style="flex-grow: 8"> 3 </div> 
</div>
```
Div 3 will grow 8 time faster than the other items.

### `flex-shrink`:

`flex-shrink` is the opposite of `flex-grow`, letting items shrink.

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

`flex-basis` specifies the initial length of a flex item
before the remaining space is distributed.

It can be a length (e.g. `20%`, `5rem`, etc.)
or it can be a keyword.
The `auto` keyword means "look at my width or height property".

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
Only `flex-grow` is required, the rest are optional.
The default is `0 1 auto`.

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

Like `align-items` but applies to individual items!

`align-self` specifies alignment for the selected item.
It overrides the default alignment set by the container's `align-items`.

```css
#pond {
  display: flex;
  align-items: flex-start;
}

/* yellow frogs align to other end (bottom) of pond */
.yellow {
  align-self: flex-end
}
```

## Responsive Flexbox

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
