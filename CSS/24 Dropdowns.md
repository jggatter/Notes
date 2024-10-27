# CSS Dropdowns
#css #dropdowns #navbars

Dropdowns are boxes that appear when the user moves the mouse over an element.

Use any element to open dropdown content.
Use a container element e.g. `<div>` to create the dropdown and add whatever
you want inside of it.

`:hover` and combinators allow us to change the visibility of the dropdown
content when we hover over the dropdown button itself.
```css
.dropdown {
  position: relative;
  display: inline-block;
}

.dropdown-content {
  display: none;
  position: absolute;
  min-width: 160px;
  box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
  padding: 12px 16px;
  z-index: 1;
}

.dropdown:hover .dropdown-content { /* descendants of dropdown:hover */
  display: block; /* make visible */
}
```
```html
<div class="dropdown">
  <span>Mouse over me</span>
  <div class="dropdown-content">
    <p>Hello world!</p>
  </div> 
</div>
```
The `.dropdown` uses `position: relative` which allows us to place dropdown
content under the dropdown button.

Changing the dropdown content `min-width` to `width: 100%` would make it 
as wide as the dropdown button.

`overflow: auto` would enable scroll on small screens.

The `box-shadow` makes the dropdown menu look like a "card".

Using `right: 0` would make the dropdown menu right-aligned.
