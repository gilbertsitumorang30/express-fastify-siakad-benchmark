import http from "k6/http";

import { check } from "k6";

import { TEST_CONFIG } from "../shared/config.js";

export const options = {
  vus: TEST_CONFIG.vus,

  duration: TEST_CONFIG.duration,
};

export default function () {
  const studentId = ((__VU + __ITER) % 5000) + 1;

  const response = http.get(`${TEST_CONFIG.baseUrl}/api/grades/${studentId}`);

  check(response, {
    "status is 200": (r) => r.status === 200,
  });
}
