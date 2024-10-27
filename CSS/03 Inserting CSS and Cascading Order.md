# Inserting CSS and Cascading Order
#css #inline #cascading #html

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

## Cascading Order

All the styles in a page will "cascade" into a new "virtual" style sheet
by the following rules, where number one has the highest priority. 

1. Inline (within an element)
2. External and internal (within the `<head>` element)
3. Browser default
