FROM golang:alpine

WORKDIR /jenkinstest

COPY go.* .

RUN go mod download

COPY . .

RUN go mod tidy

RUN go build -o jenkinstest

EXPOSE 3000

ENTRYPOINT ["jenkinstest"]