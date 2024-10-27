## CSS Combinators
#css #combinators #selectors

A combinator explains the relationship between selectors.

A CSS selector can contain more than one simple selector.
Between the simple selectors, we can include a combinator.

There are four different combinators in CSS:
- Descendent combinator (`<space>`)
- Child combinator (`>`)
- Next sibling combinator (`<`)
- Subsequent sibling combinator (`~`)

### Descendent combinator

Matches all elements that are descendants
Example: select all `<p>` inside `<div>` elements
```css
div p {
  background-color: yellow;
}
```
```html
<p>Paragraph 1.</p>

<div>
  <p>Paragraph 2.</p> <!-- YELLOW! -->
  <section>
    <p>Paragraph 2a</p> <!-- YELLOW! -->
</div>

<p>Paragraph 3.</p>
```

### Child combinator

Selects all elements that are children of a specified element.
Example: select all `<p>` that are children of a `<div>`
```css
div > p {
  background-color: yellow;
}
```
```html
<p>Paragraph 1.</p>

<div>
  <p>Paragraph 2.</p> <!-- YELLOW! -->
  <section>
    <p>Paragraph 2a</p>
</div>

<p>Paragraph 3.</p>
```
### Next sibling combinator

Selects an element that is directly after another specific element.
Sibling elements must have the same parent element,
and "adjacent" means "immediately following".

The following selects the first `<p>` element that are placed immediately
after `<div>` elements (`</div>` tags):
```css
div + p {
  background-color: yellow;
}
```
```html
<div>
  <p>Paragraph 1 in the div.</p>
  <p>Paragraph 2 in the div.</p>
</div>

<p>Paragraph 3. After a div.</p> <!-- YELLOW! -->
<p>Paragraph 4. After a div.</p>

<div>
  <p>Paragraph 5 in the div.</p>
  <p>Paragraph 6 in the div.</p>
</div>

<p>Paragraph 7. After a div.</p> <!-- YELLOW! -->
<p>Paragraph 8. After a div.</p>
```

### Subsequent-sibling combinator

Selects all elements that are next-siblings of a specified element.
Example: select all `<p>` that are next-siblings of `<div>` elements.
```css
div ~ p {
  background-color: yellow;
}
```
```html
<p>Paragraph 1.</p>

<div>
  <p>Paragraph 2.</p>
</div> <!-- All adjacent paragraphs afterwards are affected! -->

<section>
  <p>Not adjacent! Not affected!</p>
</section>

<p>Paragraph 3.</p> <!-- YELLOW! -->
<code>Some code.</code>  

<p>Paragraph 4.</p> <!-- YELLOW! -->
```

### Selector list

Can select all of different element types using a `,` as a delimiter.
```css
div, p {
  background-color: yellow;
}
```
### Namespace separator

Do I know what namespaces are right now? Not yet. Anyways.

Namespace separator `ns | h2`: Select all h2 elements inside namespace `ns`.
