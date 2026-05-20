#!/bin/bash

source ../../fastify.env

mkdir -p ../results

echo "Running fastify POST 200 VU Test..."

VUS=200 DURATION=1m BASE_URL=$BASE_URL \
k6 run ../registration_test.js \
--summary-export=../results/fastify_post_200vu.json
echo "Test completed."