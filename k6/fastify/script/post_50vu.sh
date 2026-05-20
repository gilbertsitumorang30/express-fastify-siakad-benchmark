#!/bin/bash

source ../../fastify.env

mkdir -p ../results

echo "Running fastify POST 50 VU Test..."

VUS=50 DURATION=1m BASE_URL=$BASE_URL \
k6 run ../registration_test.js \
--summary-export=../results/fastify_post_50vu.json

echo "Test completed."