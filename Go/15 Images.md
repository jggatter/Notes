# Go Images
#go #images

The `image` package defines an `Image` interface.

The `Image` declares these methods:
```go
package image

type Image interface {
    ColorModel() color.Model
    Bounds() Rectangle  // image.Rectangle
    At(x, y int) color.Color
}
```

`color.Color` and `color.Model` are also interfaces.
`color.RGBA` and `color.RGBAModel` are predefine implementations.
These interface and types are specified by the `image/color` stdlib package.

```go
package main

import (
	"fmt"
	"image"
)

func main() {
	m := image.NewRGBA(image.Rect(0, 0, 100, 100))
	fmt.Println(m.Bounds())  // (0,0)-(100,100)
	fmt.Println(m.At(0, 0).RGBA())  // 0 0 0 0
}
``
