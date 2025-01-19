# Go Maps
#go #maps #make #zerovalues

A map maps keys to values.

The type can be annotated using `map[K]V`,
where `K` is the hashable key type,
and `V` is the stored value.

The zero value of a map is `nil`.
A `nil` map has no keys, nor can keys be added.

Maps are another reference type, just as slices are.
Copying a map creates a new reference to the same underyling data.

The `make` built-in function returns a map of the given type,
initialized and ready for use.

Example:
```go
type Vertex struct {
	Lat, Long float64
}

var m map[string]Vertex

func main() {
	m = make(map[string]Vertex)
	m["Bell Labs"] = Vertex{
		40.68433, -74.39967,
	}
	fmt.Println(m["Bell Labs"])
}
```

## Map literals

Map literals are like struct literal, but the keys are required!
```go
var m = map[string]Vertex{
	"Bell Labs": Vertex{
		40.68433, -74.39967,
	},
	"Google": Vertex{
		37.42202, -122.08408,
	},
}
```

If the top-level type is just a type name, e.g. `Vertex`
you can omit it from the elements of the literal.
Here we don't have to declare elements as `Vertex{}`.
```go
type Vertex struct {
	Lat, Long float64
}

var m = map[string]Vertex{
	"Bell Labs": {40.68433, -74.39967},
	"Google":    {37.42202, -122.08408},
}
```

## Mutating maps

We can insert or update elements in a map,
```go
m[key] = elem
```

Retrieve an element:
```go
elem = m[key]
```

Delete an element using `delete`:
```go
delete(m, key)
```

Check whether a key is present with a two-value assignment,
```go
elem, ok = m[key]
// Note: if neither are yet declared, := can be used
```
`ok` is `true` if `key` is in `m`.
`elem` is the element type's zero value if `key` is not in `m`.

