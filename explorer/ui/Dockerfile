FROM node:18-alpine as build
RUN apk update && apk upgrade && apk add --no-cache curl python3 make g++
RUN curl -L https://github.com/ergoplatform/explorer-frontend/archive/refs/heads/master.tar.gz > /tmp/src.tar.gz && \
    tar -xf /tmp/src.tar.gz  -C /tmp && \
    mv /tmp/explorer-frontend-master /app
WORKDIR /app
ARG API
ARG LABEL
COPY environment.default.ts /app/src/config/
COPY environment.prod.ts /app/src/config/
# Set configured api in config templates
RUN sed -i "s|_api_|${API}|g" /app/src/config/environment.default.ts && \
    sed -i "s|_api_|${API}|g" /app/src/config/environment.prod.ts && \
    # Set configured network name in config templates   
    sed -i "s|_name_|${LABEL}|g" /app/src/config/environment.default.ts && \
    sed -i "s|_name_|${LABEL}|g" /app/src/config/environment.prod.ts
# Update npm and install dependencies
RUN npm install -g npm@latest && \
    yarn install && \
    yarn add @babel/plugin-proposal-private-property-in-object --dev && \
    npx update-browserslist-db@latest
# Set Node environment to use legacy OpenSSL provider
ENV NODE_OPTIONS=--openssl-legacy-provider
# Build
RUN yarn run build && \
    yarn cache clean

FROM node:18-alpine
ENV NODE_ENV production
WORKDIR /app
COPY --from=build /app/build ./build
RUN yarn global add serve
CMD ["serve", "-s", "build"]
EXPOSE 3000
