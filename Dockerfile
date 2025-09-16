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

# Generate Prisma client (inside /app/api)

RUN npx --prefix api prisma generate --schema=prisma/schema.prisma

RUN chown -R api:api .

USER api

CMD ["node", "api"]
