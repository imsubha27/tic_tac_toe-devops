##Build Stage##

#Use Node.js 20 (Alpine) for a lightweight build
FROM node:20-alpine AS build
#working directory of container
WORKDIR /app
#Copy package files for dependencies
COPY package*.json .
#Installing dependencies cleanly
RUN npm ci
#Copying all project files
COPY . .
#Running the build process
RUN npm run build



##Production Stage##

#Use Nginx (Alpine) for a small production image
FROM nginx:alpine
#Copying built files to nginx’s serving dir
COPY --from=build /app/dist /usr/share/nginx/html
#Exposing port 80 for HTTP traffic
EXPOSE 80
#Running nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]