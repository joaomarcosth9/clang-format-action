FROM ubuntu:22.04

RUN apt update && apt install -y \
        git \
        jq \
        wget \
        xz-utils

RUN wget "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.6/clang+llvm-17.0.6-x86_64-linux-gnu-ubuntu-22.04.tar.xz" -O clang.tar.xz && \
    tar xf clang.tar.xz && \
    cd clang* && \
    cp -R * /usr/local

COPY LICENSE README.md /

COPY .clang-format /.clang-format

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
