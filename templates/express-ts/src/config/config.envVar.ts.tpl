import z from "zod";
import { envVarSchema } from "./config.schema";

const result = envVarSchema.safeParse(__ENV_PROCESSOR__);

if (!result.success) {
  const errorMessage = result.error.errors.map((e) => `${e.path.join(".")}: ${e.message}`).join(", ");
  throw new Error(`Invalid environment variables: ${errorMessage}`);
}

export const envVar = result.data;
