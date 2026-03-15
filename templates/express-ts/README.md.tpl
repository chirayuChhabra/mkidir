# __PROJECT_TITLE__

Production-ready Express API scaffold bootstrapped with mkidir.

## Quick start

```bash
npm install
cp .env.example .env
npm run dev
```

## Scripts

- `npm run dev`: start the API in watch mode with `tsx`
- `npm run build`: compile TypeScript into `dist/`
- `npm run start`: run the compiled server
- `npm run typecheck`: validate the TypeScript project

## Structure

```text
src/
  app.ts
  server.ts
  config/
  middleware/
  modules/
  routes/
```

## First modules

- `src/modules/health`: example controller, route, and service
- `src/config`: environment and logger setup
- `src/middleware`: shared HTTP middleware
