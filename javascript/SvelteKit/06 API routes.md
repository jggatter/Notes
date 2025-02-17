# SvelteKit API routes
#javascript #svelte #sveltekit #api #routes

SvelteKit allows us to create more than just pages.
We can create _API routes_ by adding a `+server.js` file 
that exports functions corresponding to HTTP methods
`GET`, `PUT`, `POST`, `PATCH`, and `DELETE`.

## GET handlers

This example app fetches data from an API route, `/roll`
when we click the button. 
Here is `src/routes/+page.svelte`:
```svelte
<script>
  /** @type {number} */
  let number = $state();
  
  async function roll() {
    const response = await fetch('/roll');
    number = await response.json();
  }
</script>

<button onclick={roll}>Roll the dice!</button>

{#if number !== undefined}
  <p>You rolled a {number}</p>
{/if}
```

We add a `src/route/roll/+server.js` file:
```javascript
export function GET() {
    const number = Math.floor(Math.random() * 6) + 1;

    return new Response(number, {
        headers: {
            'Content-Type': 'application/json'
        }
    });
}
```
Clicking the button now works!

Request handlers must return a `Response` object.
Since it's common to return JSON from an API route,
SvelteKit provides a convenience function for generating these responses.
```javascript
import { json } from '@sveltejs/kit';

export function GET() {
  const number = Math.floor(Math.random() * 6 + 1);

  return json(number);
}
```

## POST handlers

We can also add handlers that mutate data, such as `POST`.
In most cases, we should use `<form>` actions instead --
we'll end up writing less code, and it'll work without JavaScript.

Inside the `keydown` event handler of the 'add a todo' `<input>`,
we post some data to the server:
```svelte
<input
  type="text"
  autocomplete="off"
  onkeydown={async (e) => {
    if (e.key !== 'Enter') return;

    const input = e.currentTarget;
    const description = input.value;

    const response = await fetch('/todo', {
      method: 'POST',
      body: JSON.stringify({ description }),
      headers: {
        'Content-Type': 'application/json'
      }
    });

    input.value = '';
  }}
/>
```
Here, we're posting some JSON to the `/todo` API route --
using `userid` form the user's cookies --
and receiving the `id` of the newly created todo in response.

We create the `/todo` route by adding a `src/routes/todo/+server.js` file
with a `POST` handler that calls `createTodo` in `src/lib/server/database.js`.
```javascript
import { json } from '@sveltejs/kit';
import * as database from '$lib/server/database.js';

export async function POST({ request, cookies }) {
  const { description } = await.request.json();

  const userid = cookies.get('userid');
  const { id } = await database.createTodo({ userid, description });

  return json({ id }, { status: 201 });
}
```

As with `load` functions and form actions,
the `request` is a standard `Request` object;
`await request.json()` returns the data we posted from the event handler.

We're returning a response with 201 Created status,
and the `id` of the newly generated todo in our database.
Back in the event handler, we can use this to update the page:
```svelte
<script>
  let { data } = $props();
</script>
```
```svelte
<input
  type="text"
  autocomplete="off"
  onkeydown={async (e) => {
    if (e.key !== 'Enter') return;

    const input = e.currentTarget;
    const description = input.value;

    const response = await fetch('/todo', {
      method: 'POST',
      body: JSON.stringify({ description }),
      headers: {
        'Content-Type': 'application/json'
      }
    });

    const { id } = await response.json();

    const todos = [...data.todos, {
      id,
      description
    }];

    data = { ...data, todos };

    input.value = '';
  }}
/>
```

Note: We should only update `data` in such a way
that you'd get the same result by loading the page.
The `data` prop is not _deeply_ reactive, so you need to replace it --
mutations like `data.todos = todos` will not cause a re-render.

## Other handlers

Similarly, we can add handlers for other HTTP verbs.

We add a `/todo/[id]` route by creating `src/routes/todo/[id]/+server.js`
with `PUT` and `DELETE` handlers for toggling and removing todos,
using `toggleTodo` and `deleteTodo` functions in `src/lib/server/database.js`:
```javascript
import * as database from '$lib/server/database.js';

export async function PUT({ params, request, cookies }) {
  const { done } = await request.json();
  const userid = cookies.get('userid');

  await database.toggleTodo({ userid, id: params.id, done });
  return new Response(null, { status: 204 });
}

export async function DELETE({ params, cookies }) {
  const userid = cookies.get('userid');

  await database.deleteTodo({ userid, id: params.id });
  return new Response(null, { status: 204 });
}
```

Since we don't need return any actual data to the browser,
we're returning empty `Response` with a 204 No Content status.

We can now interact with this endpoint inside our event handlers:
```svelte
<label>
  <input
    type="checkbox"
    checked={todo.done}
    onchange={async (e) => {
      const done = e.currentTarget.checked;

      await fetch(`/todo/${todo.id}`, {
        method: 'PUT',
        body: JSON.stringify({ done }),
        headers: {
          'Content-Type': 'application/json'
        }
      });
    }}
  />

  <span>{todo.description}</span>
  <button
    aria-label="Mark as complete"
    onclick={async (e) => {
      await fetch(`/todo/${todo.id}`, {
        method: 'DELETE'
      });

      const todos = data.todos.filter((t) => t !== todo);

      data = { ...data, todos };
    }}
</label>
```

