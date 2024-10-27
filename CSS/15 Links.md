# CSS Links
#css #link #button #decoration #line #pseudo-class #html

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

## Removing underlines

As mentioned, the `text-decoration: none;` can be used to remove underlines.

## Link buttons

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
