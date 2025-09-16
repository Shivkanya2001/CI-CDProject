FROM node:lts-alpine

ENV HOST=0.0.0.0
ENV PORT=3000

WORKDIR /app

RUN addgroup --system api && adduser --system -G api api

# Install OpenSSL 1.1 compatibility for Prisma
RUN apk add --no-cache openssl1.1-compat

# Copy built app
COPY dist/api api

# Copy Prisma schema
COPY src/prisma ./api/prisma

# Install deps
RUN npm --prefix api --omit=dev -f install

# Generate Prisma client
RUN npx --prefix api prisma generate --schema=./api/prisma/schema.prisma

RUN chown -R api:api .

USER api

CMD ["node", "api"]
FROM node:lts-alpine

ENV HOST=0.0.0.0
ENV PORT=3000

WORKDIR /app

RUN addgroup --system api && adduser --system -G api api

# Copy built app
COPY dist/api api

# Copy Prisma schema into API dir
COPY src/prisma ./api/prisma

# Install deps (includes @prisma/client)
RUN npm --prefix api --omit=dev -f install

# Generate Prisma client (inside /app)
RUN npx --prefix api prisma generate --schema=./api/prisma/schema.prisma

RUN chown -R api:api .

USER api

CMD ["node", "api"]
