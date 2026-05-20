#!/bin/bash

source ../../express.env

mkdir -p ../results

echo "Running Express GET 50 VU Test..."

VUS=50 DURATION=1m BASE_URL=$BASE_URL \
k6 run ../grades_test.js \
--summary-export=../results/express_get_50vu.json \
--no-progress | tee ../results/express_get_50vu.txt

echo "Test completed."