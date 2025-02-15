# Svelte Classes and Styles
#javascript #svelte #classes #styles #attributes #html #css #customproperties #directives

## The class attributes

Like any other attribute,
you can specify classes with a JavaScript attribute.

Here we could add a `flipped` class to the card:
```svelte
<script>
  let flipped = $state(false);
</script>

<button
  class="card {flipped ? 'flipped' : ''}"
  onclick={() => flipped = !flipped}
>
```
Clicking on the card now, it'll flip.

Adding or removing a class based on some condition is so common in UI dev 
that Svelte allows us to pass an object or array 
which is converted to a string by the package clsx.
```svelte
<button
  class="card { flipped }"
  onclick={() => flipped = !flipped}
>
```
This means "always add the `card` class
and add the `flipped` class whenever `flipped` is truthy"

## The `style` directive

As with class, we cna write our inline `style` attrs literally,
because Svelte is really just HTML with fancy bits.
```svelte
<button
  clas="card"
  style="transform: {flipped ? 'rotateY(0)' : ''}; --bg-1: palegoldenrod; --bg-2: black; --bg-3: goldenrod"
  onclick={() => flipped = !flipped}
>
```

When we have a lot of styles it can stat to look a bit wacky.
We can tidy things up using the `style:` directive:
```svelte
<button
  class="card"
  style:transform={flipped ? 'rotateY(0)' : ''}
  style:--bg-1="palegoldenrod"
  style:--bg-2="black"
  style:--bg-3="goldenrod"
  onclick={() => flipped = !flipped}
>
```

## Component styles

Often you need to influence the styles inside a child component.
Perhaps we want to make some boxes red, green, and blue.

One way to do this is the `:global` CSS modifier,
which allows us to indiscriminately target elements inside other components.

`src/App.svelte`:
```svelte
<script>
  import Box from './Box.svelte';
</script>

<div class="boxes">
  <Box />
  <Box />
  <Box />
<div>

<style>
  .boxes :global(.box:nth-child(1)) {
    background-color: red;
  }

  .boxes :global(.box:nth-child(2)) {
    background-color: green;
  }

  .boxes :global(.box:nth-child(3)) {
    background-color: blue;
  }
</style>
```
And `src/Box.svelte`:
```svelte
<div class="box"></div>

<style>
  .box {
    width: 5em;
    height: 5em;
    border-radius: 0.5em;
    margin: 0 0 1em 0;
    background-color: #ddd;
  }
</style>
```

But there are lots of reasons _not_ to do that.
For one thing, it's extremely verbose. For another, it's brittle:
Any changes to the impl details of `Box.svelte` could break the selector.

Most of all, it's rude. Components should be able to decide for themselves
which styles can be controlled from 'outside',
just as they decide which variables are exposed as props.
`:global` should be used as an escape hatch -- a last resort.

We can get rid of the `<style> element,`
and change `background-color` so that it is determined by a CSS custom property:
```svelte
<style>
  .box {
    width: 5em;
    height: 5em;
    border-radius: 0.5em;
    margin: 0 0 1em 0;
    background-color: var(--color, #ddd)
  }
</style>
```
Any parent element (e.g. `<div class="boxes">`) can set the value of `--color`,
but we can also set it on individual components:
```svelte```
<div class="boxes">
  <Box --color="red" />
  <Box --color="green" />
  <Box --color="blue" />
<div>
```
The values can be dynamic, like any other element.

