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

ENV PATH=/opt/wasi-sdk/bin:$PATH

COPY entrypoint.sh /entrypoint.sh
COPY .action /.action
ENTRYPOINT ["/entrypoint.sh"]
