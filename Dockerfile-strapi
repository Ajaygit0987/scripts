FROM node:16.20.0-alpine

# Installing libvips-dev for sharp Compatibility
RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git

RUN mkdir -p /root/in-service/strapi-ecom

WORKDIR /root/in-service/strapi-ecom

COPY package.json /root/in-service/strapi-ecom/
COPY . /root/in-service/strapi-ecom/

USER root

RUN ls -lrt

# Install local dependencies
RUN npm install && npm install graphql@15.8.0

# Check Graghql version
#RUN npm ls graphql

# Build the Strapi app
RUN npm run build

EXPOSE 1337

CMD ["npm", "run", "start"]
