# SitCon

A an excuse to play around with Elm thinly disguised as a chat app.

## Development

### Install

```bash
$ git clone git@github.com:skuttleman/sitcon.git
$ cd sitcon
$ lein install && elm package install && npm install
```

## Setup

Add the following variables to a file called `.lein-env` or to your shell env. Requires postgres ^9.6

```clojure
{"PORT" "<SERVER_PORT_NUMBER>"
 "NREPL_PORT" "<NREPL_PORT_NUMBER>"
 "BASE_URL" "http://localhost:<SERVER_PORT_NUMBER>"
 "JWT_SECRET" "<SOME_RANDOM_STRING>"
 "DB_USER" "<PG_USER>"
 "DB_PASSWORD" "<PG_PASSWORD>"
 "DB_HOST" "<PG_HOST>"
 "DB_PORT" "<PG_PORT>"
 "DB_NAME" "<PG_DATABASE_NAME>"}
```

### Run

Run locally on port `${PORT:-3000}` with nrepl at port `${NREPL_PORT:-7000}`.

```bash
$ lein cooper
```

### Build

```bash
$ lein uberjar
```
