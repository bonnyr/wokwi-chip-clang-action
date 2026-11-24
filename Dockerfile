FROM alpine:3.16
RUN apk update
RUN apk add clang lld git make llvm

# Pinned: wasi-libc's main branch moved to CMake and no longer has `make install`.
# 4362b18 (Jan 2023) dates from when this action last built successfully.
ARG WASI_LIBC_REV=4362b1885fd369e042a7c0ecd8df3b6cd47fb4e8
RUN git clone https://github.com/WebAssembly/wasi-libc.git && \
    cd /wasi-libc && \
    git checkout ${WASI_LIBC_REV} && \
    make install INSTALL_DIR=/opt/wasi-libc && \
    rm -rf /wasi-libc

RUN mkdir -p /usr/lib/clang/13.0.1/lib/wasi && \
    wget -O /usr/lib/clang/13.0.1/lib/wasi/libclang_rt.builtins-wasm32.a https://github.com/jedisct1/libclang_rt.builtins-wasm32.a/blob/master/precompiled/libclang_rt.builtins-wasm32.a?raw=true

COPY entrypoint.sh /entrypoint.sh
COPY .action /.action
ENTRYPOINT ["/entrypoint.sh"]

RUN ls -l / .action
