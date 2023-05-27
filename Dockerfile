# Stage 1: Build Angular app
FROM node:latest AS build

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build the Angular app
RUN npm run build

# Stage 2: Create production-ready image with Nginx
FROM nginx:1.21.0-alpine

# Copy the built Angular app from the previous stage
COPY --from=build /app/dist/ /usr/share/nginx/html

# Remove the default Nginx configuration
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/

# Expose port 80
EXPOSE 4000

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
