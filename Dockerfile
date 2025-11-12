FROM nginx:alpine

# Copy static website files to nginx html directory
COPY . /usr/share/nginx/html

# Expose port 80 (default for nginx)
EXPOSE 80

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]
CMD ["nginx", "-g", "daemon off;"]
