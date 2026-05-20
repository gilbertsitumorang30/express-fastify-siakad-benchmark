#!/bin/bash

source ../../fastify.env

mkdir -p ../results

echo "Running fastify GET 10 VU Test..."

VUS=10 DURATION=1m BASE_URL=$BASE_URL \
k6 run ../grades_test.js \
--out json=../results/fastify_get_10vu.json \
> ../results/fastify_get_10vu.txt

echo "Test completed."