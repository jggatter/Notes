# CSS Images
#css #images #html

We can style images in CSS.

Images are essentially in-line block elements:
- Technically they're in-line in the browser's eyes
- They follow the flow of text
- But they have block-like properties

## Rounded images

`border-radius` can create rounded images:
```css
img {
  border-radius: 8px; /* slightly rounded */
}
```
```css
img {
  border-radius: 50%; /* slightly rounded */
}
```

## Thumbnail images

We can use `border` to create thumbnail images:
```css
img {
  border: 1px solid #dddddd;
  border-radius: 4px;
  padding: 5px;
  width: 150px;
}

img:hover {
  box-shadow: 0 0 2px 1px rgba(0, 140, 186, 0.5);
}
```
```html <a href="paris.jpg">
  <img src="paris.jpg" alt="Paris">
</a>
```

We can also use `opacity` to give images transparency.
This can be useful for thumbnail links with `:hover`.

### Responsive images

Responsive images will automatically adjust to fit the size of the screen.

If we want the image to scale down if needed,
but never scale up past its original size:
```css
img {
  max-width: 100%;
  height: auto;
}
```

### Center an image

This can be done by setting left and right margin to `auto`
and making it a `block` element:
```css
img {
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: 50%
}
```

### Cards

A polaroid-picture-like card:
```css
/* The card container */
div.polaroid {
  width: 80%;
  background-color: white;
  box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0,0,0,0.19);
}

/* The image */
div.polaroid > img {
  width: 100%;
}

/* Below the image where the caption goes */
div.container {
  text-align: center;
  padding: 10px 20px;
}
```
```html
<div class="polaroid">
  <img src="lights600x400.jpg" alt="NorthernLights" style="width:100%">
  <div class="container">
    <p>Northern Lights</p>
  </div>
</div>
```

### Image Filters

We can use `filter` to apply filters!

Gray-scale (black and white):
```css
img {
  filter: grayscale(100%);
}
```

Other filters:
- `none` (default)
- `blue(px)`
- `brightness(%)`
- `contrast(%)`
- `sepia(%)`
- `saturate(...)`
- `hue-rotate(deg)`
- ... many more

### Image Hover Overlay

Get an overlay with text to appear when we hover the mouse over an image:
```html
<div class="container">
  <img src="img_avatar.png" alt="avatar" class="image">
  <div class="overlay">
    <div class="text">Hello world</div>
  </div>
</div>
```

#### Fade-in text:
```css
.container {
  position: relative;
  width: 50%
}

.image {
  display: block;
  width: 100%;
  height: auto;
}

.overlay {
  display: flex;  
  justify-content: center; 
  align-items: center;
  position: absolute; /* 0 0 0 0 means overlap */
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  height: 100%;
  width: 100%;
  opacity: 0;
  transition: 0.5s ease;
  background-color: #008CBA;
}

.container:hover .overlay {
  opacity: 0.7; /* become visible on hover */
}

.text {
  color: white;
  font-size: 1.5em;
}
```

#### Fade-in box:

We would just make:
1. the text box have some `background-color` and `padding`
2. the image loses `opacity` on hover

#### Slide-in:

We can slide in from any direction, let's say top:
The overlay starts with height 0 at the top,
then hovering transitions it to a height of 100

### Flip an image

```css
img:hover {
  transform: scaleX(-1);
}
```

### Image modal

Use CSS to create a modal window (dialog box), and hide it by default.

```html
<img id="myImg" src="img_lights.jpg" alt="Northern Lights, Norway" width="300" height="200">

<!-- The Modal -->
<div id="myModal" class="modal">
  <span class="close">&times;</span>
  <img class="modal-content" id="img01">
  <div id="caption"></div>
</div>
```

I'm skipping the CSS cuz it's a lot.

Then use JavaScript to show the modal window and display the image inside
it upon the user clicking the image.
```javascript
// Get the modal
var modal = document.getElementById('myModal');

// Get image and insert in the modal
// using the alt text as the caption
var img = document.getElementById('myImg');
var modalImg = document.getElementById('img01');
var captionText = document.getElementById('caption');
img.onclick = () => {
  modal.style.display = 'block';
  modalImg.src = this.src;
  captionText.innerHTML = this.alt;
}

// Get the span that closes the modal
var span = document.getElementsByClassName("close")[0];
// When user clicks span (x) we close the modal
span.onclick = () => {
  modal.style.display = "home";
}
```

### Image reflection

Note: This isn't supported on Firefox.

`box-reflect` is used to create image reflections. Values can be:
- `below`
- `above`
- `left`
- `right`
