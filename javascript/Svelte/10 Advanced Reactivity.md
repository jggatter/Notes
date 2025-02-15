# Svelte Advanced Reactivity
#javascript #svelte #reactivity #state

## Raw state

In previous exercises, we learned that state is _deeply reactive_
-- if you change a prop of an object or push to an array,
it will cause the UI to update.
This works by creating a _proxy_ that intercepts object read/writes.

Occasionally, that's not what you want.
If you're not changing individual properties,
or if it's important to maintain referential equality,
then you can use _raw state_ instead.

In this example, we have a chart of Svelte's steadily increasing stock price.
We want the chart to update when new data comes in,
which we could achieve by turning `data` into state.
```svelte
let data = $state(poll());
```

but there's no need to make it deeply reactive
when it will be discarded a few milliseconds later.
Instead, we use `$state.raw`:
```svelte
let data = $state.raw(poll());
```

Note: mutating raw state will have no direct effect.
In general, mutating non-reactive state is strongly discouraged.

## Reactive classes

It's not just variables that can be made reactive
-- In Svelte, we can also make properties of classes reactive.

Let's make `width` and `height` props of our `Box` reactive:
```svelte
class Box {
  width = $state(0);
  height = $state(0);
  area = 0;

  // ...
}
```

Now when we interact with range inputs or click the "embiggen" button,
the box reacts.

We can also use `$derived` so that `box.area` updates reactively:
```svelte
class Box {
  width = $state(0);
  height = $state(0);
  area = $derived(this.width * this.height);

  // ...
}
```

Note: In addition to `$state` and `$derived`, you can use `$state.raw`
and `$derived.by` to define reactive fields.

## Getters and setters

Classes are particularly useful when we need to validate data.

In the case of the `Box` class,
it shouldn't be possible to keep embiggening past the max allowed by sliders.

We can fix that by replacing `width` and `height`
with _getters_ and _setters_,
otherwise known as _accessors_.

First convert them to _private properties_:
```svelte
class Box {
  #width = $state(0);
  #height = $state(0);
  area = $derived(this.#width * this.#height);

  constructor(width, height) {
    this.#width = width;
    this.#height = height;
  }

  // ...
}
```

Then, create some getters and setters with validation:
```svelte
class Box {
  // ...

  get width {
    return this.#width;
  }

  get height {
    return this.#height;
  }

  set width(value) {
    this.#width = Math.max(0, Math.min(MAX_SIZE, value));
  }

  set height(value) {
    this.#height = Math.max(0, Math.min(MAX_SIZE, value));
  }

  embiggen(amount) {
    this.width += amount;
    this.height += amount;
  }
}
```
Now it's impossible to increase the box size past safe limits,
whether through the `bind:value` on the range inputs,
or via the `embiggen` method.

## Reactive built-ins

Svelte ships with several reactive classes that we can use
in place of JavaScript built-in objects
-- namely `Map`, `Set`, `Date`, `URL`, and `URLSearchParams`.

In this exercise, we _could_ declare `date` using `$state(new Date())`
and reassign it inside the `setInterval` function,
but a nicer alternative is to use `SvelteDate` from `svelte/reactivity`.
```svelte
<script lang="ts">
  import { SvelteDate } from 'svelte/reactivity';

  let date = new SvelteDate();

  const pad = (n) => n < 10 ? '0' + n : n;

  $effect(() => {
    const interval = setInterval(() => {
      date.setTime(Date.now());
    }, 1000);

    return () => {
      clearInterval(interval);
    };
  });
</script>

<p>The time is {date.getHours()}:{pad(date.getMinutes())}:{pad(date.getSeconds())}</p>
```

## Stores

Prior to the introduction of runes in Svelte 5,
stores were the idiomatic way to handle reactive state outside components.

That's no longer the case, but you'll still encounter stores when using Svelte
(including in SvelteKit, for now),
so it's worth nowing how to use stores.

_Note: Creating custom stores is covered in the documentation._

Let's revisit the example from the universal reactivity exercise,
but this time implement the shared state using a store.

In `shared.js`, we're currently exporting `count`, which is a number.
We turn it into a writable store:
```svelte
import { writable } from 'svelte/store';

export const count = writable(0);
```

To reference the value of the store,
we prefix it with a `$` symbol.

In `Counter.svelte`, by changing `count` to be referenced, `$count`,
the text in `App.svelte` is updated and no longer says `[object Object]`.
```svelte
<script>
  import { count } from './shared.js';
</script>

<button onclick={() => {}}>
  clicks: {$count}
</button>
```

Finally we add an event handler. 
Because this is a writable store,
we can update the value programatically using its `set` or `update` method.
```svelte
count.update((n) => n + 1);
```
But since we're in a component, we can continue using the `$` prefix:
```svelte
<button onclick={() => $count + 1}>
  clicks: {$count}
</button>
```

