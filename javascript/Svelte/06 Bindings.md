# Svelte Bindings
#javascript #svelte #bindings #inputs

As a general rule, data flow in Svelte is _top down_;
a parent component can set props on a child component,
and a component can set attributes on an element,
but not the other way around.

Sometimes it's useful to break this rule.

## Text inputs

Take the case of the `<input>` element in this component:
```svelte
<script>
  let name = $state('world');
</script>

<input value={name} />

<h1>Hello {name}!</h1>
```
we could add an `oninput` event handler that sets `name` to `event.target.value`,
but it's a bit... boilerplatey.
It gets worse with other from elements, as we'll see.

Instead, we can use the `bind:value` directive:
```svelte
<input bind:value={name}/>
```
This means not only will changes to `name` update the input value,
but changes to the input value will update `name`.

## Numeric inputs

In the DOM, every input value is a string.
That's unhelpful when dealing with numeric inputs --
`type="number"` and `type="range"` -- 
as it means we have to remember to coerce `input.value` before using it.

With `bind:value`, Svelte takes care of this for you:
```svelte
<script>
  let a = $state(1);
  let a = $state(2);
</script>

// Editable drop down and range slider each for a and b
<label>
  <input type="number" bind:value={a} min="0" max="10" />
  <input type="range" bind:value={a} min="0" max="10" />
</label>

<label>
  <input type="number" bind:value={b} min="0" max="10" />
  <input type="range" bind:value={b} min="0" max="10" />
</label>

<p>{a} + {b} = {a + b}</p>
```

## Checkbox inputs

Checkboxes are used for toggling between states.

Instead of binding to `input.value`, we bind to `input.checked`:
```svelte
<script>
  let yes = $state(false);
</script>

<label>
  <input type="checkbox" bind:checked={yes}>
  Yes! Send me regular email spam!
</label>
```

## Select bindings

We can also use `bind:value` with `<select>` elements:
```svelte
<select
  bind:value={selected}
  onchange={() => answer = ''}
>
  {#each questions as question}
    <option value={question}>
      {question.text}
    </option>
  {/each}
</select>
```

Note that `<option>` values are objects rather than strings. Svelte don't mind.

Note: Because we haven't set an initial value of `selected`,
the binding will set it to the default value (first in the list) automatically.
Be careful though -- until the binding is initialized,
`selected` remains undefined,
so we can't blindly reference e.g. `selected.id` in the template

##  Group inputs

If we have multiple `type="radio"` or `type="checkbox"` inputs
relating to the same value,
we can use `bind:group` along with the `value` attribute.

Radio inputs in the same group are mutually exclusive.
Checkbox inputs in the same group form an array of selected values.

```svelte
<script>
  let scoops = $state(1);
  let flavors = $state([]);
</script>

<h2>Size</h2>

{#each [1, 2, 3] as number}
  <label>
    <input
      type="radio"
      name="scoops"
      value={number}
      bind:group={scoops}
    />
    {number} {number === 1 ? 'scoop' : 'scoops'}
  </label>
{/each}

<h2>Flavors</h2>

{#each ['chocolae', 'vanilla', 'mint'] as flavor}
  <label>
    <input
      type="checkbox"
      name="flavors"
      value={flavor}
      bind:group={flavors}
    />
    {flavor}
  </label>
{/each}
```

## Select Multiple

A `select` element can have a `multiple` attribute,
in which case it will populate an array rather than selecting a single value.

```svelte
<h2>Flavors</h2>

<select multiple bind:value={flavors}>
  {#each ['chocolae', 'vanilla', 'mint'] as flavor}
    <option>{flavor}</option>
  {/each}
</select>
```

Note that We're able to omit `value` on the attribute on `<option>`
since the value is identical to the element's contents.

## Textarea inputs

The `<textarea>` element behaves similarly to a text input in Svelte;
we likewise use `bind:value`:
```svelte
<textarea bind:value={value}></textarea>
```

In cases like these, where the names match,
we can use the shorthand form:
```svelte
<textarea bind:value></textarea>
```

This applies to all bindings, not just `<textarea>` bindings.

