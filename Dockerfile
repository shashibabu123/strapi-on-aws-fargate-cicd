FROM node:18-alpine

WORKDIR /app

COPY ./strapi/package.json ./package.json
COPY ./strapi/yarn.lock ./yarn.lock  # if you use yarn
RUN npm install

COPY ./strapi ./

RUN npm run build

EXPOSE 1337

CMD ["npm", "run", "start"]

