# CSS Grid

## Defining a grid container

```css
#garden {
  display: grid;
  grid-template-columns: 20% 20% 20% 20% 20%;
  grid-template-rows: 20% 20% 20% 20% 20%;
}
```

`display: grid` converts it into a grid container and we define the 5 columns and 5 rows to each take up 20% of the space.

## Column start and end
### `grid-column-start`

Specify a grid item's column start position from the left, one-indexed.
```css
#water {
  grid-column-start: 3;
}
```
Places it in the top row, third column.

### `grid-column-end`

Specify the end position within the grid's column.
```css
#water {
  grid-column-start: 1;
  grid-column-end: 4;
}
```
The water goes from column 1 to column 3 of the first row. The larger position (end in this case) is exclusive.

### Switching them up
You can actually go the other way with these two values!
```css
#water {
  grid-column-start: 5;
  grid-column-end: 2;
}
```
This will water columns 2 through 4. Notice that the start position is now exclusive and the end is inclusive.

### Right to left
Negative values will allow you to count from the rightmost column instead of the leftmost.
```css
#water {
  grid-column-start: 1;
  grid-column-end: -2;
}
```
Waters plants 1 through 4.
```css
#poison {
  grid-column-start: -3;
}
```
Poisons column 4. `-2` is the last column.

### `span` keyword

`span` can instead be used as a keyword argument for `grid-column-end` or `-start` to determine the length.
```css
#water{
  grid-column-start: 2;
  grid-column-end: span 2;
}
```
We water two columns, 2 and 3.

```css
#water {
  grid-column-start: span 3;
  grid-column-end: 6;
}
```
We water three columns, 3 through 5.

### `grid-column` shorthand

This is the shorthand property for `-start` and `-end`. It can accept both values at once separated by a slash.
```css
#water {
  grid-column: 4 / 6;
}
```
We water columns 4 and 5.

```css
#water {
  grid-column: 2 / span 3
}
```
We water 2 through 4.

## `grid-row-start` and `grid-row-end`

Same deal as the column counterpart.

```css
#water {
  grid-column: 2;
  grid-row: 5;
}
```
We water the 2nd column 5th row.

```css
#water {
  grid-column: 2 / span 4;
  grid-row: 1 / 6;
}
```
We water all the rows columns 2 through 5 (We water everything but column 1).

## `grid-area`

Is shorthand for both `grid-row` and `grid-column`!

We start with row-start, column-start, then row-end and column-end.

```css
#water {
  grid-area: 1 / 2 / 4 / 6;
}
```

We can overlap multiple items.
```css
#water-1 {
  grid-area: 1 / 4 / 6 / 5;
}

#water-2 {
  grid-area: 2 / 3 / span 3 / span 3;
}
```
water-1 covers just the 4th column, then water-2 covers a 3x3 overlapping area.

## `order`

If grid items aren't explicitly placed with the above properties, then they are automatically placed according  to their order in the source code. We can override this using `order`, which is an advantage of grid over the table-based layout.

By default, all grid items have an order of 0, but this can be set to any positive or negative value, similar to the z-index.

```css
.water {
  order: 0;
}

#poison {
  order: 0;
}
```
The water takes up the first spot, then the poison on the second, then the rest is water. We move the poison to be after the 4 water tiles by increasing its order:
```css
.water {
  order: 0;
}

#poison {
  order: 1;
}
```
Order is kinda like priority it seems.

```css
.water {
  order: 0;
}

#poison {
  order: 0;
}
```
The poison and water alternate for the first two rows until we give poison a negative order to place it before all the water.
```css
.water {
  order: 0;
}

#poison {
  order: -1;
}
```

## `grid-template-columns`

One column, the other 50% of the columnar space is empty in the container!
```css
#garden {
  display: grid;
  grid-template-columns: 50%;
  grid-template-rows: 20% 20% 20% 20% 20%;
}
```
Now both are filled to take up their respective half of the columnar space:
```css
#garden {
  display: grid;
  grid-template-columns: 50% 50%;
  grid-template-rows: 20% 20% 20% 20% 20%;
}
```

### `repeat` function

The `repeat` keyword argument can remove the redundancy of specifying the same lengths over and over:
```css
#garden {
  display: grid;
  grid-template-columns: repeat(5, 20%);
  grid-template-rows: repeat(5, 20%);
}
```
The number of times is the first argument, the length is the second.

### Units

You can also use other length units like `em`, `px`, and even mix them together:
```css
#garden {
  display: grid;
  grid-template-columns: 100px 3em 40%;
  grid-template-rows: repeat(5, 20%);
}
```

The `fr` is a new unit specific for grid. It is the fractional share of the available space. It's ratios basically.

Here the first item takes up 1/6th and the second takes up 5/6th of the space.
```css
#garden {
  display: grid;
  grid-template-columns: 1fr 5fr;
  grid-template-rows: repeat(5, 20%);
}
```

When used with other units, `fr` will divvy up the remaining space. Here the remaining columnar space in the middle is broken up evenly into three parts:
```css
#garden {
  display: grid;
  grid-template-columns: 50px 1fr 1fr 1fr 50px;
  grid-template-rows: 20% 20% 20% 20% 20%;
}

#water {
  grid-area: 1 / 1 / 6 / 2;
}

#poison {
  grid-area: 1 / 5 / 6 / 6;
}
```

## `grid-template-rows`

Works the same as its columnar counterpart.

Water is set to only fill the 5th row. This waters all except the first 50px of row space.
```css
#garden {
  display: grid;
  grid-template-columns: 20% 20% 20% 20% 20%;
  grid-template-rows: 50px 0fr 0fr 0fr 1fr
}

#water {
  grid-column: 1 / 6;
  grid-row: 5 / 6;
}
```

## `grid-template` shorthand

This combines the `grid-template-rows` and `-columns` properties. Rows first then columns

This creates two rows that take up 50% each and a single column that only takes up 200px.
```css
#garden {
  display: grid;
  grid-template: 50% 50% / 200px
}

#water {
  grid-column: 1;
  grid-row: 1;
}
```

Here the poison has order 0 and the water has order 1. The left 20% is weeds, the bottom 50px is empty space, and the rest are carrots. We poison the weeds and water the carrots by doing:
```css
#garden {
  display: grid;
  grid-template: 1fr 50px / 20% 1fr
}
```