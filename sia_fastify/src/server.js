import dotenv from "dotenv";

import app from "./app.js";
import apiRoutes from "./routes/api.js";

dotenv.config();

const PORT = process.env.PORT || 3000;

await app.register(apiRoutes);

try {
  await app.listen({
    port: PORT,
    host: "0.0.0.0",
  });

  console.log(`Server running on port ${PORT}`);
} catch (error) {
  console.error(error);

  process.exit(1);
}
