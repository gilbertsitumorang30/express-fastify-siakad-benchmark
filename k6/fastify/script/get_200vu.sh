#!/bin/bash

source ../../fastify.env

mkdir -p ../results

echo "Running fastify GET 200 VU Test..."

VUS=200 DURATION=1m BASE_URL=$BASE_URL \
k6 run ../grades_test.js \
--summary-export=../results/fastify_get_200vu.json \
| tee ../results/fastify_get_200vu.txt

echo "Test completed."