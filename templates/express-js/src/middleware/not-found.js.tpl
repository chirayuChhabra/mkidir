import createHttpError from "http-errors";

export function notFoundHandler(_req, _res, next) {
  next(createHttpError(404, "Route not found"));
}
