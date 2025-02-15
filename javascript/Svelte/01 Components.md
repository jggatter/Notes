# Svelte Components
#javascript #svelte #components #html #css

In Svelte, an application is composed from one or more _components_.

A component is a reusable, self-contained block of code 
that encapsulates HTML, CSS, JavaScript that belong together,
written into a `.svelte` file.

For example, imagine a file `src/App.svelte` with a simple component:
```svelte
<h1>Hello world!</h1>
```

## Adding data

We can add data to our component.

We define `name` and them refer to it in the markup:
```svelte
<script lang="ts">
  let name = 'Svelte';
</script>

<h1>Hello {name}!</h1>
```
In the curly braces, we can put any JavaScript we want!
```svelte
<h1>Hello {name.toUpperCase()}!</h1>
```

## Dynamic attributes

Just as we controlled text with curly braces,
We can also use curly braces to control element attributes.

For example, we can add a `src` to an `img`:
```svelte
<img src={src} alt="{name} dances."/>
```
We also can the braces inside atrributes, like the string for `alt`.

### Shorthand attributes

It's not that uncommon to have an attr where the name and value are the same.
E.g. `src={src}`

Svelte gives us a convenient shorthand for these cases:
```svelte
<img {src} alt="{name} dances" />
```

## Styling

Just as in HTML, we can add a `<style>` tag to our component.

Let's add some style to a `<p>` element.
```svelte
<p>This is a paragraph.</p>

<style>
  p {
    color: goldenrod;  
    font-family: 'Comic sans MS', cursive;
    font-size: 2em;
  }
</style>
```

Importantly these rules rae scoped to the _component_.
We won't accidentally change the style of all `<p>` across our app.

## Nesting components

It'd be impractical to put our entire app in a single component.
Instead, we can import components from other files for inclusion in our markup.

We add an import to our `<script>` in `src/App.svelte`:
```svelte
<script lang="ts">
  import Nested from './Nested.svelte';
</script>
```
We include the `<Nested />` component in our markup:
```svelte
<p>This is a paragraph.</p>
<Nested />
```

And `src/Nested.svelte` is simply another `<p>` element:
```svelte
<p>This is another paragraph.</p>
```
However the sytles from `App.svelte` don't leak in!

Note: Component names are capitalized to distinguish them from HTML elements.

## HTML Tags

Ordinarily, strings are inserted as plain text,
meaning that characters like `<` and `>` have no special meaning.

Sometimes though we need to render HTML directly into a component.

In Svelte, we do this with the special `{@html ...}` tag:
```svelte
<p>{@html string}</p>
```

Note: Svelte does not perform any sanitization of the expression
inside `{@html ...}` before it gets inserted into the DOM.
Beware of untrusted user contet, manually escaping it to avoid XSS attacks!

