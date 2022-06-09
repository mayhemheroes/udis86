FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y autoconf libtool python make

ADD . /repo
WORKDIR /repo
ENV LD_LIBRARY_PATH=/usr/local/lib
RUN ldconfig
RUN ./autogen.sh
RUN ./configure
RUN make -j8
RUN make install

RUN mkdir -p /deps
RUN ldd /repo/udcli/.libs/udcli | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /repo/udcli/.libs/udcli /repo/udcli/.libs/udcli
ENV LD_LIBRARY_PATH=/deps
