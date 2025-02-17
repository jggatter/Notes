# SvelteKit `$app/state` module
#javascript #svelte #sveltekit

SvelteKit makes 3 read-only state objects available via the `$app/state` module:
- `page`
- `navigating`
- `updated`


Note: Prior to SvelteKit 2.12, you had to use `$app/stores` for these objects,
which provides stores, e.g. `$page`, with the same information.
It's recommended to migrate towards `$app/state` and Svelte 5.

## The `page` object

The one we'll most commonly use is `page`,
which provides info about the current page via properties:
- `url`: The current URL of the page
- `params`: The current page's parameters
- `route`: an object with an `id` property representing the current route
- `status`: The HTTP status code of the current page
- `error`: The error object of the current page, if any
- `data`: the data for the page, combining return values of all `load` funcs
- `form`: the data returned from a `<form>` action.

Each of these properties is reactive, using `$state.raw` under the hood.

Here's an example using `page.url.pathname` in `src/routes/+layout.svelte`:
```svelte
<script lang="ts">
  import { page } from '$app/state';

  let { children } = $props();
</script>

<nav>
  <a href="/" aria-current={page.url.pathname === '/'}>
    home
  </a>

  <a href="/about" aria-current={page.url.pathname === '/about'}>
    about
  </a>
</nav>
    
{@render children()}
```
## The `navigating` object

The `navigating` object represents the current navigation.

When a navigation starts -- 
because of a link click, back/forwards navigation, or programmatic `goto` --
The value of `navigating` will become an object with the following properties:
- `from` and `to` -- objects with `params`, `route`, and `url` properties.
- `type` -- the type of navigation, e.g. `link`, `popstate`, or `goto`.

Note: For complete type information, visit the `Navigation` documentation.

It can be used to show a loading indicator for long-running navigations.

In this exercise,
`src/routes/+page.server.js` and `src/routes/about/+page.server.js`
both have an artificial delay.
Inside `src/routes/+layout.svelte`, 
we import `navigating` and add a message to the nav bar.
```svelte
<script lang="ts">
  import { page } from '$app/state';

  let { children } = $props();
</script>

<nav>
  <a href="/" aria-current={page.url.pathname === '/'}>
    home
  </a>

  <a href="/about" aria-current={page.url.pathname === '/about'}>
    about
  </a>
  {#if navigating.to}
    navigating to {navigating.to.url.pathname}
  {/if}
</nav>
    
{@render children()}
```

## The `updated` object

The `updated` state contains `true` or `false`
depending on whether a new version of the app has been deployed
since the page was first opened.

For this to work, our `svelte.config.js` must specify `kit.version.pollInterval`.

We import `updated`:
```svelte
<script lang="ts">
  import { page, navigating, updated } from '$app/state';
</script>
```

Version changes only happen in production, not during development.
For that reason, `updated.current` will always be `false` in this tutorial.

We can manually check for new versions, regardless of `pollInterval`,
by calling `updated.check()`.

We check whether `updated.current`:
```svelte
{#if updated.current}
  <div class="toast">
    <p>
      A new version of the app is available

      <button onclick={() => location.reload()}>
        reload the page
      </button>
    </p>
  </div>
{/if}
```

