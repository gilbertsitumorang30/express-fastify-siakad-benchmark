#!/bin/bash

source ../../express.env

mkdir -p ../results

echo "Running Express GET 10 VU Test..."

VUS=10 DURATION=1m BASE_URL=$BASE_URL \
k6 run ../grades_test.js \
--summary-export=../results/express_get_10vu.json \
--no-progress | tee ../results/express_get_10vu.txt

echo "Test completed."