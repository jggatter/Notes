# Svelte Props
#javascript #svelte #props #runes

So far we've dealt with internal state --
that is to say, the values are only accessible within a given component.

In any real app, you'll need to pass data from one component to its children.
To do this, we need to declare _properties_,
generally shortened as 'props'

## Declaring Props

In Svelte, we declare properties with the `$props` rune.

In file `Nested.svelte`:
```svelte
<script lang="ts">
  let { answer } = $props();
</script>

<p>The answer is {answer}</p>
```
In `App.svelte`:
```svelte
<script>
  import Nested from './Nested.svelte';
</script>

<Nested answer={42} />
```
We display "The answer is 42".

## Default values of props

We can easily specify default values for props in `Nested.svelte`:
```svelte
<script lang="ts">
  let { answer = 'a mystery' } = $props();
</script>
```

If we now add a second component _without_ an `answer` prop,
it will fall back to the default!
```svelte
<Nested answer={42}/>  // The answer is 42
<Nested />             // The answer is a mystery
```

## Spread props

Let's say we have an object in `App.svelte`:
```svelte
<script>
  import PackageInfo from './PackageInfo.svelte';

  const pkg = {
      name: 'svelte',
      version: 5,
      description: 'blazingly fast',
      website: 'https://svelte.dev'
  };
</script>

<PackageInfo
  version={pkg.version}
  description={pkg.description}
  website={pkg.website}
/>
```
Where `PackageInfo` component is defined in `PackageInfo.svelte`:
```svelte
<script>
  let { name, version, description, website } = $props();
</script>

<p>
  The <code>{name}</code> package is {description}.
  Download version {version} from <a href="https://www...">npm</a>
  and <a href={website}>learn more here!</a>
</p>
```

Notice that we forgot to pass the `name` to the `PackageInfo` component.
We could fix this simply by specifying `name={pkg.name}`,
but since the properies correspond to the component's expected props,
we can 'spread' them onto the component instead!
```svelte
<PackageInfo {...pkg} />
```

Note: Conversely in `Package.svelte`,
you can get an object containing all the props that were passed into a component
using a rest property...
```svelte
let { name, ...stuff } = $props();
```
or by skipping destructuring altogether:
```svelte
let stuff = $props();
```
in which case we'd access each property by the object path:
```svelte
console.log(stuff.name, stuff.verson,. stuff.description, stuff.website);
```

