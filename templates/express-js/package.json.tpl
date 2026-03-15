{
  "name": "__PROJECT_SLUG__",
  "version": "0.1.0",
  "private": true,
  "description": "Express API scaffold bootstrapped with mkidir",
  "type": "module",
  "engines": {
    "node": ">=20"
  },
  "scripts": {
    "dev": "node --watch src/server.js",
    "start": "node src/server.js"
  },
  "dependencies": {
    "compression": "^1.7.4",
    "cors": "^2.8.5",
    "dotenv": "^16.4.5",
    "express": "^4.21.2",
    "helmet": "^8.0.0",
    "http-errors": "^2.0.0",
    "pino": "^9.5.0",
    "pino-http": "^10.3.0",
    "pino-pretty": "^13.0.0",
    "zod": "^3.24.1"
  }
}
