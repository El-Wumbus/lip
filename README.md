# **LI**terate **P**rogramming (LIP)

This document is both a valid Markdown document and a valid Odin program.  

```odin
package README

import "core:fmt"

main :: proc() {
    fmt.println("LIterate Programming! 🥳🎉")
}
```

To generate the Odin code, run:

```bash
./lip -input README.md -output README.odin \
    -begin '```odin' \
    -end '```' \
    -comment '//'
odin run ./README.odin -file
```

## Build

```bash
odin build .
```
