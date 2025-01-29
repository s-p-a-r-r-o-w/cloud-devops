#Use a lightweight web server image
FROM nginx:alpine

# Copy the static HTML file to the Nginx root directory
COPY ./index.html /usr/share/nginx/html/index.html

# Copy the images folder to the Nginx root directory
COPY ./images/* /usr/share/nginx/html/images/

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
