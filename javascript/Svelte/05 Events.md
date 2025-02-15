# Svelte Events
#javascript #svelte #events #dom

## DOM Events

As we've seen briefly already,
you can listen to any DOM event on an element with an `on<name>` function,
such as `onclick` or `onpointermove`.

```svelte
<div onpointermove={onpointermove}>
    The pointer is set at {Math.round(m.x) x {Math.round(m.y)}
</div>
```

Like with any other property where the name matches the value,
we can use the short form:
```svelte
<div {onpointermove}>
    The pointer is set at {Math.round(m.x) x {Math.round(m.y)}
</div>
```

## Inline handlers

We can also declare event handlers inline.

Instead of declaring the handler function in the script,
```svelte
<script lang="ts">
  let m = $state({ x: 0, y: 0 });

  function onpointermove(event) {
     m.x = event.clientX;
     m.y = event.clientY;
  }
</script>
  
<div onpointermove={onpointermove}>
  The pointer is at {m.x} x {m.y}
</div>
```
We can define it inline:
```svelte
<script lang="ts">
  let m = $state({ x: 0, y: 0 });
</script>
  
<div
    onpointermove={(event) => {
      m.x = event.clientX;
      m.y = event.clientY;
  }}
>
  The pointer is at {m.x} x {m.y}
</div>
```

## Capturing

Normally, event handlers run during the _bubbling_ phase.

This is when an event triggers on a child element and the event moves up through it parent elements, triggering any with an event listener for the event.
E.g. click on a button and the event bubbles up, triggering also on a parent div that has an event listener for clicks.

In this example,
```svelte
<div onkeydown={(e) => alert(`<div> ${e.key}`)} role="presentation">
  <input onkeydown={(e) => alert(`<input> ${e.key}`)} />
</div>
```
notice what happens if we type something into the `<input>` --
The inner handler runs first (on `<input>`),
as the event 'bubbles' from the target up to the document,
followed by the outer handler (on `<div>`).

Sometimes you want handlers to run during the _capture_ phase instead,
which is the opposite direction: from outermost to innermost element.

We use `...capture` handlers:
```svelte
<div onkeydowncapture={(e) => alert(`<div> ${e.key}`)} role="presentation">
  <input onkeydowncapture={(e) => alert(`<input> ${e.key}`)} />
</div>
```
Now the relative order is reversed (`<div>` then `<input>`).

If both capturing and non-capturing handlers exist for a given event,
the capturing handlers will run first.

## Component Events

You can pass event handlers down to components like any other prop.

In file `Stepper.svelte`:
```svelte
<script lang="ts">
  let { increment, decrement } = $props();
</script>

<button onclick={decrement}>-1</button>
<button onclick={increment}>+1</button>
```

In `App.svelte`:
```svelte
<script>
  import Stepper from './Stepper.svelte';

  let value = $state(0);
</script>

<p>The current value is {value}</p>

<Stepper
  increment={() => value += 1}
  decrement={() => value -= 1}
/>
```

## Spreading event handlers

We can also spread event handlers directly onto elements.

Here we've defined an `onclick` handler in `App.svelte`.
```svelte
<script>
  import BigRedButton from './BigRedButton.svelte';
  import horn from './horn.mp3';

  const audio = new Audio();
  audio.src = horn;
  
  function honk() {
      audio.load();
      audio.play();
  }
</script>

<BigRedButton onclick={honk} />
```

We pass the props to the `<button>` in `BigRedButton.svelte`:
```svelte
<script>
  let props = $props();
</script>
<button {...props}>
  Push
</button>
```

