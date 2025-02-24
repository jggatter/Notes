# SvelteKit Hooks
#javascript #svelte #sveltekit #hooks

SvelteKit provides several _hooks_;
ways to intercept and override the framework's default behavior.

## The `handle` hook

The most elementary hook is `handle`, which lives in `src/hook.server.js`.
It receives an `event` object along with a `resolve` function,
and returns a `Response` object.

`resolve` is where the magic happens:
SvelteKit matches the incoming request URL to a route of our app,
imports the relevant code (`+page.server.js`, `+page.svelte`, etc.),
loads the data needed by the route,
and generates the response.

The default `handle` hook looks like this in `src/hooks.server.js`:
```javascript
export async function handle({ event, resolve }) {
  return await resolve(event);
}
```

For pages (as opposed to API routes),
we can modify the generated HTML with `transformPageChunk`:
```javascript
export async function handle({ event, resolve }) {
  return await resolve(event, {
    transformPageChunk: ({ html }) => html.replace(
      '<body',
      '<body style="color: hotpink"'
    )
  });
}
```

We can also create entirely new routes:
```javascript
export async function handle({ event, resolve }) {
  if (event.url.pathname === '/ping') {
    return new Response('pong');
  }

  return await resolve(event, {
    transformPageChunk: ({ html }) => html.replace(
      '<body',
      '<body style="color: hotpink"'
    )
  });
}
```

## The `RequestEvent` object

The `event` object passed into `handle` is the same object that is passed into:
- API routes in `+server.js`
- `<form>` actions in `+page.server.js` files
- and `load` functions in `+page.server.js` and `+layout.server.js` files

The `event` object is an instance of interface `RequestEvent`.

It contains a number of useful properties and methods,
some of what we've already encountered:
- `cookies`: the Cookies API
- `fetch`: The standard Fetch API with additional powers
- `getClientAddress()`: a function to get the client's IP address
- `isDataRequest`: 
  - `true` if the browser is requesting data during client-side navigation,
  - `false` if page/route is being requested directly
- `locals`: A place to put arbitrary data
- `params`: The route parameters
- `request`: The `Request` object
- `route`: an object with an `id` property representing the route matched
- `setHeaders(...)`: a function for setting HTTP headers on the response
- `url`: a `URL` object represnting the current request.

A useful pattern is to add some data to `event.locals` in `handle`
so that it can be read in subsequent `load` functions.
```javascript
export async function handle({ event, resolve }) {
  event.locals.answer = 42;
  return await resolve(event);
}
```
Then in `src/routes/+page.server.js`:
```javascript
export function load(event) {
  return {
    message: `the answer is ${event.locals.answer}`
  };
}
```

## The `handleFetch` hook

The `event` object has a `fetch` method that behaves like the standard Fetch API
but with superpowers!

It can be used to make credentialed requests on the server,
as it inherits the `cookie` and `authorization` headers from the incoming request

It can make relative requests on the server
(ordinarily, `fetch` requires a URL with an origin when used in a server context)

Internal requests (e.g. for `+server.js` routes) go directly to the handler func
when running on the server,
without the overhead of an HTTP call.

It's behavior can be modified with the `handleFetch` hook,
which by default looks like this in `src/hooks.server.js`:
```javascript
export async function handleFetch({ event, request, fetch }) {
  return await fetch(requests);
}
```

For example,
we could respond to requests for `src/routes/a/+server.js`
with responses from `src/routes/b/+server.js` instead:
```javascript
export async function handleFetch({ event, request, fetch }) {
  const url = new URL(request.url);
  if (url.pathname === '/a') {
    return await fetch('/b');
  }

  return await fetch(requests);
}
```

Later when we cover universal `load` functions,
we'll see that `event.fetch` can also be called from the browser.
In that scenario, `handleFetch` is useful if we have requests to a public URL,
e.g. `https://api.yourapp.com`,
from the browser that should be redirected to an internal URL
(bypassing whatever proxies and load balancers sit between the API server and the public internet)
when running on the server.

## The `handleError` hook

The `handleError` hook lets us intercept unexpected errors and trigger some behavior
such as pinging a Slack channel or sending data to an error logging service.

As we'll recall,
an error is _unexpected_ if it wasn't created with `error` from `@sveltejs/kit`.
It generally means something in our app needs fixing.
The default behavior is to log the error:
```javascript
export function handleError({ event, error }) {
  console.error(error.stack);
}
```

For example, if we navigate to `/the-bad-place`,
an error page is shown and in the terminal we'll see the message
from `src/routes/the-bad-place/+page.server.js`.

Notice that we're _not_ showing the error message to the user.
That's because error messages can include sensitive information.
At best it will confuse the user, at worst it will benefit evildoers.

Instead, the error object avaialble to our app --
represented as `page.error` in our `+error.svelte` pages,
or `%sveltekit.error%` in our `src/error.html` fallback page --
is just this:
```javascript
{
  message: 'Internal Error' // or 'Not Found' for a 404
}
```

In some situations, we may want to customize this object.
To do so, we can return an object from `handleError`:
```javascript
export function handleError({ event, error }) {
  console.error(error.stack);

  return {
    message: 'everything is fine',
    code: 'JEREMYBEARIMY'
  };
}
```

We can now reference properties other than `message` in a custom error page.
We create `src/routes/+error.svelte`:
```svelte
<script lang="ts">
  import { page } form '$app/state';
</script>

<h1>{page.status}</h1>
<p>{page.error.message}</p>
<p>error code: {page.error.code}</p>
```

