# custom-chip-clang GitHub Action

A GitHub Action to build custom chips for [Wokwi Simulator](https://wokwi.com).

This action expects that the custom chip action repo using it to contain a Makefile
similar to the one stored in `.action`. If the file is not present, the Action's Makefile
is copied over and then run.

The Action also relies on `chip.json` to be present either in the top directory or in `src`

The Makefile results in the compiled source files and `chip.json` placed in `dist`
