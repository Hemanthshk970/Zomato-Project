# Stage 1: The Build Stage
# Use a Node.js image to build the React application
FROM node:16-slim as builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json and install dependencies
# This leverages Docker's layer caching
COPY package*.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the optimized React app
RUN npm run build

# Stage 2: The Production Stage
# Use a lightweight Nginx image to serve the static files
FROM nginx:alpine

# Copy the built files from the 'builder' stage to the Nginx public directory
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80, the standard for HTTP traffic
EXPOSE 80

# Command to start Nginx, keeping it running in the foreground
CMD ["nginx", "-g", "daemon off;"]
