# Svelte Transitions
#javascript #svelte #transitions #directives #css

## The `transition` directive

We can make more appealing UIs by gracefully transitioning elems
into and out of the DOM.

Svelte makes this very easy using the `transition` directive.

First, import `fade` function from `svelte/transition`:
```svelte
<script lang="ts">
  import { fade } from 'svelte/transition';
  
  let visible = $state(true);
</script>
```
Then we add a transition directive using it to the `<p>` element:
```svelte
<label>
  <input type="checkbox" bind:checked={visible} />
  visible
</label>

{#if visible}
  <p transition:fade>
    Fades in and out
  </p>
{/if}
```
The paragraph will now fade in and out as `visible` is changed.

## Adding parameters to transitions

Transition functions can accept parameters.

We replace `fade` with `fly`:
```svelte
<script lang="ts">
  import { fly } from 'svelte/transition';
  
  let visible = $state(true);
</script>
```
We apply it to `<p>` but pass some options this time:
```svelte
{#if visible}
  <p transition:fly={{y: 200, duration: 2000}}>
    Flies in and out
  </p>
{/if}
```
The paragraph flies and fades in and out from the bottom of the page.

Note that the transition is reversible,
if `visible` is changed while a transition is ongoing,
it transitions from the current point rather than from the beginning or end.

## `Transitioning using `in` and `out` directives

Instead of using the `transition` directive,
an element can have an `in` directive, `out` directive, or both.

We can import `fade` alongside `fly`:
```svelte
<p in:fly={{ y: 200, duration: 2000 }} out:fade>
  Flies in, fades out
</p>
```

In this case, the transitions are _not_ reversed.

## Custom CSS transitions

The `svelte/transitions` module has a handful of built-in transitions,
but it's very easy to create your own.

By way of example, this is the source of the `fade` transition:
```svelte
function fade(node, { delay = 0, duration = 400 }) {
  const o = +getComputedStyle(node).opacity;

  return {
    delay,
    duration,
    css: (t) => `opacity: ${t + o}`
  }
}
```

The func takes two arguments:
1) The node to which the transition is applied
2) Any params that were passed in, e.g. `delay` or `duration`

It returns a transition object, which can have the following properties:
- `delay`: number of milliseconds before the transition begins
- `duration`: length of the transition in milliseconds
- `easing`: a `p => t` easing function
- `css`: a `(t, u) => css` func where `u === 1 - t`
- `tick`: a `(t, u) => {...}` func that has some effect on the node

The `t` value is `0` at the beginning of an intro or end of an outro,
and `1` and the end of an intro or the beginning of an outro.

Most of the time you should return `css` prop and _not_ the `tick` prop,
as CSS animations run off the main threda to prevent jank where possible.
Svelete 'simulates` the transition and constructs a CSS animation,
then lets it run.

For example, the `fade` transition generates a CSS animation somewhat like:
```css
0% { opacity: 0 }
10% { opacity: 0.1 }
20% { opacity: 0.2 }
/* ... */
100% { opacity: 1 }
```

We can get a lot more creative though, let's get gratuitous:
```svelte
<script lang="ts">
  import { fade } from 'svelte/transition';
  import { elasticOut } from 'svelte/easing';

  let visible = $state(true);

  function spin(node, { duration }) {
    return {
      duration,
      css: (t, u) => {
        const eased = elasticOut(t);

        return `
          transform: scale(${eased}) rotate(${eased * 1080}deg);
          color: hsl(
            ${Math.trunc(t * 360)},
            ${Math.min(100, 1000 * u)}%,
            ${Math.min(50, 500 * u)}%
          );
        `
      }
    };
  }
</script>

<label>
  <input type="checkbox" bind:checked={visible} />
  visible
</label>

{#if visible}
  <div class="centered" in:spin={{duration: 8000}} out:fade>
    <span>transitions!</span>
  </div>
{/if}
```
We spin the elements into view, changing the text color
until they become still and the text color becomes white.

Remember: With great power comes great responsibility!

## Custom JS transitions

While we should generally use CSS for transitions as much as possible,
there are some effects which can't be achieved without JavaScript,
such as the typewriter effect:

```svelte
<script>
  let visible = $state(false);

  function typewriter(node, { speed = 1 }) {
    const valid = node.childNodes.length === 1 
        && node.childNodes[0].nodeType === Node.TEXT_NODE;

    if (!valid) {
      throw new Error(
        `Transition only works on elems with single text node child`
      );
    }

    const text = node.textContent;
    const duration = text.length / (speed * 0.01);

    return {
      duration,
      tick: (t) => {
        // Get position based on timepoint, truncating decimals
        const i = Math.trunc(text.length * t);
        // Update text to reveal from start to the position
        node.textContent = text.slice(0, i);
      }
    };
  }
</script>

<label>
  <input type="checkbox" bind:checked={visible} />
  visible
</label>

{#if visible}
  <p transition:typewriter>
    The quick brown fox jumps over the lazy dog
  </p>
{/if}
```

## Transition events

It can be useful to know when transitions are beginning and ending.

Svelete dispatch events that you can listen to like any other DOM event:
```svelte
<p
  transition:fly={{ y: 200, duration: 2000 }}
  onintrostart={() => status = 'intro started'}
  onoutrostart={() => status = 'outro started'}
  onintroend={() => status = 'intro ended'}
  onoutroend={() => status = 'outro ended'}
/>
  Flies in and out
</p>
```

## Global transitions

Ordinarily, transitions will only play on elememts
when their direct containing block is added or destroyed.

In this example here, toggling visibility of the entire list
does not apply transitions to the individual list elements.

Instead, we'd like transitions to not only play
when individual items are added/removed with the slider,
but also when we toggle the checkbox.

We can achieve this with a _global_ transition,
which plays when _any_ block containing the transitions is added/removed.
```svelte
<script>
  import { slide } from 'svelte/transition';

  let items = ['one', 'two', 'three', 'four', 'five', 'six', 'seven'];

  let showItems = $state(true);
  let i = $state(5);
</script>

<label>
  <input type="checkbox" bind:checked={showItems} />
  show list
</label>

<label>
  <input type="range" bind:value={i} max="10" />
</label>

{#if showItems}
  {#each items.slice(0, i) as item}
    <div transition:slide|global>
      {item}
    </div>
  {/each}
{/if}
```
Without `|global`, the sliding only works when the slider is used,
not when the checkbox is used.

## Key blocks

Key blocks destroy and recreate their content when the val of an expr changes.

This is useful if we want an element to play its transition
whenever a value changes,
instead of only when the element enters or leaves the DOM.

Here, for example, we'd like to play the `typewriter` transition
from `transition.js` whenever the loading message, i.e `i` changes.
We wrap `<p>` in a `key` block:
```svelte
{#key i }
  <p in:typewriter={{ speed: 10 }}>
    {messages[i] || ''}
  </p>
{/key}
```

