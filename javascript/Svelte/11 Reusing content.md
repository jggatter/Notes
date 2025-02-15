# Svelte Reusing Content
#javascript #svelte #snippets

## Snippets and render tags

Snippets allow us to reuse content within a component,
without extracting it out into a separate file.

In this exercise, we create a table of three wise monkeys,
along with their unicode escape sequences and HTML entities.
So far we have but a single monkey.

We could duplicate the markup, of course,
or we could create an array of `{ emoji, description }` objects
and pass it to an each block.
But a nicer solution is to encapsulate the markup in a reusable block.

Begin by _declaring a `snippet`_:
```svelte
{#snippet monkey()}
  <tr>
    <td>{emoji}</td>
    <td>{description}</td>
    <td>\u{emoji.charCodeAt(0).toString(16)}\u{emoji.charCodeAt(1).toString(16)}</td>
    <td>&amp#{emoji.codePointAt(0)}</td>
  </tr>
{/snippet}
```

The monkey is no longer visible until we _render_ it.
```svelte
<tbody>
  {#snippet monkey()}...{/snippet}

  {@render monkey()}
</tbody>
```

Before we can use the snippet for the rest of our monkeys,
we need to pass data into the snippet.

Snippets can have zero or more parameters.
_Note: deconstructured params can be used_

We parameterize the snippet, adding the remaining monkeys:
```svelte
<tbody>
  {#snippet monkey(emoji, description)}...{/snippet}

  {@render monkey('🙈', 'see no evil')}
  {@render monkey('🙉', 'hear no evil')}
  {@render monkey('🙊', 'speak no evil')}
</tbody>
```

Snippets can be declared anywhere in your component,
but like functions they are only visible in the same scope or a child scope.

## Passing snippets to a component

Since snippets -- like functions -- are just values,
they can be passed to components as props.

Take for example this `<FilteredList>` component initialized in `App.svelte`:
```svelte
<FilteredList
  data={colors}
  field="name"
></FilteredList>
```
Its job is to filter the `data` that gets passed into it,
but it has no opinions about how that data should be rendered --
that's the responsibility of the parent component.

We've already got some snippets defined below in `App.svelte`:
```svelte
{#snippet header()}
  <header>
    <span class="color"></span>
    <span class="name">name</span>
    <span class="hex">hex</span>
    <span class="rgb">rgb</span>
    <span class="hsl">hsl</span>
  </header>
{/snippet}

{#snippet row(d)}
  <div class="row">
    <span class="color" style="background-color: {d.hex}"></span>
    <span class="name">{d.name}</span>
    <span class="hex">{d.hex}</span>
    <span class="rgb">{d.rgb}</span>
    <span class="hsl">{d.hsl}</span>
  </div>
{/snippet}
```
We begin by passing them to `<FilteredList>`:
```svelte
<FilteredList
  data={colors}
  field="name"
  {header}
  {row}
></FilteredList>
```

Then, on the other side,
we declare `header` and `row` as props In `FilteredList.svelte`:
```svelte
<script lang="ts">
  let { data, field, header, row } = $props();

  // ...
</script>
```
Finally, we replace the placeholder content with render tags:
```svelte
<div class="header">
  {@render header()}
</div>

<div class="content">
  {#each filtered as d}
    {@render row(d)}
  {/each}
</div>
```

## Implicit snippet props

As an authoring convenience,
snippets declared directly inside components become props _on_ those components.

Move the `header` and `row` snippets inside `<FilteredList>`:
```svelte
<FilteredList
  data={colors}
  field="name"
  {header}
  {row}
>
 {#snippet header()}...{/snippet}

 {#snippet row(d)}...{/snippet}
</FilteredList>
```

We can now remove them from the explicit props:
```svelte
<FilteredList data={colors} field="name">
 {#snippet header()}...{/snippet}

 {#snippet row(d)}...{/snippet}
</FilteredList>
```

Any content inside a component that is _not_ part of a declared snippet
becomes a special `children` snippet.

Since `header` has no params,
we can turn it into `children` by removing the `snippet` block tags,
```svelte
<header>
  <span class="color"></span>
  <span class="name">name</span>
  <span class="hex">hex</span>
  <span class="rgb">rgb</span>
  <span class="hsl">hsl</span>
</header>
```
and passing it as `children` instead of `header`:
```svelte
<script lang="ts">
  let { data, field, children, row } = $props();

  // ...
</script>

// ...

<div class="header">
  {@render children()}
</div>
```

