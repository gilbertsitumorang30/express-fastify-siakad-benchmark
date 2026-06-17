#!/bin/bash

RUN=$1

source ../../express.env

mkdir -p ../results

echo "Running Express POST 50 VU Test..."

VUS=50 DURATION=3m BASE_URL=$BASE_URL \
k6 run ../registration_test.js \
--summary-export="../results/express_post_50vu_${RUN}.json"

echo "Test completed."