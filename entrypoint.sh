#!/bin/bash

# If Makefile exists, use it and assume it builds in a similar fashion to the clang command below.
// Useful for more complex repo structures
if ! [-f Makefile ]; then
    cp .action/Makefile .
fi
make all

# else    
#     mkdir -p dist
#     clang --target=wasm32-unknown-wasi --sysroot /opt/wasi-libc -nostartfiles -Wl,--import-memory -Wl,--export-table -Wl,--no-entry -Werror -o dist/chip.wasm $SOURCES
# fi