#!/bin/bash

source ../../express.env

mkdir -p ../results

echo "Running Express POST 100 VU Test..."

VUS=100 DURATION=1m BASE_URL=$BASE_URL \
k6 run ../registration_test.js \
--out json=../results/express_post_100vu.json \
> ../results/express_post_100vu.txt

echo "Test completed."