# SvelteKit Advanced Loading
#javascript #svelte #sveltekit #loading

## Universal `load` functions

Previously, we loaded data from the server
using `+page.server.js` and `+layout.server.js` files.

This is very convenient if we need to do things
like getting data directly from a database, or reading cookies.

Sometimes it doesn't make sense to load data from the server
when doing a client-side navigation.

For example:
- We're loading data from an external API.
- We want to use in-memory data if it's available.
- We want to delay navigation until an image has been preloaded, to avoid pop-in.
- We want to return something from `load` that can't be serialized. (SvelteKit uses `devalue`, a `JSON.stringify`-like package), such as a component or a store.

In this exercise, we're dealing with the latter case.
The server `load` functions in:
`src/routes/red/+page.server.js`, `src/routes/green/+page.server.js`,
and `src/routes/blue/+page.server.js`
return a `component` constructor, which can't be serialized like data.

If we navigate to `/red`, `/blue`, or `/green`,
we will see an error in the terminal,
"Data returned from `load` ... is not serializable"

To turn the server `load` functions into universal `load` functions,
we rename each `+page.server.js` to `+page.js`.
Now, the functions will run on the server during SSR,
but will also run in the browser when the app hydrates
or the user performs a client-side navigation.

We can now use the `component` returned from these `load` functions
like any other value, including in `src/routes/+layout.svelte`:
```svelte
<nav
  class={[page.data.color && 'has-color']}
  style:background={page.data.color ?? 'var(--bg-2)'}
>
  <a href="/">home</a>
  <a href="/red">red</a>
  <a href="/green">green</a>
  <a href="/blue">blue</a>

  {#if page.data.component}
    <page.data.component />
  {/if}
</nav>
```
Read the docs to learn more about the distinction
between server `load` functions and universal `load` functions,
and when to use which.

## Using both universal and server `load` functions

Occasionally, we may need to use a server and universal load function together.

For example, we might need to return data from the server,
but also return a value that cannot be serialized as server data.

In this example, we want to return a different component from `load`
depending on whether the data we got from `src/routes/+page.server.js`
is `cool` or not.
```javascript
export async function load({ data }) {
  const module = data.cool
    ? await import('./CoolComponent.svelte')
    : await import('./BoringComponent.svelte');

  return {
    component: module.default,
    message: data.message;
  }
}
```
Note that the data isn't merged --
we must explicitly return `message` from the universal `load` function.

## Using parent data

As we saw in the introduction to layout data,
`+page.svelte` and `+layout.svelte` components have access
to everything returned from their parent `load` functions.

Occasionally, it's useful for the `load` functions themselves
to access data from their parents.
This can be done with `await parent()`.

To show how it works,
we'll sum two numbers that come from different `load` functions.
First we return some data from `src/routes/+layout.server.js`:
```javascript
export function load() {
  return { a: 1 };
}
```

Then we get that data in `src/routes/sum/+layout.js`:
```javascript
export async function load({ parent }) {
  const { a } = await parent();
  return { b: a + 1 };
}
```
Notice that a universal `load` function
can get data from a parent _server_ `load` function.
The reverse is not true however -- a server `load` function
can only get parent data from another server `load` function.

Finally, in `src/routes/sum/+page.js`,
we get parent data from both `load` functions:
```javascript
export async function load({ parent }) {
  const { a, b } = await parent();
  return { c: a + b };
}
```
Note: Take care not to introduce waterfalls when using `await parent()`.
If we can `fetch` other data that is not dependent on parent data,
do that first.

## Invalidation

When the user navigates from one page to another,
SvelteKit calls our `load` functions,
but only if it thinks something has changed.

In this example,
navigating between timezones cause the `load` function 
in `src/routes/[...timezone]/+page.js` to re-run
because `params.timezone` is invalid.

But the load function in `src/routes/+layout.js` does _not_ re-run
because as far as SvelteKit is concerned it wasn't invalidated by the navigaiton.

We can fix that by manually invalidating it using `invalidate(...)`,
which takes a URL and re-runs any `load` functions that depend on it.

Because the `load` function in `src/routes/+layout.js`
calls `fetch('/api/now')`, it depends on `/api/now`.

In `src/routes/[...timezone]/+page.svelte`, we add an `onMount` callback
that calls `invalidate('/api/now')` once per second.
```svelte
<script lang="ts">
  import { onMount } from 'svelte';
  import { invalidate } from '$app/navigation';;

  let { data } = $props();

  onMount(() => {
    const interval = setInterval(() => {
      invalidate('/api/now');
    }, 1000);

    return () => {
      clearInterval(interval);
    }
  });
</script>

<h1>
  {new Intl.DateTimeFormat([], {
    timeStyle: 'full',
    timeZone: data.timezone
  }).format(new Date(data.now))}
</h1>
```
Note: We can also pass a function to `invalidate`,
in case we want to invalidate based on a pattern and not specific URLs.

## Custom dependencies

Calling `fetch(url)` inside a `load` function registers `url` as a dependency.

Sometimes it's not appropriate to use `fetch`,
in which case we can specify a dependency manually within `depends(url)`.

Since any string that begins with `[a-z]+:` pattern is a valid URL,
we can create custom invalidation keys like `data:now`.

We update `src/routes/+layout.js` to return a value directly
and use `depends(...)` rather than making a `fetch` call
```javascript
export async function load({ depends }) {
  depends('data:now');

  return {
    now: Date.now()
  };
}
```

Now, we update the `invalidate` call in `src/routes/[...timezone]/+page.svelte`:
```svelte
<script lang="ts">
  import { onMount } from 'svelte';
  import { invalidate } from '$app/navigation';;

  let { data } = $props();

  onMount(() => {
    const interval = setInterval(() => {
      invalidate('data:now');
    }, 1000);

    return () => {
      clearInterval(interval);
    }
  });
</script>
```

## `invalidateAll`

Finally, there is a nuclear option -- `invalidateAll()`.
This will indiscriminately re-run all `load` functions for the current page,
regardless of what they depend on.

We update `src/routes/[...timezone]/+page.svelte` from the previous exercise:
```svelte
<script lang="ts">
  import { onMount } from 'svelte';
  import { invalidateAll } from '$app/navigation';;

  let { data } = $props();

  onMount(() => {
    const interval = setInterval(() => {
      invalidateAll();
    }, 1000);

    return () => {
      clearInterval(interval);
    }
  });
</script>
```
We no longer need the `depends` call in `src/routes/+layout.js`.

Note: `invalidate(() => true)` and `invalidateAll()` are not the same.
`invalidateAll` also re-reuns `load` functions without any `url` dependencies,
which `invalidate(() => true)` does not.

