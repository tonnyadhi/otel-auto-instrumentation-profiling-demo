FROM golang:1.25-alpine as builder
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o server main.go

FROM alpine:3.19
WORKDIR /app
COPY --from=builder /src/server .
EXPOSE 8080
CMD ["./server"]