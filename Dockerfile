FROM golang:1.19-alpine AS golang-builder
RUN apk --no-cache add build-base git bash nodejs npm && npm install -g pnpm@latest \
    && make clean build
WORKDIR /work
COPY ./answer /work/answer
RUN ./answer build --with github.com/apache/incubator-answer-plugins/cache-redis --with github.com/apache/incubator-answer-plugins/connector-google
RUN rm -rf answer && mv new_answer answer && chmod +x answer && ./answer plugin

FROM apache/answer:latest
COPY --from=golang-builder /work/answer /usr/bin/answer
