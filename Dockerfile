FROM node:lts-alpine

ENV HOST=0.0.0.0
ENV PORT=3000

WORKDIR /app

RUN addgroup --system api && adduser --system -G api api

# Copy built app
COPY dist/api api

# Copy Prisma schema
COPY src/prisma ./src/prisma

# Install deps
RUN npm --prefix api --omit=dev -f install

# Generate Prisma client (inside /app/api)
RUN npx --prefix api prisma generate --schema=../src/prisma/schema.prisma

RUN chown -R api:api .

USER api

CMD ["node", "api"]
