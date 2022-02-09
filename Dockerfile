FROM alpine:latest AS aribb24-build

RUN apk add --no-cache alpine-sdk libgcc libstdc++ ca-certificates libcrypto1.1 libssl1.1 libgomp expat git lame libass libvpx opus libtheora libvorbis x264-libs x265-libs libva autoconf autoconf automake bash binutils bzip2 cmake curl coreutils diffutils file g++ gcc gperf libtool make python3 openssl-dev tar yasm nasm zlib-dev expat-dev pkgconfig libass-dev lame-dev opus-dev libtheora-dev libvorbis-dev libvpx-dev x264-dev x265-dev libva-dev && \
# aribb24
    mkdir /tmp/aribb24 && cd /tmp/aribb24 && \
    curl -fsSL https://github.com/nkoriyama/aribb24/tarball/master | tar -xz --strip-components=1 && \
    autoreconf -fiv && ./configure && make -j$(nproc) && make install
    
FROM l3tnun/epgstation:alpine
COPY --from=aribb24-build /usr/local/share/doc/aribb24 /usr/local/share/doc/aribb24
COPY --from=aribb24-build /usr/local/lib /usr/local/lib
COPY --from=aribb24-build /usr/local/include/aribb24 /usr/local/include/aribb24
RUN apk add --no-cache ffmpeg
