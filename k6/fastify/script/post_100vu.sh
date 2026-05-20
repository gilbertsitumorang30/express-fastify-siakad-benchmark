#!/bin/bash

source ../../fastify.env

mkdir -p ../results

echo "Running fastify POST 100 VU Test..."

VUS=100 DURATION=1m BASE_URL=$BASE_URL \
k6 run ../registration_test.js \
--out json=../results/fastify_post_100vu.json \
> ../results/fastify_post_100vu.txt

echo "Test completed."