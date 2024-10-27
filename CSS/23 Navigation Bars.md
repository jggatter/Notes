# CSS Navigation Bars
#css #layout #navbars #dropdown #float #inline #inline-block

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

## Vertical Navbar

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

## Horizontal Navbar

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

## Responsive Navbar

It's common to have horizontal or side navbars for computer screens, 
and vertical nav bars for mobile screens.
This responsive navbar can be accomplished via media queries.

## Dropdown Navbar

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
