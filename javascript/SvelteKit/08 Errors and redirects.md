# SvelteKit Errors and redirects
#javascript #svelte #sveltekit #errors #redirects

## Basics: Expected and unexpected errors

There are two basic types of errors in SvelteKit --
_expected_ and _unexpected_ errors.

An expected error is one thrown via the `error` helper from `@sveltejs/kit`,
as in `src/routes/expected/+page.server.js`:
```javascript
import { error } from '@sveltejs/kit';

export function load() {
  error(420, 'Enhance your calm');
}
```

Any other error is treated as unexpected,
such as in `src/routes/unexpected/+page.server.js`:
```javascript
export function load() {
  throw new Error('Kaboom!');
}
```

When we throw an expected error,
we tell SvelteKit, "don't worry, I know what I'm doing here".

An unexpected error, by contrast, is assumed to be a bug in the app.
When thrown, its message and stack trace will be logged to console.

If we click the links in the example app,
we'll notice an important difference:
The expected error message is shown to the user,
whereas the unexpected one is redacted and replaced with 500 Internal Error.
This is because error messages can contain sensitive information!

## Error pages

When something goes wrong inside a `load` function,
SvelteKit renders an error page.

The default error page is somewhat bland.
We can customize it by creating a `src/routes/+error.svelte` component:
```svelte
<script lang="ts">
  import { page } from '$app/state';
  import { emojis } from './emojis';
</script>

<h1>{page.status} {page.error.message}</h1>
<span style="font-size: 10em">
  {emojis[page.status] ?? emojis[500]}
</span>
```

Notice that `+error.svelte` is rendered inside the root `+layout.svelte`.
We can create more granular `+error.svelte` boundaries.
We create `src/routes/expected/+error.svelte`:
```svelte
<h1>this error was expected</h1>
```
This component will be rendered for `/expected`,
while the root `src/routes/+error.svelte` page
will be rendered for any other errors that occur.

## Fallback errors

If things go _really_ wrong --
e.g. an error occurs while loading the root layout data
or while rendering the error page --
SvelteKit will fall back to a static error page.

We add a new `src/routes/+layout.server.js` to see this in action:
```javascript
export function load() {
  throw new Error('yikes');
}
```

We can customize the fallback error page.
We create a `src/error.html` file:
```html
<h1>Game over</h1>
<p>Code %sveltekit.status%</p>
<p>%sveltekit.error.message%</p>
```

This file can include the following, as seen above:
- `%sveltekit.status%`: The HTTP status code
- `%sveltekit.error.message%`: The error message

## Redirects

We can use the `redirect` mechanism to redirect from one page to another.

We create a new `load` function in `src/routes/a/+page.server.js`:
```javascript
import { redirect } from '@sveltejs/kit';

export function load() {
  redirect(307, '/b');
}
```
Navigating to `/a` will now take us straight to `/b`.

We can `redirect(...)` inside:
- `load` functions
- API routes
- the `handle` hook (discussed in the next chapter)

The most common status codes we'll use:
- `303`: For form actions following a successful submission.
- `307`: For temporary redirects
- `308`: For permanent redirects

