# SvelteKit Headers and Cookies
#javascript #svelte #svelekit #headers #cookies

## Setting headers

Inside a `load` function,
(as well as inside form actions, hooks, and API routes)
we have access to a `setHeaders` function,
which can be used to set headers on the response.

Most commonly we'd use it to customize caching behavior via `Cache-Control`.

This causes the browser to now render the web page as plain text.
`src/routes/+page.server.js`:
```javascript
export function load({ setHeaders }) {
  setHeaders({
    'Content-Type': 'text/plain'
  });
}
```
(You may need to reload the iframe to see the effect.)

## Reading and writing cookies

`setHeaders` can't be used with `Set-Cookie` header.
Instead we should use the `cookies` API.

In our load function, we read a cookie with `cookies.get(name, options)`:
```javascript
export function load({ cookies }) {
  const visited = cookies.get('visited');

  return {
    visited: visited === 'true'
  }
}
```

We set a cookie using `cookies.set(name, value, options)`.
It's strongly recommended to explicitly configure `path` when setting a cookie,
since browsers by default set it on the parent of the current path.
```javascript
export function load({ cookies }) {
  const visited = cookies.get('visited');

  cookies.set('visited', 'true', { path: '/' });

  return {
    visited: visited === 'true'
  }
}
```

Calling `cookies.set(name, ...)` causes a `Set-Cookie` header to be written,
but it _also_ updates the internal map of Cookies.
This means any subsequent calls to `cookies.get(name)` during the same request
will return the updated value.

Under the hood, the `cookies` API uses the `cookie` package.
Options passed to `cookies.get` and `cookies.set` correspond to
`parse` and `serialize` from the `cookie` docs.

SvelteKit sets the following to defaulta to enhance our cookie security:
```javascript
{
  httpOnly: true,
  secure: true,
  sameSite: 'lax'
}
```
