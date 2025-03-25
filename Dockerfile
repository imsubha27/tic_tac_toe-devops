##Build Stage##

#Use Node.js 20 (Alpine) for a lightweight build
FROM node:20-alpine AS build
#Working directory of container
WORKDIR /app
#Copy only package files for dependencies to optimize layer caching
COPY package*.json .
#Install dependencies cleanly
RUN npm ci
#Copy all project files
COPY . .
#Run the build process
RUN npm run build



##Production Stage##

#Use Nginx (Alpine) for a small production image
FROM nginx:alpine
#Copy built files to nginx’s serving dir
COPY --from=build /app/dist /usr/share/nginx/html
#Expose port 80 for HTTP traffic
EXPOSE 80
#Run nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]