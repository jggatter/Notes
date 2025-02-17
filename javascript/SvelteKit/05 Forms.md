# SvelteKit Forms
#javascript #svelte #sveltekit #forms

In the chapter on loading data,
we saw how to get data from the server to the browser.

Sometimes we need to go the other way,
and that's where `<form>` comes in;
the web platform's way of submitting data.

## The `<form>` element

We'll build a todo list app.
We've got an in-memory database set up in `src/lib/server/database.js`,
and our `load` function in `src/routes/+page.server.js` uses `cookies`,
so we can have a per-user todo list.
We need to add a `<form>` to create new todos.

`src/routes/+page.svelte`
```svelte
<h1>todos</h1>

<form method="POST">
  <label>
    add a todo:
    <input
      name="description"
      autocomplete="off"
    />
  </label>
</form>

<ul class="todos">
```
If we type something into the `<input`> and hit Enter,
the browser makes a POST request (because of attribute `method="POST"`).

Though this results in an error,
because we haven't yet created a server-side action to handle the POST request.
Let's change that n `src/routes/+page.server.js`:
```javascript
import * as db from '$lib/server/database.js';

export function load({ cookies }) {
  // ...
}

export const actions = {
  default: async ({ cookies, request }) => {
    const data = await request.formData();
    db.createTodo(cookies.get('userid'), data.get('description'));
  }
};
```
The `request` is a standard `Request` object.
`await request.formData();` returns a `FormData` instance.

When we hit Enter, the database is updated and the page reloads with new data.

Noteice we haven't had to write any `fetch` code or anything like that --
data updates automatically.
Because we're using a `<form>` element,
this app would work even if JavaScript was disabled or unavailable.

## Named form actions

A page that only has a single action is, in practice, quite rare.
Most of the time we need multiple actions on a page.

In this app, creating a todo isn't enough --
we'd like to delete them once they're complete.

We replace our `default` action with named `create` and `delete `actions.
```javascript
export const actions = {
  create: async({ cookies, request }) => {
    const data = await request.formData();
    db.createTodo(cookies.get('userid'), data.get('description'));
  },
  delete: async ({ cookies, request }) => {
    const data = await.request.formData();
    db.deleteTodo(cookies.get('userid'), data.get('id'));
  }
};
```
Note: Default actions can't coexist with named actions.

The `<form>` element has an optional `action` attribute,
which is similar to the `<a>` element's `href` attribute.

We update the existing form so that it points to the new `create` action:
```svelte
<form method="POST" action="?/create">
  <label>
    add a todo:
    <input
      name="description"
      autocomplete="off"
    />
  </label>
</form>
```
The `action` attribute can be any URL --
if the action was created on another page it could be e.g. `/todos?/create`.
Since the action is on this page, we can omit the pathname altogether,
hence the leading `?` character.

Next we want to create a form for each todo,
complete with a hidden `<input>` that uniquely identifies it:
```svelte
<ul class="todos">
  {#each data.todos as todo (todo.id)}
    <li>
      <form method="POST" action="?/delete">
        <input type="hidden" name="id" value={todo.id} />
        <span>{todo.description}</span>
        <button aria-label="Mark as complete"></button>
      </form>
    </li>
  {/each}
</ul>
```

## Validation

Users are a mishcievous bunch, who will submit all kinds of nonsensical data.
To prevent them from causing chaos, it's important to validate form data.

The first line of defense is the browser's built-in form validation,
which makes it easy to, for example, mark an `<input>` as required:
```svelte
<form method="POST" action="?/create">
  <label>
    add a todo:
    <input
      name="description"
      autocomplete="off"
      required
    />
  </label>
</form>
```
Try hitting Enter while `<input>` is empty.

This kind of validation is helpful but not enough.
Some rules, e.g. uniqueness, can't be expressed using `<input>` attributes.
In any case, hackers can delete the attributes using browser devtools!
To guard against these shenanigans, always use server-side validation!

In `src/lib/server/database.js`, validate the description exists and is unique:
```javascript
export function createTodo(userid, description) {
  if (description === '') {
    throw new Error('todo must have a description');
  }

  const todos = db.get(userid);

  if (todos.find((todo) => todo.description === description)) {
    throw new Error('todos must be unique');
  }

  todos.push({
    id: crypto.randomUUID(),
    description,
    done: false
  })
}
```
Yikes! Submitting a duplicate todo brings us to a another page with an unfriendly error.
SvelteKit hides unexpected error messages from users
because they often contain sensitive data.

It'd be much better to stay on the same page
and provide an indication of what went wrong so the user can fix it.
To do this, we can use the `fail` function to return data
from the action along with the appropriate HTTP status code.

`src/routes/+page.server.js`
```javascript
import { fail } from '@sveltejs/kit';
import * as db from '$lib/server/database.js';

export function load({ cookies }) {
  // ...
}

export const actions = {
  create: async ({ cookies, request }) => {
    const data = await request.formData();

    try {
      db.createTodo(cookies.get('userid'), data.get('description'));
    } catch (error) {
      return fail(422, {
        description: data.get('description'),
        error: error.message
      });
    }
  }
}
```

