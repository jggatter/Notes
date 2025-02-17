# Introduction to SvelteKit
#javascript #svelte #sveltekit

## What is SvelteKit?

Svelte is a _component framework_ 
SvelteKit is an _app framework_, or 'metaframework'.

SvelteKit solves the tricky poblems of building something production-ready:
- Routing
- Server-side Rendering (SSR)
- Data fetching
- Service workers
- TypeScript integration
- Prerendering
- Single-page apps
- Library packaging
- Optmized production builds
- Deplying to different hosting providers.
- etc.

SvelteKit apps are server-side rendered by default
(like traditional 'multi-page apps' aka MPAs),
giving them excellent first load performance and SEO characteristics.
But then they can transition to client-side navigation
(like modern 'single-page apps' or SPAs),
letting them avoid jankily reloading everything
(including things like third-party analytics code)
when the user navigates.

SvelteKit apps can run anywhere Javscript runs,
though, as we'll see, our users may not need to run any JavaScript at all.

SvelteKit is the framework that grows with you!
Start simple and add new features as you need them.

## Project Structure

`package.json` is familiar if you've worked with Node.js before.
It lists the projects dependencies -- including `svelte` and `@sveltejs/kit` --
and a variety of `scripts` for interfacting with the SvelteKit CLI.

Note that it specifies `"type": "module"`,
which means that `.js` files are treated as native JavaScript modules by default,
rather than the legacy CommonJS format.

`svelte.config.js` contains your project configuration.
It'll be discussed later but it is also discussed on the docs.

`vite.config.js` contains the Vite configuration.
Because SvelteKit uses Vite, we can use Vite features like
hot module replacement, TypeScript support, static asset handling, etc.

`src` is where the aop's source code goes.
`src/app.html` is our page tempate.
SvelteKit replaces the `%sveltekit.head%` and `%sveltekit.body%`.
`src/rotes` defines the routes of our app.

Finally, `static` contains any assets (like a `favicon.png` or `robots.txt`)
that should be included when the app is deployed.

