FROM crystallang/crystal:0.33.0-alpine-build as build-env

RUN apk add yarn libssh2-dev libssh2-static

WORKDIR /app
COPY . /app

RUN yarn && yarn build:production

FROM scratch

ENV KEMAL_ENV production
ENV PORT 3000

WORKDIR /app

COPY --from=build-env /app/bin/xterm /app/bin/xterm
COPY --from=build-env /app/public /app/public

EXPOSE $PORT

CMD ["/app/bin/xterm", "-s"]
