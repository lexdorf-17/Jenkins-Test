FROM golang:alpine

LABEL maintainer "deden@topindoku.co.id"

RUN mkdir /app

ADD . /app

WORKDIR /app

COPY go.* ./

RUN go mod download

COPY . .

RUN go mod tidy

RUN go mod verify

RUN go build -o server

HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:8000 || exit 1

RUN chmod +x /app/server

EXPOSE 3000

ENTRYPOINT ["/app/server"]