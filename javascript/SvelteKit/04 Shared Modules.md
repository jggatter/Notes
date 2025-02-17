# SvelteKit Shared Modules
#javscript #svelte #sveltekit #shared #modules

## The $lib alias

Because SvelteKit uses directory-based routing,
it's easy to place modules and components alongside the routes that use them.
A good rule of thumb: "Put code close to where it's used."

Sometimes, code is used in multiple places.
When this happens, it's useful to place it where it can be accessed by all routes
without needing to prefix imports with `../../../..`, etc.
In SvelteKit, that place is `src/lib/`.

Anything in `src/lib/` can be accessed by any module in `src` via alias `$lib`.

Both `+page.svelte` files in this exercise import `src/lib/message.js`.
`src/routes/a/deeply/nested/route/+page.svelte`
```svelte
<script lang="ts">
  import { message } from "$lib/message.js";
</script>

<h1>a deeply nested route</h1>
<p>{message}</p>
```

`src/routes/+page.svelte`
```svelte
<script lang="ts">
  import { message } from "$lib/message.js";
</script>

<h1>home</h1>
<p>{message}</p>
```

`src/lib/message.js`
```javascript
export const message = "hello from $lib/message!";
```
