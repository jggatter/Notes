# Svelte Actions
#javascript #svelte #actions #lifecycle #effects #directives

## The `use:` directive

Actions are essentially element-level lifecycle functions.
They're useful for things like:
- interfacing with 3rd party libraries
- lazy-loaded images
- tooltips
- adding custom event handlers

In this app, we allow the user to scribble on the `<canvas>`,
and change the color and brush size via the menu.

`src/App.svelte`
```svelte
<script>
  import Canvas from './Canvas.svelte';

  const colors = ['red', 'orange', 'yellow', 'green', 'blue', 'indigo', 'violet', 'white', 'black'];

  let selected = $state(colors[0]);
  let size = $state(10);
  let showMenu = $state(true);
</script>

<div class="container">
  <Canvas color={selected} size={size} />

  {#if showMenu}
    <div
      role="presentation"
      class="modal-background"
      onclick={(event) => {
        if (event.target === event.currentTarget) {
          showMenu = false;
        }
      }}
      onkeydown={(e) => {
        if (e.key === 'Escape') {
          showMenu = false;
        }
      }}
    >
      <div class="menu">
        <div class="colors">
          {#each colors as color}
            <button
              class="color"
              aria-label={color}
              aria-current={selected === color}
              style="--color: {color}"
              onclick={() => {
                selected = color;
              }}
            ></button>
          {/each}
        </div>

        <label>
          small
          <input type="range" bind:value={size} min="1" max="50" />
          large
        </label>
      </div>
    </div>
  {/if}

  <div class="controls">
    <button class="show-menu" onclick={() => showMenu = !showMenu}>
      {showMenu ? 'close' : 'menu'}
    </button>
  </div>
</div>
```

We discover that cycling through menu items using tab,
isn't trapped inside the modal, it cycles through browser elements, etc.

To trap the focus inside the modal, we import an action:
```svelte 
<script lang="ts">
  import Canvas from './Canvas.svelte';
  import { trapFocus } from './actions.svelte.js';

  // ...
</script>
```
and add it to the menu with the `use:` directive:
```svelte
<div class="menu" use:trapFocus>
```

Looking at the `trapFocus` function in `actions.svelte.js`:
an action function is called with a `node`, e.g. `<div class="menu">`, when the node is mounted to the DOM.
Inside the action, we have an effect:
```javascript
export function trapFocus(node) {
  const previous = document.activeElement;

  function focusable() {
    // Restrict focusable elems to just those found via these selectors
    // [href] is links
    // [tabindex]:... excludes explicitly unfocusable elems
    // returns a NodeList
    return Array.from(node.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );
  }

  function handleKeydown(event) {
    if (event.key !== 'Tab') return;

    // Get the element currently focused on in the document
    const current = document.activeElement;

    // Query for all focusable elements
    const elements = focusable();
    // Get first and last focusable elements
    const first = elements.at(0);
    const last = elements.at(-1);

    // If Shift + Tab on first elem, we wrap around focus to the last elem
    if (event.shiftKey && current === first) {
      // focus() moves keyboard focus to specified elem
      last.focus();
      // prevent default behavior of the event
      // i.e. prevent default action of tab key,
      // which would move focus to next focusable elem outside of `node`
      event.preventDefault();
    }

    // If we Tab on the last element, we wrap focus back to the first elem
    if (!event.shiftKey && current === last) {
      first.focus();
      event.preventDefault();
    }
  }

  $effect(() => {
    // Focus on first focusable element in the node
    focusable()[0]?.focus();
    // Intercept Tab key presses
    node.addEventListener('keydown', handleKeydown);

    // Cleanup when node is unmounted (e.g. the modal is closed)
    //   1) Remove event listener,
    //   2) Restore focus to where it was before it was mounted
    return () => {
      node.removeEventListener('keydown', handleKeydown);
      previous?.focus();
    }
  });
}
```
Now when we open the menu, we cycle only through its options.

## Adding parameters to actions

Like transitions and animations, an action can take an argument,
which the action function will be called with alongside the elem it belongs to.

In this exercise we want to add a tooltip to the `<button>`
using the `Tippy.js` library.

The action is already wired up with `use:tooltip`,
but if you hover over the button (or focus with keyboard),
the tooltip contains no content.

First, the action needs to accept a function
that returns some options to pass to Tippy:
```svelte
<script>
  import tippy from 'tippy.js'

  let content = $state('Hello!');

  functon tooltip(node, fn) {
    $effect(() => {
      const tooltip = tippy(node, fn());

      return tooltip.destoy;
    });
  }
</script>

// We bind the input value for the tooltip to `content`
<input bind:value{content} />

<button use:tooltip>
  Hover over me
</button>
```
_Note: We pass in a func rather than the options themselves,_
_because the `tooltip` func doesn't re-run when options change.

Then we need to pass the options into the action:
```svelte
<button use:tooltip={() => ({content})}>
  Hover over me
</button>
```