In `src/routes/+page.svelte`,
we can access the returned value via the `form` prop,
which is only ever populated after form submission:
```svelte
<script lang="ts">
  let { data, form } = $props();
</script>

<div class="centered">
  <h1>todos</h1>
  
  {#if form?.error}
    <p class="error">{form.error}</p>
  {/if}

  <form method="POST" action="?/create">
    <label>
      add a todo:
      <input
        name="description"
        value={form?.description ?? ''}
        autocomplete="off"
        required
      />
    </label>
  </form>

  // ...
</div>
```

Note: We can return data from an action _without_ wrapping it in `fail`.
For example, we can show a `'success!'` message when data was saved,
and it will be available via the `form` prop.

## Progressive enhancement

Because we're using `<form>`, our app works even if the user doesn't have JS.
(This happens more than we'd think due to network connections or user preferences)
This is great, it means our app is resilient.

Most of the time, users do have JavaScript.
In those cases, we can _progressively_ enhance the experience,
the same way SvelteKit progressively enhances `<a>` elements
by using client-side routing.

We import the `enhance` function from `$app/forms` in `src/routes/+page.svelte`:
```svelte
<script lang="ts">
  import { enhance } from '$app/forms';

  let { data, form } = $props();
</script>
```
Then we add the `use:enhance` directive to the `<form>` elements:
```svelte
<form method="POST" action="?/create" use:enhance>
```
```svelte
<form method="POST" action="?/delete" use:enhance>
```

That's all it takes! 
Now when JavaScript is enabled,
`use:enhance` will emulate browser-native behavior except for the full-page reloads.

It will:
- update the `form` prop
- invalidate all data on a successful response, causing `load` functions to re-run
- navigate to the new page on a redirect response
- render the nearest error page if an error occurs

Now that we're updating the page rather than reloading it,
we can get fancy with things like transitions:
```svelte
<script lang="ts">
  import { fly, slide } from 'svelte/transition';
  import { enhance } from '$app/forms';

  let { data, form } = $props();
</script>

// ...

<li in:fly={{ y: 20 }} out:slide>...</li>
```

### Trade-offs of progressive enhancement

Good for public-facing websites, e.g. blogs and news sites,
where accessibility and SEO are critical.
Also good for serving a diverse audience with different devices or network connections.
Especially good for government websites.
Better performance/load times since core experience is simple and lightweight.

Not ideal for JS-heavy interactive web apps where JS is the core functionality.
Also not ideal for SPAs in JS-centered frameworks like React.

Ultimately introduces more development overhead.
More effort to build solid baseline experience then add enhancements.
More testing is required too.
Potential duplication of efforts.

## Customizing `use:enhance`

With `use:enhance`,
we can go futher than just emulating the browser's native behavior.

By providing a callback,
we can add things like pending states and optimistic UI.

We can simulate a slow network by adding artificial delay to our two actions:
```javascript
// src/routes/+page.server.js
export const actions = {
  create: async ({ cookies, request }) => {
    await new Promise((fulfill) => setTimeout(fulfill, 1000));
    // ...
  }

  delete: async ({ cookies, request }) => {
    await new Promise((fulfill) => setTimeout(fulfill, 1000));
    // ...
  }
}
```

When we create or delete items, it now takes a full second before UI updates,
leaving the user wondering if they messed up somehow.
To solve that, we add some local state in `src/routes/+page.svelte`:
```svelte
<script lang="ts">
  import { fly, slide } from 'svelte/transitions';
  import { enhance } from '$app/forms';

  let { data, form } = $props();

  let creating = $state(false);
  let deleting = $state([]);
</script>
```
Then we toggle `creating` inside the first `use:enhance`:
```svelte
<form
  method="POST"
  action="?/create"
  use:enhance={() => {
    creating = true;
    return async ({ update }) => {
      await update();
      creating = false;
    };
  }}
>
  <label>
    add a todo:
    <input
      disabled={creating}
      name="description"
      value={form?.description ?? ''}
      autocomplete="off"
      required
    />
  </label>
</form>
```

We can then show a message while we're saving data:
```svelte
<ul class="todos">
  <!-- ... -->
</ul>

{#if creating}
  <span class="saving">saving...</span>
{/if}
```

In the case of deletions,
we don't really need to wait for the server to validate anything --
we can just update the UI immediately:
```svelte
<ul class="todos">
  {#each data.todos.filter((todo) => !deleting.includes(todo.id)) as todo (todo.id)}
    <li in:fly={{ y: 20 }} out:slide>
      <form
        method="POST"
        action="?/delete"
        use:enhance={() => {
          deleting = [...deleting, todo.id];
          return async ({ update }) => {
            await update();
            deleting = deleting.filter((id) => id !== todo.id);
          };
        }}
      >
        <input type="hidden" name="id" value={todo.id} />
        <button aria-label="Mark as complete">x</button>

        {todo.description}
      </form>
    </li>
  {/each}
</ul>
```

Note: `use:enhance` is very customizable -- 
we can `cancel()` submissions,
handle redirects,
control whether the form is reset,
etc.
Read the docs for more details.

