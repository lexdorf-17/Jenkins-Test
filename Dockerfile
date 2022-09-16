FROM golang:alpine

ARG HOST_UID=1004
ARG HOST_GID=999

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

RUN usermod -u $HOST_UID jenkins
RUN groupmod -g $HOST_GID docker
RUN usermod -aG docker jenkins

USER jenkins

EXPOSE 3000

ENTRYPOINT ["/app/server"]
