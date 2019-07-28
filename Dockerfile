FROM golang:alpine AS build-env
RUN apk add git make build-base bzr
RUN git clone https://github.com/metalmatze/alertmanager-bot.git /alertmanager-bot
WORKDIR /alertmanager-bot
COPY Makefile.ARM /alertmanager-bot/Makefile
RUN make release

FROM alpine:latest
ENV TEMPLATE_PATHS=/templates/default.tmpl
RUN apk add --update ca-certificates

COPY --from=build-env /alertmanager-bot/default.tmpl /templates/default.tmpl
COPY --from=build-env /alertmanager-bot/dist/alertmanager-bot--linux-arm /usr/bin/alertmanager-bot

EXPOSE 8080

ENTRYPOINT ["/usr/bin/alertmanager-bot"]
