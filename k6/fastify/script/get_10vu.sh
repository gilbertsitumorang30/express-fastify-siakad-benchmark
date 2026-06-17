#!/bin/bash

RUN=$1

source ../../fastify.env

mkdir -p ../results

echo "Running fastify GET 10 VU Test..."

VUS=10 DURATION=3m BASE_URL=$BASE_URL \
k6 run ../grades_test.js \
--summary-export="../results/fastify_get_10vu_${RUN}.json"

echo "Test completed."