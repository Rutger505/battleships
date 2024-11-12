import { type Config } from "drizzle-kit";

import { env } from "@/env";

export default {
  schema: "./src/server/db/schema.ts",
  dialect: "postgresql",
  dbCredentials: {
    host: env.POSTGRES_HOST,
    port: env.POSTGRES_PORT,
    user: env.POSTGRES_USERNAME,
    password: env.POSTGRES_PASSWORD,
    database: env.POSTGRES_DATABASE,
  },
  tablesFilter: ["untitled_*"],
} satisfies Config;
