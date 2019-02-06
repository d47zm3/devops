FROM node:10.6.0

RUN mkdir -p /usr/src/app/src/
WORKDIR /usr/src/app

COPY src/. /usr/src/app/src/
COPY bundling/. /usr/src/app/bundling/

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install
RUN npm run build
RUN npm audit

FROM nginx:latest
WORKDIR /usr/share/nginx/html/
COPY --from=0 /usr/src/app/dist/ .
RUN rm /usr/share/nginx/html/50x.html
