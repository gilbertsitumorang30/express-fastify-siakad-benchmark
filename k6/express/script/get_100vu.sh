#!/bin/bash

source ../../express.env

mkdir -p ../results

echo "Running Express GET 100 VU Test..."

VUS=100 DURATION=1m BASE_URL=$BASE_URL \
k6 run ../grades_test.js \
--summary-export=../results/express_get_100vu.json \
| tee ../results/express_get_100vu.txt

echo "Test completed."