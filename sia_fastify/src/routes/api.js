import gradeRoutes from "./grade.js";
import registrationRoutes from "./registration.js";

async function apiRoutes(app) {
  await app.register(gradeRoutes, {
    prefix: "/api",
  });

  await app.register(registrationRoutes, {
    prefix: "/api",
  });
}

export default apiRoutes;
