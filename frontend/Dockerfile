# Stage 1: Build the Next.js app
FROM node:20 AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve the built app
FROM node:20
WORKDIR /app
COPY --from=builder /app ./
RUN npm install --production
ENV PORT 3000
EXPOSE 3000
CMD ["npm", "start"]
