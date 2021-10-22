FROM node:alpine

WORKDIR /app

COPY package.json .
COPY package-lock.json .
RUN npm ci

COPY . .

EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=1s --retries=3 \
  CMD wget 0.0.0.0:3000 --spider -q -U 'wget/healthcheck'

CMD ["npm", "start"]
