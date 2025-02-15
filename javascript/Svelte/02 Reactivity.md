# Svelte Reactivity: State and Effects
#javascript #svelte #state #reactivity #runes #effects

At the heart of Svelte is a powerful system of reactivity
for keeping the DOM in sync with your application,
e.g. in response to an event.

## State

Make the `count` declaration reactive by wrapping the value with `$state(...)`:
```svelte
let count = $state(0);
```

This is called a `_rune_`.
It's how we tell Svelte that `count` is not an ordinary variable.

Runes look like functions but they're not --
when you use Svelte, they're a part of the language itself.

We can increment the `count`:
```svelte
function increment() {
  count += 1;
}
```

## Deep state

As we saw, state reacts to _reassignments_.
But it also reacts to _mutations_ -- 
we call this _deep reactivity_.

We make `numbers` a reactive array via `$state(...)`:
```svelte
let numbers = $state([1, 2, 3, 4]);
```

When we change the array:
```svelte
function addNumbers() {
  numbers[numbers.length] = numbers.length + 1;
}
```
The component updates.

Or better still, we can `push` to the array instead:
```svelte
function addNumbers() {
  numbers.push(numbers.length + 1);
}
```
And the component updates.

Note: Deep reacitivity is implemented using proxy objects,
which allows one to create an object that can be used in place of the original.
They can redefine getters, setters, properties, etc.
Here, mutations to the proxy do not affect the original object.

## Derived State

Often, we'll have to derive state from other state.
For this we have the `$derived` rune:
```svelte
let numbers = $state([1, 2, 3, 4]);
let total = $derived(numbers.reduce((t, n) => t + n, 0))
```

Now we can use `total` in our markup:
```svelte
<p>{numbers.join(' + ')} = {total}</p>
```

The expression inside the `$derived` declaration will be re-evaluated
whenever its dependencies (in this case, just `numbers`) are updated.

Unlike normal state, derived state is read-only.

## Inspecting State

It's often useful to be able to track a piece of state as it changes.

Inside the `addNumber` function we added a `console.log` statement.
```svelte
<script>
  let numbers = $state([1, 2, 3, 4]);
  let total = $derived(numbers.reduce((t, n) => t + n, 0));

  function addNumbers() {
    numbers.push(numbers.length + 1);
    console.log(numbers);
  }
</script>

<p>{numbers.join(' + ')} = {total}</p>

<button onclick={addNumber}>
  Add a number
</button>
```
But if we look in the console we get a warning,
saying the message could not be cloned.
This is because `numbers` is a reactive proxy.

There's a number of things we can do.
First, we can create a non-reactive _snapshot_ of the state
with `$state.snapshot(...)`:
```svelte
function addNumbers() {
  numbers.push(numbers.length + 1);
  console.log($state.snapshot(numbers));
}
```

Alternatively, we can use the `$inspect` rune,
which automatically logs a snapshot of the state whenever it changes.
```svelte
function addNumbers() {
  numbers.push(numbers.length + 1);
}

$inspect(numbers);
```
The `$inspect` code will automatically be stripped out of your production build:

We can customize how the info is displayed using `$inspect(...).with(fn)`.
For example, we can use `console.trace` to see where the state originated from:
```svelte
$inspect(numbers).with(console.trace);
```

## Effects

State is only half of the equation --
state is only reactive if something is _reacting_ to it,
otherwise it's just a sparkling variable.

The thing that reacts is called an _effect_.

When we updated state before, Svelte created effects for us to update the DOM.
We can also create our own effects with the `$effect` rune.

Note: Most of the time we shouldn't create our own effects.
`$effect` is best thought of as an escape hatch.
Putting side effects in an event handler is almost always preferable.

Let's say we want to use `setInterval`
to keep track of how long the component has been mounted.
We create the effect:
```svelte
<script lang="ts">
  let elapsed = $state(0);
  let interval = $state(1000);

  $effect(() => {
    setInterval(() => {
      elapsed += 1;
    }, interval);
  });
</script>

<button onclick={() => interval /= 2}>speed up</button>
<button onclick={() => interval *= 2}>slow down</button>

<p>elapsed: {elapsed}</p>
```
Sadly upon clicking the speed up button a few times,
we speed up faster and faster and can't slow down.

`elapsed` ticks up since we're calling `setInterval`
each time `interval` gets smaller.

We can't slow down
since we're not clearing out the old intervals when the effect updates.
We can fix this by returning cleanup function:
```svelte
$effect(() => {
  const id = setInterval(() => {
    elapsed += 1;
  }, interval);

  return () => {
    clearInterval(id);
  }
})
```
The cleanup function is called immediately before 
the effect function re-runs when `interval` changes,
and also when the component is destroyed.

If the effect function doesn't read any state when it runs,
it will only run once when the component mounts.

Note: Effects do not run during server-side rendering.

## Universal reactivity

Before we've used runes to add reactivity inside components,
but we can also use runes _outside_ components,
for example, to share some global state.

In this exercise,
The `<Counter>` components are all importing `counter` from `shared.js`:
```javascript
export const counter = {
  counter: 0
};
```
`App.svelte`:
```svelte
<script>
  import Counter from './Counter.svelte';
</script>

<Counter/>
<Counter/>
<Counter/>
```
But nothing happens when you click the buttons since it's a normal object.
Wrapping the object in `$state(...)` gives an error!
We cannot use runes in a normal `.js` file,
only in `.svelte.js` files.

We rename the file to `shared.svelte.js` and wrap it in `$state(...)`:
```svelte
export const counter = $state({
  counter: 0
});
```

We update the import declaration in `Counter.svelte`:
```svelte
<script lang="ts">
  import { counter } from './shared.svelte.js';
</script>
```
Now when clicking any button, all three counters update simultaneously!

Note: You cannot export a `$state` declaration from a module
if the declaration is reassigned (rather than just mutated),
because the importers would have no way to know about it.

