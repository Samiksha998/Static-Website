FROM nginx:alpine
COPY . /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# Use official nginx image as the base
FROM nginx:alpine

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Add custom nginx config for port 8080
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy static website files to nginx html directory
COPY . /usr/share/nginx/html

EXPOSE 8080

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]
