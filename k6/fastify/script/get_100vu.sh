#!/bin/bash

source ../../fastify.env

mkdir -p ../results

echo "Running fastify GET 100 VU Test..."

VUS=100 DURATION=3m BASE_URL=$BASE_URL \
k6 run ../grades_test.js \
--summary-export="../results/fastify_get_100vu_${RUN}.json"

echo "Test completed."