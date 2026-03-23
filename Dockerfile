# Stage 1: Install dependencies
FROM node:20-alpine AS deps
# Alpine butuh libc6-compat untuk beberapa library node
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install pnpm secara global
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy file package manager saja untuk caching layer
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --frozen-lockfile

# Stage 2: Build the app
FROM node:20-alpine AS builder
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@latest --activate

COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build project Next.js
RUN pnpm run build

# Stage 3: Production runner
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV production

# Menjalankan sebagai non-root user demi keamanan
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

USER nextjs
EXPOSE 3000

# Opsi A: Cara paling standar untuk Next.js
CMD ["node", "node_modules/next/dist/bin/next", "start"]