FROM rust:1.68.1 AS builder

WORKDIR /build

RUN apt-get update
RUN apt-get install -y git clang cmake libsnappy-dev
RUN git clone --branch new-index https://github.com/Blockstream/electrs .


RUN cargo install --path .

FROM debian:bullseye-slim

RUN adduser --disabled-password --uid 1000 --home /data --gecos "" electrs
USER electrs
WORKDIR /data

COPY --from=builder /usr/local/cargo/bin/electrs /bin/electrs


# HTTP
EXPOSE 3000

# Electrum RPC
EXPOSE 50001

# Prometheus monitoring
EXPOSE 4224

STOPSIGNAL SIGINT

ENTRYPOINT ["electrs"]