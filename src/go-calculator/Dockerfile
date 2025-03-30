FROM golang:latest as builder
WORKDIR /app
COPY . .
RUN go mod tidy && GOOS=linux CGO_ENABLED=0 go build -ldflags="-w -s" -o api .

FROM scratch
COPY --from=builder /app/api .
CMD ["./api"]
EXPOSE 7000
