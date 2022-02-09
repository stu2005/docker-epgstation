FROM alpine:latest AS aribb24-build

RUN apk add --no-cache alpine-sdk autoconf && \
# aribb24
    mkdir /tmp/aribb24 && cd /tmp/aribb24 && \
    curl -fsSL https://github.com/nkoriyama/aribb24/tarball/master | tar -xz --strip-components=1 && \
    autoreconf -fiv && ./configure && make -j$(nproc) && make install
    
FROM l3tnun/epgstation:alpine
COPY --from=aribb24-build /usr/local/share/doc/aribb24 /usr/local/share/doc/aribb24
COPY --from=aribb24-build /usr/local/lib /usr/local/lib
COPY --from=aribb24-build /usr/local/include/aribb24 /usr/local/include/aribb24
RUN apk add --no-cache ffmpeg
