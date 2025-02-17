# SvelteKit Routing
#javascipt #svelte #sveltekit #pages #layouts

SvelteKit uses filesystem-based routing,
which means that the _routes_ of our app,
i.e. what the app should do when the user navigates to particular URL,
are defined by the directories in our codebase.

## Pages

Every `+page.svelte` file inside `src/routes` creates a page in our app.
In this example app, we currently have one page: `src/routes/+page.svelte`,
which maps to `/`.
```svelte
<nav>
  <a href="/">home</a>
  <a href="/about">about</a>
</nav>

<h1>home</h1>
<p>this is the home page</p>
```
If we navigate to `/about`, we'll get a 404 Not Found error.

We create a second page, `src/routes/about/+page.svelte`,
pasting the contents of our first page and tweaking it:
```svelte
<nav>
  <a href="/">home</a>
  <a href="/about">about</a>
</nav>

<h1>about</h1>
<p>this is the about page</p>
```
We can now navigate between `/` and `/about`.

Note: Unlike traditional multi-page apps (MPAs),
navigating to `/about` and back updates the contents of the current page,
like a single-page app!
This gives us the best of both worlds --
fast server-rendered startup and instant navigation.
(This behavior can be configured).

## Layouts

Different routes of our app will often share common UI.
Instead of repeating it in each `+page.svelte` component,
we can use the `+layout.svelte` component
that applies to all routes in the same directory.

In this example app we have two routes,
`src/routes/+page.svelte` and `src/routes/about/+page.svelte`,
that contain the same navigation UI.
We create a new file, `src/routes/*layout.svelte`:
```
src/routes/
├ about/
│ └ +page.svelte
├ +layout.svelte
└ +page.svelte
```
Then we move duplicated content from `+page.svelte` files into
the new `+layout.svelte` file.
The `{@render children()}` tag is where the page content will be rendered:
```svelte
<script lang="ts">
  let { children } = $props();
</script>

<nav>
  <a href="/">home</a>
  <a href="/about">about</a>
</nav>

{@render children()}
```
A `+layout.svelte` file applies to every child route,
including the sibling `+page.svelte` (if it exists).
You can nest layouts to an arbitrary depth.

## Route parameters

To create routes with dynamic parameters,
use square brackets around a valid variable name.

For example, a file like `src/routes/blog/[slug]/+page.svelte`
will create a route that matches `/blog/one`, `/blog/two`, `/blog/three`, and so on.

We create that file, `src/routes/blog/[slug]/+page.svelte`:
```svelte
<h1>blog post</h1>
```
We can now navigate from the`/blog` page to individual blog posts.
In the next chapter we see how to load their content.

Note: Multiple route parameters can appear _within_ one URL segment,
as long as they are separated by at least one static character,
e.g. `foo/[bar]x[baz]` is a valid route
where `[bar]` and `[baz]` are dynamic parameters.

