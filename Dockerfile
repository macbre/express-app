# our base image
FROM node:lts-alpine

# set up the directory for the application
WORKDIR /app

# install the application dependencies
COPY package.json .
COPY package-lock.json .
RUN npm ci

# copy the rest of the files and make sure the app works as "nobody"
COPY --chown=nobody:nogroup . .
USER nobody

EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=1s --retries=3 \
  CMD wget 0.0.0.0:3000 --spider -q -U 'wget/healthcheck'

CMD ["npm", "start"]
