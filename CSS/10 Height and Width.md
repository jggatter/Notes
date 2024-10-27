# CSS Height and Width
#css #height #width #max-width #min-height #min-width #length

## `height` and `width`

`height` and `width` are used to set the height and width of the content area.
See box model. They don't include padding, borders, or margins.

Accepted values:
- `auto` (default): Browser calculates
- Specific length in units
- Percentage of height/width of the containing block
- `initial`: Default value
- `inherit`: Inherit from parent element

## `max-width`

The `max-width` property is used to specify the maximum width of the element.

Accepted values:
- None (default)
- Specific length in units
- Percentage of height/width of the containing block

When a browser window is/becomes smaller than the width of an element,
the browser adds a horizontal scrollbar to the page.
Replacing `width` with `max-width` we can have the element wrap with the
window size.
If both are specified for some reason, only the `max-width` will be considered.

## `min-height` and `min-width`

TODO
