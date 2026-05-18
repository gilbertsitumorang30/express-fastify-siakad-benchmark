import http from "k6/http";

import { check } from "k6";

import { TEST_CONFIG } from "../shared/config.js";

export const options = {
  vus: TEST_CONFIG.vus,

  duration: TEST_CONFIG.duration,
};

export default function () {
  const studentId = ((__VU + __ITER) % 5000) + 1;

  const payload = JSON.stringify({
    student_id: studentId,

    academic_term: "2025-1",

    course_ids: [1, 2, 3, 4, 5],
  });

  const params = {
    headers: {
      "Content-Type": "application/json",
    },
  };

  const response = http.post(
    "http://localhost:3001/api/course-registration/submit",

    payload,

    params,
  );

  check(response, {
    "status is 200": (r) => r.status === 200,
  });
}
