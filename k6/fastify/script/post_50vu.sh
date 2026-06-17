#!/bin/bash

RUN=$1

source ../../fastify.env

mkdir -p ../results

echo "Running fastify POST 50 VU Test..."

VUS=50 DURATION=3m BASE_URL=$BASE_URL \
k6 run ../registration_test.js \
--summary-export="../results/fastify_post_50vu_${RUN}.json"

echo "Test completed."