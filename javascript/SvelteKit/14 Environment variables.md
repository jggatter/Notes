# SvelteKit Environment Variables
#javascript #svelte #sveltekit #environment

Environment variables -- like API keys and DB credentials --
can be added to an `.env` file,
and they will be made available to our application.

Note: we can also use `.env.local` or `.env.[mode]` files --
see the Vite documentation for more information.
Make sure we add any files containing sensitive information to our `.gitignore`!
Environment variables in `process.env` are also available via `$env/static/private`.

## `$env/static/private`

In this exercise,
we want to allow users to enter the website if they know the correct passphrase.

First in `.env`, we add a new environment variable:
```
PASSPHRASE="open sesame"
```

We open `src/routes/+page.server.js`
and import `PASSPHRASE` from `$env/static/private`,
using it inside the `<form>` action:
```javascript
import { redirect, fail } from '@sveltejs/kit';
import { PASSPHRASE } from '$env/static/private';

export function load({ cookies }) {
  if (cookies.get('allowed')) {
    redirect(307, '/welcome');
  }
}

export const actions = {
  default: async ({ request, cookies }) => {
    const data = await request.formData();

    if (data.get('passphrase') == PASSPHRASE) {
      cookies.set('allowed', 'true', {
        path: '/'
      });

      redirect(303, '/welcome');
    }

    return fail(403, {
      incorrect: true
    });
  }
};
```
The website is now accessible to anyone who knows the correct passphrase.

### Keeping secrets

It's important that sensitive data 
doesn't accidentally end up being sent to the browser.
where it could be stolen by hackers and scoundrels.

SvelteKit makes it easy to prevent this from happening.
Notice what happens if we try to import `PASSPHRASE`
into `src/routes/+page.svelte`
```svelte
<script lang="ts">
  import { PASSPHRASE } from '$env/static/private';
  let { form } = $props();
</script>
```
An error overlay appears, telling us that `$env/static/private`
cannot be imported into client-side code.
It can only be imported into the server modules:
- `+page.server.js`
- `+layout.server.js`
- `+server.js`
- Any module ending in `.server.js`
- Any module inside `src/lib/server`

In turn, these modules can be only imported by _other_ server modules.

### Static vs. dynamic

The `static` in `$env/static/private`
indicates these values are known at build time, and can be _statically replaced_.

This enables useful optimizations:
```javascript
import { FEATURE_FLAG_X } from '$env/static/private';

if (FEATURE_FLAG_X === 'enabled') {
  // if FEATURE_FLAG_X is not enabled,
  // code in here will be removed from the build output
}
```

In some cases,
we might need to refer to environment variables that are _dynamic_ --
i.e. not known until we run the app.

## `$env/dynamic/private`

If we need to read the values of env variables when the app runs,
as opposed to when the app is built,
we can use `$env/dynamic/private` (instead of `$env/static/private`).

Example in `src/route/+page.server.ts`:
```typescript
import { redirect, fail } from '@sveltejs/kit';
import { env } from '$env/dynamic/private';

export function load({ cookies }) {
  if (cookies.get('allowed')) {
    redirect(307, '/welcome');
  }
}

export const actions = {
  default: async ({ request, cookies }) => {
    const data = await request.formData();

    if (data.get('passphrase') === env.PASSPHRASE) {
      cookies.set('allowed', 'true', {
        path: '/'
      });

      redirect(303, '/welcome');
    }

    return fail(403, {
      incorrect: true
    });
  }
}
```

## `$env/static/public`

Some environment variables _can_ be safely exposed to the browser.
These are distinguished from private env variables with a `PUBLIC_` prefix.

We add values to two public env variables in `.env`:
```
PUBLIC_THEME_BACKGROUND="steelblue"
PUBLIC_THEME_FOREGROUND="bisque"
```

Then we import them into `src/routes/+page.svelte`:
```svelte
<script lang="ts">
  import {
    PUBLIC_THEME_BACKGROUND,
    PUBLIC_THEME_FOREGROUND
  } from '$env/static/public';
</script>
```

## `$env/public/dynamic`

As with private env vars,
for public env vars it's preferable to use static values if possible.

If it's necessary, we can use dynamic values instead.
Example in `src/routes/+page.svelte`:
```svelte
<script lang="ts">
  import { env } from '$env/dynamic/public';
</script>

<main
  style:background={env.PUBLIC_THEME_BACKGROUND}
  style:color={env.PUBLIC_THEME_FOREGROUND}
>
  {env.PUBLIC_THEME_FOREGROUND} on {env.PUBLIC_THEME_BACKGROUND}
</main>
```

