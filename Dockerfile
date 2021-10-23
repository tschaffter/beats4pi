FROM golang:1.17.0

ENV GOPATH=/go
ENV GOARCH=arm
ENV GOARM=7
# ENV CC=arm-linux-gnueabi-gcc

ENV BEATS=filebeat,metricbeat
ENV BEATS_VERSION=7.15.0

COPY ./build.sh /build.sh
COPY ./metricbeat.sh /metricbeat.sh
COPY ./filebeat.sh /filebeat.sh
RUN mkdir -p /go && mkdir /build

CMD ["/build.sh"]
