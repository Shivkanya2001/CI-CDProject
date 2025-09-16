FROM node:lts-alpine

ENV HOST=0.0.0.0
ENV PORT=3000

WORKDIR /app

RUN addgroup --system api && \
    adduser --system -G api api

COPY package*.json ./
COPY prisma ./prisma
RUN npm install
RUN npx prisma generate

COPY dist/api api
RUN chown -R api:api .

# Only install production dependencies inside the final app folder
RUN npm --prefix api --omit=dev -f install

CMD ["node", "api"]
