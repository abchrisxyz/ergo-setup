FROM node:16-alpine as build
RUN apk update && apk upgrade && apk add --no-cache curl python3 make g++
RUN curl -L https://github.com/ergoplatform/explorer-frontend/archive/refs/heads/master.tar.gz > /tmp/src.tar.gz && \
    tar -xf /tmp/src.tar.gz  -C /tmp && \
    mv /tmp/explorer-frontend-master /app
WORKDIR /app
# Overwrite configs and urls
ARG API
COPY environment.default.ts /app/src/config/
COPY environment.prod.ts /app/src/config/
RUN sed -i "s/https/http/g" /app/src/services/issuedToken.api.service.ts
RUN sed -i "s/api.ergoplatform.com/${API}/g" /app/src/services/issuedToken.api.service.ts
RUN sed -i "s/localhost/${API}/g" /app/src/config/environment.default.ts
RUN sed -i "s/localhost/${API}/g" /app/src/config/environment.prod.ts
# Build
RUN npm i --location=global corepack && \
    yarn && \
    yarn install && \
    yarn run build && \
    yarn cache clean && \
    yarn global add serve

FROM node:16-alpine
ENV NODE_ENV production
WORKDIR /app
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/build ./build
RUN npm i --location=global corepack && \
    yarn global add serve
CMD ["serve", "-s", "build"]
EXPOSE 3000
