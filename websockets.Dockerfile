FROM node:22-alpine AS base

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

COPY ./tsconfig.json ./tsconfig.json
COPY ./src/server/socket ./src/server/socket
COPY ./src/env.js ./src/env.js

FROM oven/bun:1-alpine AS development

COPY --from=base /app/node_modules ./node_modules
COPY --from=base /app/src ./src
COPY --from=base /app/package.json /app/tsconfig.json ./

EXPOSE 3000

CMD ["bun", "run", "dev:websockets"]


FROM oven/bun:1-alpine AS production

ENV NODE_ENV production

COPY --from=base /app/node_modules ./node_modules
COPY --from=base /app/src ./src
COPY --from=base /app/package.json /app/tsconfig.json ./


EXPOSE 3000

CMD ["bun", "run", "start:websockets"]
