FROM rust:latest as initrs

RUN git clone https://github.com/cyphar/initrs /usr/src/initrs
WORKDIR /usr/src/initrs
RUN git checkout v0.1.1
RUN cargo build --release

FROM rust:latest as builder
WORKDIR /usr/src/blahaj-sexy
COPY . .
RUN cargo build --release

FROM debian:latest
COPY --from=builder /usr/src/blahaj-sexy/target/release/blahaj-sexy /blahaj-sexy
COPY --from=initrs /usr/src/initrs/target/release/initrs /initrs
COPY ./static/ /app/static/
WORKDIR /app
EXPOSE 3000
RUN useradd blahaj
USER blahaj
ENTRYPOINT ["/initrs", "/blahaj-sexy"]
