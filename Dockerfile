FROM golang:alpine

LABEL maintainer "deden@topindoku.co.id"

WORKDIR /jenkinstest

COPY go.* ./

RUN go mod download

COPY . .

RUN go mod tidy

RUN go mod verify

RUN go build -o jenkinstest

EXPOSE 3000

HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:8000 || exit 1

RUN chmod +x jenkinstest

ENTRYPOINT ["jenkinstest"]