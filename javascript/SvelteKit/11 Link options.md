# SvelteKit Link options
#javascript #svelte #sveltekit #links

##  Preloading

In this exercise, the `/slow-a` and `/slow-b` routes have artificial delay 
in their `load` functions,
i.e. it takes a long time to navigate to them.

We can't always make data load more quickly, sometimes it's out of our control.
However, SvelteKit can speed up navigations by _anticipating_ them.

When a `<a>` element has the `data-sveltekit-preload-data` attribute,
SvelteKit will start the navigation as soon as 
the user hovers over the link (on desktop)
or taps it (on mobile)

We add it to the first link in `src/routes/+layout.svelte`:
```svelte
<nav>
  <a href="/">home</a>
  <a href="/slow-a" data-sveltekit-preload-data>slow-a</a>
  <a href="/slow-b">slow-b</a>
</nav>
```
Navigating to `/slow-a` will now be noticeably faster.

Starting navigation on hover/tap rather than waiting for a `click` event
might not sound like it makes that much of a difference,
but in practice it typically saves 200ms or more.
That's enough to be the difference between sluggish and snappy.

We can put the attribute on individual links,
or on any element that _contains_ links.

The default project template includes the attributes on the `<body>` element.
```svelte
<body data-sveltekit-preload-data>
  %sveltekit.body%
</body>
```

We can customize the behavior further by specifying a value for the attribute:
- `"hover"` (default, falls back to `"tap"` on mobile)
- `"tap"`: only begin preloading on tap
- `"off"`: disable preloading

Using `data-sveltekit-preload-data` may sometimes result in false positives,
i.e. loading data in anticipation of a navigation that doesn't then happen.
This may be undesirable.

As an alternative, `data-sveltekit-preload-code` allows us to preload JS 
needed by a given route without eagerly loading its data.
This attribute can have the following values:
- `"eager"`: preload everything on the page following a navigation
- `"viewport"`: preload everything as it appears in the viewport
- `"hover"` (default, falls back to `"tap"` on mobile)
- `"tap"`: only begin preloading on tap
- `"off"`: disable preloading

We can also initiate preloading programmatically
with `preloadCode` and `preloadData` imported from `$app/navigation`:
```javascript
import { preloadCode, preloadData } from '$app/navigation';

// preload code and data needed to navigate to /foo
preloadData('/foo');


// preload only code needed to navigate to /foo
preloadCode('/bar');
```

## Reloading the page

Ordinarily, SvelteKit will navigate between pages without refreshing the page.

In this exercise, if we navigate between `/` and `/about`,
the timer keeps on ticking.

In rare cases, we may want to disable this behavior.
We can do so by adding the `data-sveltekit-reload` attribute
on an individual link, or any element that contains links.
E.g. in `src/routes/+layout.svelte`:
```svelte
<nav data-sveltekit-reload>
  <a href="/">home</a>
  <a href="/about">about</a>
</nav>
```
This will cause full-page navigation when clicking a link.

For more info on available link options and their values,
consult the link options documentation.

