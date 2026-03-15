import type { Request, Response } from "express";

import { getHealthSnapshot } from "./health.service.js";

export function getHealth(_req: Request, res: Response) {
  res.status(200).json({
    data: getHealthSnapshot()
  });
}
