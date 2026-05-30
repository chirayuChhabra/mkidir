{
  "name": "__PROJECT_SLUG__",
  "version": "1.0.0",
  "description": "__PROJECT_TITLE__ Express API",
  "main": "src/server.ts",
  "scripts": {
    "dev": "NODE_ENV=development __RUN_CMD__ --watch src/server.ts",
    "start": "NODE_ENV=production __RUN_CMD__ src/server.ts",
    "build": "tsc",
    "lint": "biome check src",
    "format": "biome format --write src"
  },
  "dependencies": {
    __PRISMA_DEP__
    __DOTENV_DEP__
    "express": "^4.21.2",
    "cors": "^2.8.5",
    "helmet": "^8.0.0",
    "zod": "^3.23.8"
  },
  "devDependencies": {
    __PRISMA_DEV_DEP__
    __BUN_TYPES_DEP__
    "@types/cors": "^2.8.17",
    "@types/express": "^4.17.21",
    "@types/node": "^22.10.2",
    "@biomejs/biome": "^1.9.4",
    "typescript": "^5.7.2"
  }
}
