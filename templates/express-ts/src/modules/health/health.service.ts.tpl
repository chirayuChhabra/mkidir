import { env } from "../../config/env.js";

export function getHealthSnapshot() {
  return {
    status: "ok",
    environment: env.NODE_ENV,
    uptimeSeconds: Math.round(process.uptime()),
    timestamp: new Date().toISOString()
  };
}
