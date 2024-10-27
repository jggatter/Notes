# CSS Image Galleries
#css #images #float #clearfix #responsive #flexbox

An image gallery contains images for display and interaction.
Galleries should obey responsive design to adapt to different sized screens.

Using `float` and `:hover`:
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

## Responsive image gallery

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
