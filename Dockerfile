# Dockerfile for Michael Rademeyer's Portfolio Website
# Uses Nginx as a lightweight web server to serve the static site

# Stage 1: Build stage (if needed for assets)
# FROM node:18-alpine as builder
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY . .
# RUN npm run build

# Stage 2: Production stage
FROM nginx:1.25-alpine

# Set environment variables
ENV NGINX_PORT=80
ENV SITE_NAME="Michael Rademeyer Portfolio"

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the static website files
COPY . /usr/share/nginx/html

# Remove default nginx files
RUN rm -rf /usr/share/nginx/html/*

# Copy our website files
COPY index.html /usr/share/nginx/html/
COPY css/ /usr/share/nginx/html/css/
COPY js/ /usr/share/nginx/html/js/
COPY images/ /usr/share/nginx/html/images/
COPY fonts/ /usr/share/nginx/html/fonts/
COPY docs/ /usr/share/nginx/html/docs/

# Ensure proper permissions
RUN chown -R nginx:nginx /usr/share/nginx/html
RUN chmod -R 755 /usr/share/nginx/html

# Expose the port nginx is running on
EXPOSE ${NGINX_PORT}

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]