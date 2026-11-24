# Prebuilt WASI toolchain: clang, wasi-libc sysroot and compiler-rt builtins
# from one wasi-sdk release, so they always match each other.
# To upgrade, change WASI_SDK_VERSION to a release listed at
# https://github.com/WebAssembly/wasi-sdk/releases
FROM debian:bookworm-slim

ARG WASI_SDK_VERSION=34
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl make && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_SDK_VERSION}/wasi-sdk-${WASI_SDK_VERSION}.0-x86_64-linux.tar.gz \
      | tar xzf - -C /opt && \
    mv /opt/wasi-sdk-${WASI_SDK_VERSION}.0-x86_64-linux /opt/wasi-sdk && \
    # chip Makefiles use `clang --sysroot /opt/wasi-libc`: keep that path working
    ln -s /opt/wasi-sdk/share/wasi-sysroot /opt/wasi-libc && \
    /opt/wasi-sdk/bin/clang --version

# Newer clang reports --target=wasm32-wasi (used by existing chip Makefiles) as
# deprecated in favour of wasm32-wasip1, which -Werror turns into a failure.
# Keep it a warning so those Makefiles still build.
RUN echo '-Wno-error=deprecated' > /opt/wasi-sdk/bin/clang.cfg && \
    printf 'int x;\n' > /tmp/t.c && \
    /opt/wasi-sdk/bin/clang --target=wasm32-unknown-wasi --sysroot /opt/wasi-libc -Werror -c /tmp/t.c -o /tmp/t.o && \
    rm /tmp/t.c /tmp/t.o

ENV PATH=/opt/wasi-sdk/bin:$PATH

COPY entrypoint.sh /entrypoint.sh
COPY .action /.action
ENTRYPOINT ["/entrypoint.sh"]
