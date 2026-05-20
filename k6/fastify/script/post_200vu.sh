#!/bin/bash

source ../../fastify.env

mkdir -p ../results

echo "Running fastify POST 200 VU Test..."

VUS=200 DURATION=1m BASE_URL=$BASE_URL \
k6 run ../registration_test.js \
--out json=../results/fastify_post_200vu.json \
> ../results/fastify_post_200vu.txt

echo "Test completed."