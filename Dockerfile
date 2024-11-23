FROM node:alpine
RUN npm i -g pnpm # Step 1: Use the Node.js image to build the Vite app
FROM node:alpine AS builder

# Set the working directory
WORKDIR /app
RUN npm i -g pnpm 
# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN pnpm install

# Copy the rest of the application
COPY . .

# Build the Vite app
RUN pnpm run build

# Step 2: Use a lightweight server image to serve the built files
FROM nginx:alpine

# Set working directory in the Nginx container
WORKDIR /usr/share/nginx/html

# Remove the default Nginx static files
RUN rm -rf ./*

# Copy the build output from the previous stage
COPY --from=builder /app/dist .

# Expose the default Nginx port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
