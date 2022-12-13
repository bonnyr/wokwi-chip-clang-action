#!/bin/bash

# If Makefile exists, use it and assume it builds in a similar fashion to the clang command below.
// Otherwise copy the template one over and use it
if ! [-f Makefile ]; then
    cp .action/Makefile .
fi
make all