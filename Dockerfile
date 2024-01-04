FROM golang:1.19-alpine AS golang-builder
RUN apk --no-cache add build-base git bash nodejs npm && npm install -g pnpm@latest
RUN mkdir /work
WORKDIR /work
COPY ./answer /work/answer
RUN cd /work && ls -lh && CGO_ENABLED=0 ANSWER_MODULE=github.com/apache/incubator-answer@1.2.0 /work/answer build --with github.com/apache/incubator-answer-plugins/cache-redis --with github.com/apache/incubator-answer-plugins/connector-google
# RUN cd /work && rm -rf answer && mv new_answer answer && chmod +x answer && ./answer plugin

# FROM apache/answer:1.2.0
# COPY --from=golang-builder /work/answer /usr/bin/answer
# COPY --from=golang-builder /data /data
