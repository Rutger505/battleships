FROM node:22-alpine AS base

WORKDIR /app


FROM base AS development

COPY package.json package-lock.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev"]


FROM base AS deps

RUN apk add --no-cache libc6-compat openssl

COPY package.json package-lock.json ./

RUN npm ci


FROM base AS builder

# Client side environment variables must be set here.
# They won't be read from .env file during runtime

COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN SKIP_ENV_VALIDATION=1 npm run build


FROM base AS production

WORKDIR /app

ENV NODE_ENV production

COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json

COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

EXPOSE 3000
ENV PORT 3000

CMD ["server.js"]
