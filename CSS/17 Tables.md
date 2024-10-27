# CSS Tables
#css #tables #html #border #collapse #width #alignment #hover

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

For "zebra-striped" tables, the `nth-child()` selector can be used:
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
