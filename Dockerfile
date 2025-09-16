FROM node:lts

WORKDIR /app
ENV HOST=0.0.0.0
ENV PORT=3000

RUN addgroup --system api && adduser --system --ingroup api api

COPY dist/api api
COPY src/prisma ./api/prisma

RUN npm --prefix api --omit=dev -f install
RUN npx --prefix api prisma generate --schema=./api/prisma/schema.prisma

RUN chown -R api:api .
USER api

CMD ["node", "api"]
