FROM node:alpine

WORKDIR /app

COPY package.json .
COPY package-lock.json .
RUN npm ci

COPY . .

EXPOSE 3000
STOPSIGNAL SIGINT

CMD ["npm", "start"]
