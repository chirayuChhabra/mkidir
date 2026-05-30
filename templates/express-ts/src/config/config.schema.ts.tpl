import z from "zod";

export const envVarSchema = z.object({
  DATABASE_URL: z.string().optional(),
  NODE_ENV: z.enum(["production", "development", "test"]).default("development"),
  PORT: z.coerce.number().default(3000),
});
