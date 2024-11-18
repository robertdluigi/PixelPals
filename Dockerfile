# Stage 1: Frontend build stage
FROM node:20 as frontend-builder
WORKDIR /app/frontend
COPY frontend/ ./
RUN npm install
RUN npm run build
# Ensure the build directory exists
RUN ls -al .next

# Stage 2: Backend build stage
FROM golang:1.23 as backend-builder
WORKDIR /app/backend
COPY backend/ ./
RUN go mod tidy
RUN go build -o app main.go

# Stage 3: Final production image
FROM ubuntu:latest
WORKDIR /app

# Copy backend files from backend-builder
COPY --from=backend-builder /app/backend/app ./backend

# Copy frontend files from frontend-builder (including .next output)
COPY --from=frontend-builder /app/frontend/.next ./frontend/.next

# Expose ports (e.g., 8080 for backend and 80 for frontend)
EXPOSE 8080 80

# Command to run the backend and frontend (for example, with nginx)
CMD ["sh", "-c", "npm run start --prefix ./frontend && ./backend/app"]
