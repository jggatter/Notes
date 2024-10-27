# CSS Lists
#css #lists #markers #images #position #html

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
