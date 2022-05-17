FROM --platform=linux/amd64 ubuntu:20.04

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
