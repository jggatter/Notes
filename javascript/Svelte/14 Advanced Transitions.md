# Svelte Advanced Transitions
#javascript #svelte #transitions #css

## Deferred transitions

A particularly powerful feature of Svelte's transition engine
is the ability to _defer_ transitions,
so that they can be coordinated between multiple elements.

For example, take this pair of todo lists,
in which toggling a todo sends it to the opposite list.
In the real world, objects do not behave like that --
instead of disappearing and reappering elsewhere,
they move through a series of intermediate positions.
Using motion can go a long way
toward helping users understand what is happening in your app.

We can achieve this effect using the `crossfade` function,
as seen in `transition.js`,
which creates a pair of transitions called `send` and `receive`.
When an element is 'sent', it looks for a corresponding elem being 'received',
and generates a transition that transforms the element
to its counterpart position and fades it out
When an element is 'received', the reverse happens.
If there is no counterpart, the `fallback` transition is used.

In `TodoList.svelte`, we first import the `send` and `receive` transitions:
```svelte
<script lang="ts">
  import { send, receive } from './transition.js';

  let { todos, remove } = $props();
</script>
```
We then add them to the `<li>` element using the `todo.id` property
as a key to match the elements:
```svelte
<li
  class={{ done: todo.done }}
  in:receive={{ key: todo.id }}
  out:send={{ key: todo.id }}
```
Now todo list items smoothly move to the other list when they are toggled.

The items that don't move to the other list still move awkwardly
within their own list though.
That can be fixed.

## Animations

To complete the illusion of smoothness from the last example,
we need to apply motion to elements that _aren't_ transitioning.

For this we use the `animate` directive.

First we import the `flip` function --
this stands for 'First, Last, Invert, Play' --
from 'svelte/animate' into `TodoList.svelte`:
```svelte
<script lang="ts">
  import { flip } from 'svelte/animate';
  import { send, receive } from './transition.js';

  let { todos, remove } = $props();
</script>
```

Then we add it to the `<li>` elements:
```svelte
<li
  class={{ done: todo.done }}
  in:receive={{ key: todo.id }}
  out:receive={{ key: todo.id }}
  animate:flip
>
```

The movement is a little slow in this case,
so we can add a `duration` parameter:
```svelte
<li
  class={{ done: todo:done }}
  in:receive={{ key: todo.id }}
  out:send={{ key.todo.id }}
  animate:flip={{ duration: 200 }}
```

Note: `duration` can also be a `d => milliseconds` function,
where `d` is the number of pixels the element has to travel.

Note all transitions and animations are being applied with CSS,
rather than JavaScript,
meaning they won't block (or be blocked by) the main thread.
