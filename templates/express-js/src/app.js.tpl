import compression from "compression";
import cors from "cors";
import express from "express";
import helmet from "helmet";

import { httpLogger } from "./config/logger.js";
import { errorHandler } from "./middleware/error-handler.js";
import { notFoundHandler } from "./middleware/not-found.js";
import { apiRouter } from "./routes/index.js";

export function createApp() {
  const app = express();

  app.disable("x-powered-by");
  app.use(helmet());
  app.use(cors());
  app.use(compression());
  app.use(express.json());
  app.use(httpLogger);

  app.get("/", (_req, res) => {
    res.status(200).json({
      service: "__PROJECT_SLUG__",
      status: "ok"
    });
  });

  app.use("/api", apiRouter);
  app.use(notFoundHandler);
  app.use(errorHandler);

  return app;
}
