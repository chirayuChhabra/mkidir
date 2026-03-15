import type { ErrorRequestHandler } from "express";

import { logger } from "../config/logger.js";

export const errorHandler: ErrorRequestHandler = (error, _req, res, _next) => {
  const statusCode =
    typeof (error as { status?: unknown }).status === "number"
      ? Number((error as { status: number }).status)
      : 500;

  const message =
    statusCode >= 500 ? "Internal server error" : error.message || "Request failed";

  if (statusCode >= 500) {
    logger.error({ err: error }, "Unhandled request error");
  }

  res.status(statusCode).json({
    error: {
      message
    }
  });
};
