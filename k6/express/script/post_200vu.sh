#!/bin/bash

source ../../express.env

mkdir -p ../results

echo "Running Express POST 200 VU Test..."

VUS=200 DURATION=1m BASE_URL=$BASE_URL \
k6 run ../registration_test.js \
--out json=../results/express_post_200vu.json \
> ../results/express_post_200vu.txt

echo "Test completed."