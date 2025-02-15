# Svelte Special Elements
#javascript #svelte #elements

## `<svelte:window>`

###  Web API refresher on window 

`Window` represents a window containing a DOM document;
the `document` points to the DOM document loaded in that window.

`Window.window` points to the `window` object itself.
`window` is a global object on web pages, meaning:

1. Global variables become properties of `window`:
```javascript
var global = {data: 0};
alert(global === window.global); // displays true
```

2. We can access built-in properties of `window` 
without having to prefix with `window.`:
```javascript
alert(window === window.window); // displays true
```

### Svelte `<svelte:window>`

Just as we can add event listeners to any DOM element,
we can add event listeners to the `window` object with `<svelte:window>`.

```svelte
<svelte:window {onkeydown} />
```
Our `onkeydown` captures key presses and displays them.

### `<svelte:window>` bindings

We can also bind to certain properties of `window`, such as `scrollY`:
```svelte
<svelte:window bind:scrollY={y} />
```

The list of properties we can bind to is as follows:
- `innerWidth`
- `innerHeight`
- `outerWidth`
- `outerHeight`
- `scrollX`
- `scrollY`
- `online` (an alias for `window.navigator.onLine`)

All except `scrollX` and `scrollY` are read-only.

## `<svelte:document>`

The `<svelte:document>` element
allows you to listen for events that fire on `document`.

This is useful with events like `selectionchange`,
which doesn't fire on `window`.

We add `onselectionchange` handler to the `<svelte:document>` tag:
```svelte
<svelte:document {onselectionchange} />
```
Whenever we select text with the mouse/keyboard, the DOM now updates.

Note: Avoid `mouseenter` and `mouseleave` handlers on this element,
as these events aren't fired on `document` in all browsers.
Use `<svelte:body>` instead.

## `<svelte:body>`

Similar to `<svelte:window>` and `<svelte:document>`, 
The `<svelte:body>` elem allows us to listen for events 
that fire on `document.body`.

This is useful with `mouseenter` and `mouseleave` events,
which don't fire on `window`.
```svelte
<svele:body
  onmouseenters={() => hereKitty = true}
  onmouseleave={() => hereKitty = false}
/>
```
Hovering over `<body>` with the cursor, the cat appears.
When the cursor leaves the body, the cat leaves.

## `<svelte:head>`

The `<svelte:head>` element
allows us to insert elems inside the `<head>` of our document.

This is useful for things like `<title>` and `<meta`> tags,
which are critical for good search engine optimization (SEO).

Here we show loading of stylesheets:
```svelte
<script lang="ts">
  const themes = ['margaritaville', 'retrowave', 'spaaace', 'halloween'];
  let selected = $state(themes[0]);
</script>

<svelte:head>
  <link rel="stylesheet" href="/tutorial/stylesheets/{selected}.css" />
</svelte:head>
```
When we select a theme from the dropdown, the respective stylesheet is loaded.

Note: In server-side rendering (SSR) mode,
contents of `<svelte:head>` are returned separately from the rest of our HTML.

## `<svelte:element>`

Sometimes we don't know in advance which element needs to be rendered.

Rather than having a long list of `{#if ...}` blocks, e.g.
```svelte
{#if selected === 'h1'}
  <h1>I'm a <code>&lt;h1&gt;</code> element</h1>
{:else}
  <p>TODO others</p>
{/if}
```
We can use `<svelte:element>`:
```svelte
<svelte:element this={selected}>
  I'm a <code>&lt;h1&gt;</code> element
</svelte:element>
```
The `this` value can be any string, or a falsy value.
If it's falsy, no element is rendered.

## `<svelte:boundary>`

To prevent errors from leaving our app in a broken state,
we can contain them inside an _error boundary_
using the `<svelte:boundary>` element.

In this example, `<FlakyComponent>` contains a bug --
clicking the button will set `mouse` to `null`,
meaning `{mouse.x}` and `{mouse.y}` exprs in the template will fail to render.

In an ideal world we'd simply fix the bug, but that's not always an option --
sometimes the component belongs to someone else,
and sometimes you just need to guard against the unexpected.

We wrap `<FlakyComponent />` with `<svelte:boundary>`.
We need to specify a handler, so we add a `failed` snippet to show an error.
```svelte
<svelte:boundary>
  <FlakyComponent />

  {#snippet failed(error, reset)}
    <p>Oops! {error.message}</p>
    <button onclick={reset}>Reset</button>
  {/snippet}
</svelte:boundary>
```
We can also log the error to console with the same arguments passed to `failed`:
```svelte
<svelte:boundary onerror={(e) => console.error(e)}>
// ...
```

