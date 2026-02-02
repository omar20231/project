FROM node:23-slim AS build

WORKDIR /app

COPY package*.json yarn.lock ./

RUN yarn install 

COPY . .

RUN yarn build

FROM node:23-alpine

WORKDIR /app

COPY --from=build /app/build ./build

RUN addgroup -g 1001 app && \
    adduser -D -u 1001 -G app app
USER app

EXPOSE 3000
CMD ["npx","serve", "-s", "build"]
