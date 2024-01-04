FROM golang:1.19-alpine AS golang-builder
RUN apk --no-cache add build-base git bash nodejs npm && npm install -g pnpm@latest
WORKDIR /work
COPY ./answer /work/answer
ENV ANSWER_MODULE=github.com/apache/incubator-answer@1.2.1
RUN ANSWER_MODULE=github.com/apache/incubator-answer@1.2.1 ./answer build --with github.com/apache/incubator-answer-plugins/cache-redis --with github.com/apache/incubator-answer-plugins/connector-google
RUN rm -rf answer && mv new_answer answer && chmod +x answer && ./answer plugin

FROM apache/answer:1.2.1
COPY --from=golang-builder /work/answer /usr/bin/answer
COPY --from=golang-builder /data /data
