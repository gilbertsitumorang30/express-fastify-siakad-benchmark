#!/bin/bash

source ../../fastify.env

mkdir -p ../results

echo "Running fastify POST 100 VU Test..."

VUS=100 DURATION=1m BASE_URL=$BASE_URL \
k6 run ../registration_test.js \
--summary-export=../results/fastify_post_100vu.json \
| tee ../results/fastify_post_100vu.txt

echo "Test completed."