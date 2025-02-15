# Svelte Context API
#javacript #svelte #context #components

The context API provides a mechanism for components to 'talk' to each other
without passing around data and functions as props, or dispatching many events.
It's an advanced feature, yet a useful one.

Inside `Canvas.svelte`, there's an `addItem` func that adds an item to canvas.
We can make it available to components inside `<Canvas>` like `<Square>`
using `setContext`.

```svelte
<script>
  import { setContext } from 'svelte'
  import { SvelteSet } from 'svelte/reactivity';

  let { width = 100, height = 100, children } = $props();

  let canvas;
  let items = new SvelteSet();

  setContext('canvas', { addItem });

  function addItem(fn) {
    $effect(() => {
      items.add(fn);
      return () => items.delete(fn);
    });
  }

  $effect(() => {
    const ctx = canvas.getContext('2d');

    ctx.clearRect(0, 0, width, height);
    items.forEach(fn => fn(ctx));
  })
</script>

<canvas bind:this={canvas} {width} {heigh}>
  {@render children()}
</canvas>
```

Inside child components, we can retrieve the context using `getContext`,
e.g. in `Square.svelte`:
```svelte
<script>
  import { getContext } from 'svelte';

  let { x, y, size, rotate } = $props();

  getContext('canvas').addItem(draw);

  function draw(ctx) {
    ctx.save();

    ctx.translate(x, y);
    ctx.rotate(rotate);

    ctx.strokeStyle = 'black';
    ctx.strokeRect(-size / 2, -size / 2, size, size);

    ctx.restore();
  }
</script>
```

This adds a grid of squares to the canvas.
In `App.svelte` we can add some jitter to the grid to make things more exciting:
```svelte
<script>
  import Canvas from './Canvas.svelte';
  import Square from './Square.svelte';

  // we use seeded random num generation to get consistent jitter
  let seed = 1;
  function random () {
    seed *= 16807;
    seed %= 2147483647;
    return (seed - 1) / 2147483647;
  }

  function jitter(amount) {
    return amount * (random() - 0.5);
  }
</script>

<div class="container">
	<Canvas width={800} height={1200}>
		{#each Array(12) as _, c}
			{#each Array(22) as _, r}
				<Square
					x={180 + c * 40 + jitter(r * 2)}
					y={180 + r * 40 + jitter(r * 2)}
					size={40}
					rotate={jitter(r * 0.05)}
				/>
			{/each}
		{/each}
	</Canvas>
</div>
```
As the row number increases, the squares get more askew and rotated.

`setContext` and `getContext` must be called during component initialization,
so that the context can be correctly bound.

The key -- `'canvas'` in this case -- can be anything you like,
including non-strings,
which is useful for controlling who can access the context.

Note: Our context object can include anything, including reactive state.
This allows you to pass values that change over time to child components.
```svelte
<script>
  // in a parent component
  import { setContext } from 'svelte';

  let context = $state({...});
  setContext('my-context', context);
</script>
```
```svelte
<script>
  // in a child component
  import { getContext } from 'svelte';

  const context = getContext('my-context');
</script>
```

