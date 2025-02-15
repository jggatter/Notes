# Svelte Motion
#javascript #svelte #motion

Often, a good way to communicate that a value is changing is to use _motion_.

Svelte ships classes for adding motion to your UIs.

## Tweened galues

Import `Tween` class from `'svelte/motion'`:
```svelte
<script lang="ts">
  import { Tween } from 'svelte/motion';

  let progress = $state(0);
</script>
```

Turn `progress` into an instane of `Tween`:
```svelte
<script lang="ts">
  import { Tween } from 'svelte/motion';

  let progress = new Tween(0);
</script>
```

`Tween` has a writable `target` property and a readonly `current` property.
We update the `<progress>` element to use `current`:
```svelte
<progress value={progress.current}></progress>
```
and each of the event handlers to write to `target`:
```svelte
<button onclick={() => (progress.target = 0)}>
  0%
</button>
<button onclick={() => (progress.target = 0.25)}>
  25%
</button>
// ...
```

Clicking the buttons causes the progress bar to animate to its new value.
It's a bit robotic though, so we can add an easing function:
```svelte
<script lang="ts">
  import { Tween } from 'svelte/motion';
  import { cubicOut } from 'svelte/easing';

  let progress = new Tween(0, {
    duration: 400,
    easing: cubicOut
  });
</script>
```

The full set of options available to `Tween`:
- `delay`: ms before tween starts
- `duration`: either duration of tween in ms, or a `(from, to) => ms` func allowing us to (e.g.) specify longer tweens for larger changes in value
- `easing`: a `p => t` function
- `interpolate`: a custom `(from, to) => t => value` func for interpolating between arbitrary values. Read more on docs.

We can also call `progress.set(value, options)`
instead of assigning directly to `progress.target`.
In this case, `options` will override the defaults.
The `set` method returns a promise that resolves when the tween completes.

## Springs

The `Spring` class is an alternative to `Tween`
that often works better for values that are frequently changing.

In this example, we have a circle that follows a mouse,
and the two values -- the circles coords and its size.

Let's convert them to springs:
```svelte
<script lang="ts">
  import { Spring } from 'svelte/motion';

  let coords = new Spring({x: 50, y:50});
  let size = new Spring(10);
</script>
```

As with `Tween`,
springs have a writable `target` property and a read-only `current` property.
We update the event handlers to use `target`:
```svelte
<svg
  onmousemove={(e) => {
    coords.target = { x: e.clientX, y: e.clientY };
  }}
  onmousedown={(e) => {
    (size.target = 30)
  }}
  onmouseup={(e) => {
    (size.target = 10)
  }}
  role="presentation"
>
```
and the `<circle>` attributes to use `current`:
```svelte
<circle
  cx={coords.current.x}
  cy={coords.current.y}
  r={size.current}
></circle>
```

Both springs have default `stiffness` and `damping` values,
which controls how "springy" they are.

We can specify our own initial values:
```svelte
<script lang="ts">
  import { Spring } from 'svelte/motion';

  let coords = new Spring({ x: 50, y: 50 }, {
    stiffness: 0.1,
    damping: 0.25
  });
  let size = new Spring(10);
</script>
```
Notice we can adjust the values while the spring is still in motion.

