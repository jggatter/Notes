# CSS Specificity
#css #specificity #cascading #selectors #class #pseudo-class #attributes #pseudo-elements #rules #!important

If there are two or more rules that point to the same element,
the selector with the highest specificity value will win and apply its style.

Think of specificity as a score or rank that determines which style
declaration is ultimately applied to an element.

The more specific a selector is, the higher the specificity of the declaration.
```css
.im-specific {color: green;}
p {color: red;}
```
For `<p class="im-specific">` elements, they will be green rather than red
despite later declaring of red color for general `<p>` elements.

More thorough example:
```html
<html>
  <head>
    <style>
      #more-specific {color: blue;}
      .specific {color: green};
      p {color: red;}
    </style>
  </head>
  <body>

    <p id="more-specific" class="test" style="color: pink;">Hello!</p>

  </body>
</html>
```
ID selectors are more specific than class selectors,
but here the color will be pink and not blue, nor green, nor red.
In-line styles are given highest priority.

## Specificity Hierarchy

Every selector has its place in the hierarchy.

There are four categories which define the specificity level of a selector.
In order of specificity from highest to lowest:
1. Inline styles
2. IDs
3. classes, pseudo-classes, and attribute selectors
4. elements and pseudo-elements

_Note: ID selectors get higher specificity than attribute selectors for `id`._


## Calculating specificity

The total specificity of a declaration is the some of all selectors' specificity

Here are some examples of how to calculate specificity:

| Selector                   | Specificity Value | Calculation   |
| -------------------------- | ----------------- | ------------- |
| `*`                        | 0                 | 0 (ignored)   |
| `p`                        | 1                 | 1             |
| `.some-class`              | 10                | 10            |
| `p.some-class`             | 11                | 1 + 10        |
| `#some-id`                 | 100               | 100           |
| `p#some-id`                | 101               | 1 + 100       |
| `#some-id1 p#some-id2`     | 201               | 100 + 1 + 100 |
| `<p style="color: pink;>`  | 1000              | 1000          |
| `p.some-class.some-class2` | 21                | 1 + 10 + 10   |

Highest specificity applies to an element.
If there are ties, the winner is the latest declaration.

_Note: The `!important` rule is the exception as it will override
even inline styles!_

## The `!important` Rule

The `!important` rule adds more importance to a property/value than normal.

It will override ALL previous styling rules for that specific element.
```css
#some-id {
  background-color: blue;
}

.some-class {
  background-color: gray;
}

p { /* lowest specificity selector */
  background-color: red !important;
}
```
The background color will be red.

The only way to override an `!important` is to include another
`!important` in a declaration with the same or higher specificity

Usage of the `!important` rule can lead to confusion
so it's generally recommended to avoid using it.
