#!/bin/bash

RUN=$1

source ../../express.env

mkdir -p ../results

echo "Running Express GET 10 VU Test..."

VUS=10 DURATION=3m BASE_URL=$BASE_URL \
k6 run ../grades_test.js \
--summary-export="../results/express_get_10vu_${RUN}.json"

echo "Test completed."