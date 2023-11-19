https://flexboxfroggy.com/

## Terminology

https://css-tricks.com/snippets/css/a-guide-to-flexbox/#aa-basics-and-terminology
![A diagram explaining flexbox terminology. The size across the main axis of flexbox is called the main size, the other direction is the cross size. Those sizes have a main start, main end, cross start, and cross end.](https://css-tricks.com/wp-content/uploads/2018/11/00-basic-terminology.svg)
Items will be laid out following either the `main axis` (from `main-start` to `main-end`) or the cross axis (from `cross-start` to `cross-end`).

- **main axis** – The main axis of a flex container is the primary axis along which flex items are laid out. Beware, it is not necessarily horizontal; it depends on the `flex-direction` property (see below).
- **main-start | main-end** – The flex items are placed within the container starting from main-start and going to main-end.
- **main size** – A flex item’s width or height, whichever is in the main dimension, is the item’s main size. The flex item’s main size property is either the ‘width’ or ‘height’ property, whichever is in the main dimension.
- **cross axis** – The axis perpendicular to the main axis is called the cross axis. Its direction depends on the main axis direction.
- **cross-start | cross-end** – Flex lines are filled with items and placed into the container starting on the cross-start side of the flex container and going toward the cross-end side.
- **cross size** – The width or height of a flex item, whichever is in the cross dimension, is the item’s cross size. The cross size property is whichever of ‘width’ or ‘height’ that is in the cross dimension.

## `display`

This defines a flex container; inline or block depending on the given value. It enables a flex context for all its direct children.

- `inline`: Display an element as an inline element, e.g. `<span>`. Any height or width properties have no effect
- `block`: Displays an element as a block element, e.g. `<p>`. Starts on a new line and takes up the entire width
- `flex`: Displays an element as a block-level flex container
- `inline-flex`:  Displays an element as an inline-level flex container|

## `justify-content`

Aligns items **horizontally** along the _main axis_ and accepts the following values:

- `flex-start`: Items align to the left side of the container.
- `flex-end`: Items align to the right side of the container.
- `center`: Items align at the center of the container.
- `space-between`: Items display with equal spacing between them.
- `space-around`: Items display with equal spacing around them.
## `align-items`

Aligns items **vertically** along the _cross axis_ and accepts the following values:

- `flex-start`: Items align to the top of the container.
- `flex-end`: Items align to the bottom of the container.
- `center`: Items align at the vertical center of the container.
- `baseline`: Items display at the baseline of the container.
- `stretch`: Items are stretched to fit the container.

## `flex-direction`

Defines the direction items are placed in the container, and accepts the following values:

- `row`: Items are placed the same as the text direction.
- `row-reverse`: Items are placed opposite to the text direction.
- `column`: Items are placed top to bottom.
- `column-reverse`: Items are placed bottom to top.
## `order`

Sometimes reversing the row or column order of a container is not enough. In these cases, we can apply the `order` property to individual items. By default, items have a value of 0, but we can use this property to also set it to a positive or negative integer value (-2, -1, 0, 1, 2).

## `align-self`
Like `align-items` but applies to individual items!

```css
#pond {
  display: flex;
  align-items: flex-start;
}

.yellow {
  align-self: flex-end
}
```

## `flex-wrap`

- `nowrap`: Every item is fit to a single line.
- `wrap`: Items wrap around to additional lines.
- `wrap-reverse`: Items wrap around to additional lines in reverse.

## `flex-flow`

The two properties `flex-direction` and `flex-wrap` are used so often together that the shorthand property `flex-flow` was created to combine them. This shorthand property accepts the value of the two properties separated by a space.

For example, you can use `flex-flow: row wrap` to set rows and wrap them.

## `align-content`

`align-content` determines the spacing between lines, while `align-items` determines how the items as a whole are aligned within the container. When there is only one line, `align-content` has no effect.

- `flex-start`: Lines are packed at the top of the container.
- `flex-end`: Lines are packed at the bottom of the container.
- `center`: Lines are packed at the vertical center of the container.
- `space-between`: Lines display with equal spacing between them.
- `space-around`: Lines display with equal spacing around them.
- `stretch`: Lines are stretched to fit the container.
## Other

### `flex-grow` and `flex-shrink`

`flex-grow` accepts a unitless value that serves as a proportion. It dictates what amount of the available space inside the flex container the item should take up.

If all items have `flex-grow` set to `1`, the remaining space in the container will be distributed equally to all children. If one of the children has a value of `2`, that child would take up twice as much of the space either one of the others (or it will try, at least).

`flex-shrink` is the opposite, letting items shrink.

### `flex-basis`

This defines the default size of an element before the remaining space is distributed. It can be a length (e.g. 20%, 5rem, etc.) or a keyword. The `auto` keyword means “look at my width or height property”

### `flex`

This is the shorthand for `flex-grow,` `flex-shrink` and `flex-basis` combined. The second and third parameters (`flex-shrink` and `flex-basis`) are optional. 

The default is `0 1 auto`.