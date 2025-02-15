# Svelte Advanced Bindings
#javascript #svelte #bindings #attributes #html #directives #runes

## `contenteditable` bindings

`contenteditable` is a global HTML attribute
indicating whether the element should be editable by the user.
If so, the browser modifies its widget to allow editing.

Elements with a `contenteditable` attribute
support `textContent` and `innerHTML` bindings.
```svelte
<script>
  let html = $state('<p>Write some text!</p>');
</script>

<div bind:innerHTML={html} contenteditable></div>

<pre>{html}</pre>
```
Here the div is editable, and HTML of the text entered is bound to `html`.
`html` is then displayed below in the `<pre>` element,
which defines preformatted text in a fixed-width font,
preserving both spaces and line breaks.

The `textContent` property in HTML is used
to get/set the text conent of an element and its descendants,
excluding any HTML tags.
Doesn't seem like line breaks are preserved.

## `each` block bindings

We can bind to properties inside an `each` block.

```svelte
<script>
	let todos = $state([
		{ done: false, text: 'finish Svelte tutorial' },
		{ done: false, text: 'build an app' },
		{ done: false, text: 'world domination' }
	]);

  // ...
</script>

{#each todos as todo}
  <li class={{ done: todo.done }}>
    <input
      type="checkbox"
      bind:checked={todo.done}
    />
  
    <input
      type="text"
      placeholder="What needs to be done?"
      bind:value={todo.text}
    />
  </li>
{/each}
```

## Media elements

We can bind to properties of `<audio>` and `<video>` elements,
making it easy to, e.g. build a custom player UI.

In `AudioPlayer.svelte`, we add an `<audio>` elem with bindings,
using the shorthand form for `src`, `paused`, and `duration`.
```svelte
<div class={['player', { paused }]}>
  <audio
    {src}
    bind:currentTime={time}
    bind:duration
    bind:paused
  ></audio>

  <button
    class="play"
    aria-label={paused ? 'play' : 'paused'}
  ></button>

  // ...

</div>

```
We add an event handler to `<button>` that toggles `pause`:
```svelte
  <button
    class="play"
    aria-label={paused ? 'play' : 'paused'}
    onclick={() => paused = !paused}
  ></button>
```
Our audio player now has basic functionality.

We add the ability to seek to a specific part by dragging the slider.
Insider `pointerdown` handler, there's a `seek` function,
where we can update `time`:
```svelte
function seek(e) {
  const { left, width } = div.getBoundingClientRect();

  let p = (e.clientX - left) / width;
  if (p < 0) p = 0;
  if (p > 1) p = 1;

  time = p * duration;
}
```

When the track ends, be kind -- rewind:
```svelte
<audio
  {src}
  bind:currentTime={time}
  bind:duration
  bind:paused
  onended{() => {
    time = 0;
  }}
></audio>
```

### Media element bindings

The complete set of bindings for `<audio>` and `<video>` includes:

7 read-only bindings:
- `duration`: total duration, in seconds
- `buffered`: an array of `{start, end}` objects
- `seekable`:  an array of `{start, end}` objects
- `played`: an array of `{start, end}` objects
- `seeking`: boolean
- `ended`: boolean
- `readyState`: number from `0` to `4`

And 5 _two-way_ bindings:
- `currentTime`: current position of playhead, in seconds
- `playbackRate`: speed up or slow down (`1` is `'normal'`)
- `paused`: boolean
- `volume`: a decimal between `0` and `1`
- `muted`: a boolean where `true` is muted

`<video>` elements additionally have `videoWidth` and `videoHeight`.

## Binding dimensions

We can add `clientWidth`, `clientHeight`, `offsetWidth`, and `offsetHeight`
bindings to any element,
and Svelete will update the bound values using a `ResizeObserver`:
```svelte
<script>
  let w = $state();
  let h = $state();
  let size = $state(42);
</script>

<label>
  <input type="range" bind:value={size} min="10" max="100" />
  font size ({size}px)
</label>

<div bind:clientWidth={w} bind:clientHeight={h}>
  <span style="font-size: {size}px" contenteditable>{text}</span>
  <span class="size">{w} x {h}px</span>
</div>
```

These bindings are read-only --
changing values of `w` and `h` won't have any effect on the element.

Note: `display: inline` elements do not have width or height
(except for elements with 'intrinsic' dims like `<img>` and `<canvas>`),
and cannot be observed with a `ResizeObserver`.
You'd need to change the `display` of these, e.g. to `inline-block`.

## Binding `this`

We can use the special `bind:this` directive
to get a read-only binding to an element in our component

The `$effect` in this exercise attempts to create a canvas context,
but `canvas` is `undefined`
We begin by declaring it at the top level of the component:
```svelte
<script lang="ts">
  import { paint } from './gradient.js'

  let canvas;

  $effect(() => {
    // ...
  });
</script>
```

Then we add the directive to the `<canvas>` element:
```svelte
<canvas bind:this={canvas} width={32} height={32}></canvas>
```
Note the value of `canvas` will remain `undefined` until the component has mounted.
In other words, you can't access it until the `$effect` runs.

## Component bindings

Just as we can bind properties of DOM elements,
we can bind to component props.

For example, we can bind to the `value` prop of this `<Keypad>` component
as though it was a form element.

We make the prop _bindable_,
using the `$bindable` rune in the `$props` declaration:
```svelte
let { value = $bindable(''), onsubmit } = $props();
```

Then in `App.svelte`, we add a `bind:` directive:
```svelte
<script>
  import Keypad from './Keypad.svelte';

  let pin = $state('');

  function onsubmit() {
    alert(`submitted ${pin}`);
  }
</script>

<Keypad bind:value={pin} {onsubmit} />
```

Now when the user interacts with the keypad,
the value of the `pin` in the parent component is immediately updated.

Note: Use component bindings sparingly,
it can be difficult to track the flow of data in your app
if you have too many. Especially if there's no 'single source of truth'.

## Binding to component instances

Just as we can bind to DOM elements,
we can bind to component instances themselves with `bind:this`.

This is useful in the rare cases
that we need to interact with a component programmatically
(rather than by providing it with updated props).

Revisiting our canvas app from a few exercises ago,
it would be nice to add a button to clear the screen.
We export a function from `Canvas.svelte`:
```svelte
<script>
  let canvas = $state();
  let context = $state();
  let coords = $state();

  export function clear() {
    context.clearRect(0, 0, canvas.width, canvas.height);
  }
</script>

<canvas
  bind:this={canvas}
  // ...
></canvas>
```

We create reference to the component instance in `App.svelte`:
```svelte
<script>
  let selected = $state(colors[0]);
  let size = $state(10);
  let showMenu = $state(true);

  let canvas;
</script>

// ...

<Canvas bind:this={canvas} color={selected} size={size} />
```

Finally we add a button that calls the `clear` function:
```svelte
<div class="controls">
  <button class="show-menu" onclick={() => showMenu = !showMenu}>
    {showMenu ? 'close' : 'menu'}
  </button>

  <button onclick={() => canvas.clear()}>
    clear
  </button>
</div>
```

