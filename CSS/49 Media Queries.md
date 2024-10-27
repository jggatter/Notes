# CSS Media Queries
#css #media-queries #responsive #flexbox #viewport #width #navbars #font #images

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

## Media types

`all`: Used for all devices
`print`: Used for print preview mode
`screen`: Used for computer screens, tablets, smart-phones, etc.

## Common media features

Commonly used media features:
- `orientation` of viewport, i.e. landscape or portrait
- `max-height` of viewport
- `min-height` of viewport
- `height` of viewport (including scrollbar)
- `max-width` of viewport
- `min-width` of viewport
- `width` of viewport (including scrollbar)

## Query Syntax

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

## Linking style sheets for different media

We can link to different stylesheets for different media and viewport settings:
```html
<link rel="stylesheet" media="print" href="print.css">
<link rel="stylesheet" media="screen" href="screen.css">
<link rel="stylesheet" media="screen and (min-width: 480px)" href="example1.css">
<link rel="stylesheet" media="screen and (min-width: 701px) and (max-width: 900px)" href="example2.css">
```

## Simple query example

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

## Use cases

- Horizontal vs. vertical menu / navbar / dropdown layouts.
- (Flexbox advised instead) Column layouts
- Hiding elements
- Changing font size
- Resizing image galleries? (Flexbox or grid?)
- Generally making responsive layouts

## Orientation

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

## Multiple queries

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
