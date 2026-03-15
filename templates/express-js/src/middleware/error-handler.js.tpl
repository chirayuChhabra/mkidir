import { logger } from "../config/logger.js";

export function errorHandler(error, _req, res, _next) {
  const statusCode = typeof error.status === "number" ? Number(error.status) : 500;
  const message = statusCode >= 500 ? "Internal server error" : error.message || "Request failed";

  if (statusCode >= 500) {
    logger.error({ err: error }, "Unhandled request error");
  }

  res.status(statusCode).json({
    error: {
      message
    }
  });
}
