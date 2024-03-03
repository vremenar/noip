FROM alpine:latest as builder

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN apk add --no-cache make g++ ca-certificates wget shadow
RUN useradd -s /bin/sh noipuser
#RUN cd $(find . -maxdepth 1 -mindepth 1 -type d -name 'noip*')
RUN echo $(find . -maxdepth 1 -mindepth 1 -type d -name 'noip*')
RUN cd "noip-2.1.9-1"
RUN make
RUN cp noip2 /usr/bin

FROM alpine:latest

COPY --from=builder /usr/src/app/docker-entry.sh /bin/docker-entry.sh
COPY --from=builder /usr/bin/noip2 /usr/bin/
COPY --from=builder /etc/group /etc/
COPY --from=builder /etc/shadow /etc/
COPY --from=builder /etc/passwd /etc/

USER noipuser

ENTRYPOINT ["/bin/docker-entry.sh"]