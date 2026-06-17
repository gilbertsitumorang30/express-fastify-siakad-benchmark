#!/bin/bash

source ../../express.env

mkdir -p ../results

echo "Running Express POST 100 VU Test..."

VUS=100 DURATION=3m BASE_URL=$BASE_URL \
k6 run ../registration_test.js \
--summary-export="../results/express_post_100vu_${RUN}.json"

echo "Test completed."