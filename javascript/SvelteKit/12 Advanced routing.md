# SvelteKit Advanced routing
#javascript #svelte #sveltekit

## Optional parameters

In the first chapter on routing,
we learned how to create routes with dynamic parameters.

Sometimes, it's helpful to make a parameter optional.
A classic example is when we use the pathname to determine the locale --
`/fr/...`, `/de/...`, etc.
but we also want to have a default locale.

To do that, we use double square brackets.
We rename the `[lang]` directory to `[[lang]]`.

The app now fails to build,
because `src/routes/+page.svelte` and `src/routes/[[lang]]/+page.svelte`
would both match `/`.
We delete `src/routes/+page.svelte` and reload the app.

Lastly, we edit `src/routes/[[lang]]/+page.server.js`
to specify the default locale:
```javascript
const greetings = {
  en: 'hello!',
  de: 'hallo!',
  de: 'bonjour!',
};

export function load({ params }) {
  return {
    greeting: greetings[params.lang ?? 'en']
  };
}
```

## Rest parameters

To match an unknown number of path segments,
we use a `[...rest]` parameter,
which is named after its resemblance to JavaScript's rest parameters.

We rename `src/routes/[path]` to `src/routes/[...path]`.
The route now matches any path.

Note: Other, more specific routes will be tested first,
making rest parameters useful as 'catch-all' routes.
For example, if we need a custom 404 page for pages inside `/categories/...`,
we could add `/categories/[...catchall]/` and its files:
```
src/routes/
├ categories/
│ ├ animal/
│ ├ mineral/
│ ├ vegetable/
│ ├ [...catchall]/
│ │ ├ +error.svelte
│ │ └ +page.server.js
```
Inside `+page.server.js`, we `error(404)` inside `load`.

Rest parameters do _not_ need to go at the end.
A route like `/items/[...path]/edit` or `/items/[...path].json` is totally valid.

## Param matchers

To prevent the router from matching on an invalid input,
we could specify a _matcher_.

For example, we might want a route like `/colors/[value]`
to match hex values like `/color/ff3e00`
but not named colors like `/colors/octarine` or any other arbitrary input.

First, we create a new file called `src/params.hex.js`
and export a `match` function from it:
```javascript
export function match(value) {
  return /^[0-9a-f]{6}$/.test(value);
}
```
Then to use a new matcher, we rename `src/routes/colors/[color]`
to `src/routes/colors/[color=hex]`.

Now, whenever someone navigates to that route,
SvelteKit will verify that `color` is a valid `hex` value.
If invalid, SvelteKit will try to match other routes,
before eventually returning a `404`.

Note: Matchers run both on the server and in the browser.

## Route groups

As we saw in the routing introduction,
layouts are a way to share UI and data loading logic between different routes.

Sometimes, it's useful to use layouts without affecting the route --
e.g. we might need our `/app` and `/account` routes to be behind authentication,
while our `/about` page is open to the world.

We can do this with a _route group_, which is a directory in parentheses.

We create a `(authed)` group by renaming `account` to `(authed)/account`,
then by renaming `app` to `(authed)/app`.

Now we can control access to these routes
by creating `src/routes/(authed)/+layout.server.js`:
```javascript
import { redirect } from '@sveltejs/kit';

export function load({ cookies, url }) {
  if (!cookies.get('logged_in')) {
    redirect(303, `/login?redirectTo=${url.pathname}`);
  }
}
```

If we try to visit these pages, we'll be redirected to the `/login` route,
which has a `<form>` action in `src/routes/login/+page.server.js`
that sets the `logged_in` cookie.

We can also add some UI to these two routes
by adding a `src/routes/(authed)/+layout.svelte` file:
```svelte
<script lang="ts">
  let { children } = $props();
</script>

{@render children()}

<form method="POST" action="/logout">
  <button>log out</button>
</form>
```

## Breaking out of layouts

Ordinarily, a page inherits every layout above it,
meaning that `src/routes/a/b/c/+page.svelte` inherits four layouts:
- `src/routes/+layout.svelte`
- `src/routes/a/+layout.svelte`
- `src/routes/a/b/+layout.svelte`
- `src/routes/a/b/c/+layout.svelte`

Occasionally, it's useful to break out of the current layout hierarchy.
We can do this by adding a `@` sign,
followed by the name of the parent segment to 'reset' to --
e.g. `+page@b.svelte` would put `/a/b/c` inside `src/routes/a/b/+layout.svelte`,
while `+page@a.svelte` would put it inside `src/routes/a/+layout.svelte`.

We can reset it all the way to the root layout,
by renaming it to `+page@.svelte`.

Note: The root layout applies to every page of our app,
we cannot break out of it.
