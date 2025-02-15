# Svelte `<script module>`
#javascript #svelte #script #module

## Sharing code

In all examples we've seen so far,
the `<script>` block contains code that runs
when each component instance is initialized.
For the vast majority of components, that's all we'll ever need.

Very occasionally, you'll nee some code to run outside of a component instance.
For example, in our custom audio example (see Advanced bindings),
all four tracks can be played simultaneously.
It would be better if playing one stopped all the others.

We can do this by declaring a `<script module>` block.
Code contained inside it will run once when the module first evaluates,
rather than when a component is instantiated.

We place this at the top of `AudioPlayer.svelte`.
(Note that this is a _separate_ script tag.)
```svelte
<script module>
  let current;
</script>

<script>
  let { src, title, artist } = $props();

  let time = $state(0);
  let duration = $state(0);
  let paused = $state(true);

  function format(time) {
    if (isNaN(time)) return '...';

    const minutes = Math.floor(time / 60);
    const seconds = Math.floor(time % 60);

    return `${minutes}:${seconds < 10 ? `0${seconds}` : seconds}`;
  }
</script>
```
It's now possible for the components to 'talk' to each other
without any state management.

We give the `<audio>` element an event handler for `onplay`
that pauses any currently playing element
and sets the playing element as the current element.
```svelte
<div class={['player', { paused }]}>
  <audio
    src={src}
    bind:currentTime={time}
    bind:duration
    bind:paused
    onplay={(e) => {
      const audio = e.currentTarget;
      if (audio !== current) {
        current?.pause();
        current = audio;
      }
    }}
    onended={() => {
      time = 0;
    }}
  ></audio>

  // ...
</div>
```

## Exports

Anything exported from a `module` script block
becomes an export from the module itself.

We export the `stopAll` function from `AudioPlayer.svelte`:
```svelte
<script module>
  let current;

  export function stopAll() {
    current?.pause();
  }
</script>
```

We can now import `stopAll` in `App.svelte`:
```svelte
<script lang="ts">
  import AudioPlayer, { stopAll } from './AudioPlayer.svelte';
  import { tracks } from './tracks.js';
</script>
```

And we can use it in an event handler:
```svelte
<div class="centered">
  {#each tracks as track}
    <AudioPlayer {...track} />
  {/each}

  <button onclick={stopAll}>
    stop all
  </button>
</div>
```

Note: We can't have a default export because the component _is_ the default export.

