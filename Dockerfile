# Stage 1: Build Backend
FROM golang:1.23 as backend-builder
WORKDIR /app/backend
COPY backend/ ./
RUN go mod tidy
RUN go build -o app main.go

# Stage 2: Build Frontend
FROM node:20 as frontend-builder
WORKDIR /app/frontend
COPY frontend/ ./
RUN npm install
RUN npm run build

# Stage 3: Final Image
FROM ubuntu:20.04
WORKDIR /app
COPY --from=backend-builder /app/backend/app ./backend
COPY --from=frontend-builder /app/frontend/build ./frontend

# Expose ports (e.g., 8080 for backend and 80 for frontend)
EXPOSE 8080
EXPOSE 80

CMD ["sh", "-c", "./backend & python3 -m http.server 80 --directory ./frontend"]
