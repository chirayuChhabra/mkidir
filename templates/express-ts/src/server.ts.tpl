import http from "node:http";

import { createApp } from "./app.js";
import { env } from "./config/env.js";
import { logger } from "./config/logger.js";

const app = createApp();
const server = http.createServer(app);

server.listen(env.PORT, () => {
  logger.info({ port: env.PORT, env: env.NODE_ENV }, "Server listening");
});

function shutdown(signal: string) {
  logger.info({ signal }, "Shutting down HTTP server");
  server.close((error) => {
    if (error) {
      logger.error({ err: error }, "Server shutdown failed");
      process.exit(1);
    }

    process.exit(0);
  });
}

process.on("SIGINT", () => shutdown("SIGINT"));
process.on("SIGTERM", () => shutdown("SIGTERM"));
