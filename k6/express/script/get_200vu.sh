#!/bin/bash

source ../../express.env

mkdir -p ../results

echo "Running Express GET 200 VU Test..."

VUS=200 DURATION=1m BASE_URL=$BASE_URL \
k6 run ../grades_test.js \
--out json=../results/express_get_200vu.json \
> ../results/express_get_200vu.txt

echo "Test completed."