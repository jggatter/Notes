## CSS Forms
#css #inputs #forms #html #attributes #selectors

The look of forms can be greatly improved with CSS.

We can use the `width` to determine the width of an input field.
```css
input {
  width: 100%;
}
```

We can use attribute selectors to apply to specific types of inputs:
- `input[type=text]`: Text fields
- `input[type=password]`: Password fields
- `input[type=number]`: Number fields
- etc.

We can use `padding` to add space inside a text field.
With many inputs one after another, you might want to add `margin` to keep
them a bit separated:
```css
input[type=text] {
  width: 100%;
  padding: 12px 20px;
  margin: 8px 0;
  box-sizing: border-box;
}
```

The `border` and `border-radius` properties can be used together to
add rounded corners:
```css
inp#ut[type=text] {
  border: 2px solid red;
  border-radius: 4px;
}
```

If we only wanted a bottom border, we could use `border-bottom`:
```css
input[type=text] {
  border: none;
  border-bottom: 2px dotted blue;
}
```
Maybe a bit unintuitive in modern design?

We can add colored backgrounds and inputs:
```css
input[text=type] {
  background-color: #3CBC8D;
  color: white;
}
```

With `:focus` we can style when the element gets clicked on.
```css
input[type=text] {
  border: 3px solid #777777
}
input[type=text]:focus {
  border: 3px solid #555555; /* Darker border */
}
```

We can put an icon inside the input using `background-image` and 
`background-position` properties:
```css
input[type=text] {
  background-color: white;
  background-image: url('search_icon.png'); /* Magnifying glass */
  background-position: 10px 10px;
  background-repeat: no-repeat;
  padding-left: 40px;
}
```

Animated search input can be accomplished using `transition`.
We can animate the width of the input when it gets focus:
```css
input[type=text] {
  transition: width 0.4s ease-in-out; /* animate width */
}
input[type=text]:focus { /* on focus */
  width: 100%; /* to full width */
}
```

We can use the `resize` property to prevent `<textarea>`s from being resized.
This disables the "grabber" in the bottom right which allows resizing.
```css
textarea {
  resize: none;
  width: 100%;
  height: 150px;
  padding: 12px 20px;
  box-sizing: border-box;
  border: 2px solid #cccccc;
  border-radius: 4px;
  background-color: #f8f8f8;
}
```

We can also style `<select>` menus similarly to `<input>`.
We can also style buttons via `input[type=...]`, where `type` is:
- `button`
- `submit`
- `reset`

Media queries can be used to make responsive layouts that have forms.

There are a number of pseudo-classes for input. See prior section about
pseudo-classes.
