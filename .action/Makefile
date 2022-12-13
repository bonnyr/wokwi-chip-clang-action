# SPDX-FileCopyrightText: © 2022 Bonny Rais <bonnyr@gmail.com>
# SPDX-License-Identifier: MIT

SOURCES ?= $(SOURCES)
INCLUDES ?=$(INCLUDES)
CHIP_JSON ?=$(CHIP_JSON)

TARBALL  = dist/chip.tar.gz
TARGET  = dist/chip.wasm

.PHONY: all
all: clean $(TARGET)

.PHONY: clean
clean:
		rm -rf dist
dist:
		mkdir -p dist

$(TARBALL): $(TARGET) dist/$(CHIP_JSON)
	tar xzf $(TARBALL) $(TARGET) dist/chip.json

dist/$(CHIP_JSON):
	cp $(CHIP_JSON) dist/chip.json

$(TARGET): dist $(SOURCES)
	  clang --target=wasm32-unknown-wasi --sysroot /opt/wasi-libc -nostartfiles -Wl,--import-memory -Wl,--export-table -Wl,--no-entry -Werror  $(INCLUDES) -o $(TARGET) $(SOURCES)
