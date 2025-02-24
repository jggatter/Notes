# SvelteKit Page options
#javascript #svelte #sveltekit #page #ssr #spa

In the chaper on loading data, we saw how we can export `load` functions
from `+page.js`, `+page.server.js`, `+layout.js`, and `+layout.server.js` files.

We can also export various page options from these modules:
- `ssr`: whether or not pages should be server-rendered
- `csr`: whether to load the SvelteKit client
- `prerender`: whether to prerender pages at build time, instead of per-request.
- `trailingSlash`: whether to strip, add, or ignore trailing slashes in URLs.

Page options can apply to individual pages
(if exported from `+page.js` or `+page.server.js`)
or groups of pages
(if exported from `+layout.js` or `+layout.server.js`).

To define an option for the whole app, export it form the root layout.
Child layouts and pages override values set in the parent layouts,
so for example, we can enable prerendering for the entire app
and then disable it for pages that need to be dynamically rendered.

We can mix and match these options in different areas of our app.
We could prerender our marketing pages,
dynamically server-render our data-driven pages,
and treat our admin pages as a client-rendered SPA.
This makes SvelteKit very versatile!

## The `ssr` page option

Server-side rendering (SSR) is the process of generating HTML on the server,
and it is what SvelteKit does by default.

SSR is important for performance and resilience (no JS),
and is very beneficial for search engine optimization (SEO).
While some search engines can index content rendered in the browser with JS,
it happens less frequently and reliably.


That said, some components _can't_ be rendered on the server,
perhaps because they expect to be able to access browser globals immediately
such as `window`.

If we can,
we should change those components so that they _can_ render on the server,
but we can't then we can disable SSR.
E.g. in `src/routes/+page.server.js`:
```javascript
export const ssr = false;
```

Note: setting `ssr` to `false` inside our root `+layout.server.js`
effectively turns our entire app into a SPA.

## The `csr` page option

Client-side rendering (CSR) is what makes the page interactive --
such as incrementing the counter when we click the button in this app.

CSR enables SvelteKit to update the page upon navigation
without a full-page reload.

As with the `ssr` page option, we can disable CSR altogether.
E.g. in `src/routes/+page.server.js`:
```javascript
export const csr = false;
```

This means no JavaScript is served to the client,
but it also means that the components are no longer interactive.

It can be a useful way to check whether or not our application is usable
for people, who for whatever reason, cannot use JavaScript.

## The `prerender` option

Prerendering means generating HTML for a page once at build time,
rather than dynamically for each request.

The advantage is that serving static data is extremely cheap and performant,
allowing us to easily serve large numbers of users
without worrying about cache-control headers (which are easy to get wrong).

The tradeoff is that the build process takes longer,
and prerendered content can only be updated 
by building and deploying a new version of the application.

To prerender a page, we set `prerender` to `true`.
E.g. in `src/routes/+page.server.js`:
```javascript
export const prerender = true;
```
(Here in the tutorial, this won't have any observable effect,
since the application is running in `dev` mode.)

Not all pages can be prerendered. The basic rule is this: 
For content to be prerenderable, any two users hitting it directly
must get the same content from the server,
and the page must not contain `<form>` actions.

Pages with dynamic route parameters can be prerendered
as long as they are specified in the `prerender.entries` configuration
or can be reached by following links from pages that _are_ in `prerender.entries`.

Note: Setting `prerender` to `true` inside our root `+layout.server.js`
effectively turns SvelteKit into a static site generator (SSG).

## The `trailingSlash` option

Two URLS like `/foo` and `/foo/` might look the same,
but they're actually different.

A relative URL like `./bar` will resolve to `/bar` for the case of `/foo`,
and to `/foo/bar` for the case of `/foo/`.
Search engines will treat these as separate entries, harming SEO.

In short, we should be strict about trailing slashes.
By default, SvelteKit strips trailing slashes,
meaning that a request for `/foo/` will redirect to `/foo`.

If we instead wnat to ensure that a trailing slash is always present,
we can specify the `trailingSlash` option accordingly.
E.g. in `src/routes/+page.server.js`:
```javascript
export const trailingSlash = 'always';
```

To accomodate both cases (not recommended), use `ignore`:
```javascript
export const trailingSlash = 'ignore';
```

The default value is `'never'`.

Prerendering is affected whether or not trailing slashes are applied.
A URL like `/always/` will be saved to disk as `always.index.html`,
whereas a URL like `/never` will be saved as `never.html`.

