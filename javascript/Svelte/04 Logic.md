# Svelte Logic
#javascript #svelte #logic #conditionals #loops #await

HTML doesn't have a way of expressing _logic_, like conditionals and loops.

Svelte does!

## If blocks

To conditionally render markup, we wrap it in an `if` block.
Let's add some text that appears when `count > 10`:
```svelte
<script>
  let count = $state(0);

  function increment() {
      count += 1;
  }
</script>

<button onclick={increment}>
  Clicked {count}
  {count === 1 ? 'time' : 'times'}
</button>

{#if count > 10}
  <p>{count} is greater than 10</p>
{/if}
```

### Else blocks

Just like in JavaScript, `if` blocks can have an `else block`:
```svelte
{#if count > 10}
  <p>{count} is greater than 10</p>
{:else}
  <p>{count} is between 0 and 10</p>
{/if}
```

`{#...}` opens a block,
`{/...}` closes a block,
and `{:...}` _continues_ a block.

### Else-if blocks

Likewise we can test multiple conditions by chaining `else-if` blocks together.
```svelte
{#if count > 10}
  <p>{count} is greater than 10</p>
{:else if count < 5}
  <p>{count} is less than 5</p>
{:else}
  <p>{count} is between 5 and 10</p>
{/if}
```

## Each blocks

When building UIs, we often find ourselves working with lists of data.

We can use `each` blocks to repeat markup for each element of a list:
```svelte
<script>
  const colors = ['red', 'orange', 'yellow', 'green', 'blue', 'indigo', 'violet'];
  let selected = $state(colors[0]);
</script>

<h1 style="color: {selected}"/>Pick a color</h1>

<div>
  {#each colors as color}
    <button
      style="background: {color}"
      aria-label={color}
      aria-current={selected === color}
      onclick{() => selected = color}
    ></button>
  {/each}
</div>
```

We can get the current _index_ as a second argument:
```svelte
  {#each colors as color, i}
    <button
      style="background: {color}"
      aria-label={color}
      aria-current={selected === color}
      onclick{() => selected = color}
    >{i + 1}</button>
  {/each}
```

### Keyed each blocks

By default, when you modify the value of an `each` block,
it will add and remove DOM nodes at the _end_ of the block,
and update any values that have changed.
This might not be what you want.

Take for example this component in `Thing.svelte`:
```svelte
<script>
  const emojis = {
      apple: '🍎',
      banana: '🍌',
      carrot: '🥕',
      doughnut: '🍩',
      egg: '🥚'
  };

  // `name` is updated whenever prop value changes...
  let { name } = $props();
  // ...but `emoji` is fixed upon initialization
  const emoji = emojis[name];
</script>

<p>{emoji} = {name}</p>
```
And it's inclusion in `App.svelte`:
```svelte
<script>
  import Thing from './Thing.svelte';

  let things = $state([
    { id: 1, name: 'apple' },
    { id: 2, name: 'bannana' },
    { id: 3, name: 'carrot' },
    { id: 4, name: 'doughnut' },
    { id: 5, name: 'egg' },
  ])
</script>

<button onclick={() => things.shift()}>
  Remove first thing
</button>

{#each things as thing}
  <Thing name={thing.name} />
{/each}
```
When we click the button to "Remove first thing", we notice:
1. It removes the last component
2. It then updates `name` in the remaining DOM nodes, but not the `emoji`.
(The first item left always has an apple emoji!)

Note: This is different than React, where the entire component is re-rendered.
Svelte works differently:
The component 'runs' once, and subsequent updates are fine-grained.
This makes things faster and gives us more control.

One way to fix this would be to make `emoji` a `$derived` value.
But it makes more sense to remove the first `<Thing>` altogether,
rather than remove the _last_ one and update all the others.

To do this, we specify a unique _key_ for each iteration of the `each` block:
```svelte
{#each things as thing (thing.id)}
  <Thing name={thing.name}/>
{/each}
```
Now components are removed entirely, the remaining keeping their expected emoji.

Note: We can use any object as the key, as Svelte uses a `Map` internally --
In other words, we could do `(thing)` instead of `(thing.id)`.
Using a string or number is safer though,
as it means identity persists without referential equality,
for example, when updating with fresh data from an API server.

## Await blocks

Most web apps have to deal with asynchronous data at some point.
Svelte makes it easy to _await_ the value of promises directly in our markup.
```svelte
{#await promies}
  <p>...rolling</p>
{:then number}
  <p>you rolled a {number}!</p>
{:catch error}
  <p style="color: red">{error.message}</p>
{/await}
```

Note: Only the most recent `promise` is considered,
meaning we don't need to worry about race conditions.

If we know our promise can't reject, we can omit the `catch` block.
We can also omit the first block
if we don't want to show anything until a promise resolves.
```svelte
{#await promise then number}
  <p>you rolled a {number!}</p>
{/await}
```

