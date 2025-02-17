# SvelteKit Loading Data
#javascript #svelte #sveltekit

At its core, SvelteKit's job boils down to three things:
1. Routing: Figure out which route matches an incoming request
2. Loading: Get the data needed by the route
3. Rendering: Generate some HTML (on the server) or update the DOM (in browser).

We have seen how routing and rendering works,
so let's demonstrate loading.

## Page data

Every page of our app can declare a `load` function in a `+page.server.js` file
alongside the `+page.svelte` file.

As the name suggests, this `+page.server.js` module only ever runs on the server,
including for client-side navigations.

We add a `src/routes/blog/+page.server.js` file
so we can replace the hard-coded links in `src/routes/blog/+page.svelte`
with the actual blog post data:
```javascript
import { posts } from './data.js';

export function load() {
  return {
    summaries: posts.map((post) => ({
      slug: post.slug,
      title: post.title
    }))
  };
}
```

Note for the sake of the tutorial, we import data from `src/routes/blog/data.js`.
In a real app we'd likely load the data from a database or CMS.

We can access this data in `src/routes/blog/+page.svelte` via the `data` prop:
```svelte
<script lang="ts">
  let { data } = $props();
</script>

<h1>blog</h1>

<ul>
  {#each data.summaries as { slug, title }}
    <li><a href="/blog/{slug}">{title}</a></li>
  {/each}
</ul>
```

We do the same for the post page, `src/routes/blog/[slug]/+page.server.js`:
```javascript
import { posts } from '../data.js';

export function load({ params }) {
  const post = posts.find((post) => post.slug === params.slug);

  return {
    post
  };
}
```
Then likewise we access it in `src/routes/blog/[slug]/+page.svelte`
```svelte
<script lang="ts">
  let { data } = $props();
</script>

<h1>{data.post.title}</h1>
<div>{@html data.post.content}</div>
```

There's one detail we need to take care of --
The user might visit an invalid pathname like `/blog/nope`,
in which case we need to respond with a 404 page:
```javascript
import { error } from '@sveltejs/kit';
import { posts } from '../date.js';

export function load({ params }) {
  const post = posts.find((post) => post.slug === params.slug);

  if (!post) error(404);

  return {
    post
  };
}
```
We'll learn more about error handling in later chapters.

## Layout data

Just as `+layout.svelte` files create UI for every child route,
`+layout.server.js` files load data fro every child route.

Suppose we'd like to add a 'more posts' sidebar to our blog post page.
We _could_ return `summaries` 
from the `load` function in `src/routes/blog/[slug]/+page.server.js`,
like we do in `src/routes/blog/+layout.server.js`,
but that would be repetitive.

Instead we rename `src/routes/blog/+page.server.js`
to `src/routes/blog/+layout.server.js`.
Notice that the `/blog` route continues to work.

Now we add a sidebar, `<aside>`, in the layout for the post page,
`src/routes/blog/[slug]/+layout.svelte`:
```svelte
<script lang="ts">
  let { data, children } = $props();
</script>

<div class="layout">
  <main>
    {@render children()}
  </main>

  <aside>
    <h2>More posts</h2>
    <ul>
      {#each data.summaries as { slug, title }}
        <li>
          <a href="/blog/{slug}">{title}</a>
        </li>
      {/each}
    </ul>
  </aside>
</div>
```
The layout (and any page below it) inherits `data.summaries`
from the parent `+layout.server.js`.

When we navigate from one post to another,
we only need to load the data for the post itself.
The layout data is still valid.
See the documentation on invalidation to learn more.

