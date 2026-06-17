#!/bin/bash

source ../../fastify.env

mkdir -p ../results

echo "Running fastify POST 10 VU Test..."

VUS=10 DURATION=3m BASE_URL=$BASE_URL \
k6 run ../registration_test.js \
--summary-export="../results/fastify_post_10vu_${RUN}.json"

echo "Test completed."