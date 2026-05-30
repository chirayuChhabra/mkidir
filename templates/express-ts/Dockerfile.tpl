FROM node:22-alpine AS builder

WORKDIR /app
COPY package*.json pnpm-lock.yaml bun.lockb ./
RUN npm install -g pnpm bun && \
    if [ -f bun.lockb ]; then bun install --frozen-lockfile; \
    elif [ -f pnpm-lock.yaml ]; then pnpm install --frozen-lockfile; \
    else npm ci; fi

COPY . .
RUN npm run build

FROM node:22-alpine AS runner

WORKDIR /app
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000
CMD ["node", "dist/server.js"]
