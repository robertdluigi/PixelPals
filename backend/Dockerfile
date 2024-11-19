# Stage 1: Build the Go app
FROM golang:1.23 AS builder
WORKDIR /app

# Install build tools for glibc
RUN apt-get update && \
    apt-get install -y build-essential wget

# Download and compile glibc 2.34
RUN wget http://ftp.gnu.org/gnu/libc/glibc-2.34.tar.gz && \
    tar -xvf glibc-2.34.tar.gz && \
    cd glibc-2.34 && \
    mkdir build && cd build && \
    ../configure --prefix=/opt/glibc-2.34 && \
    make -j$(nproc) && \
    make install && \
    cd ../.. && rm -rf glibc-2.34*

# Set the LD_LIBRARY_PATH to include the newer glibc
ENV LD_LIBRARY_PATH="/opt/glibc-2.34/lib:$LD_LIBRARY_PATH"

# Copy go.mod file (we'll skip go.sum here)
COPY go.mod ./ 

# Run go mod tidy to clean up dependencies
RUN go mod tidy

# Download dependencies
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the Go app
RUN go build -o main .

# Stage 2: Serve the Go app
FROM debian:bullseye-slim
WORKDIR /app

# Install dependencies including a newer version of glibc
RUN apt-get update && \
    apt-get install -y libc6 libc6-dev

# Copy the compiled binary from the builder stage
COPY --from=builder /app/main .

# Expose port 8080
EXPOSE 8080

# Run the Go app
CMD ["./main"]
