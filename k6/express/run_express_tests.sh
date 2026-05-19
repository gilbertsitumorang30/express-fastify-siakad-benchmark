#!/bin/bash

vusList=(10 50 100 250 500 1000)

for vus in "${vusList[@]}"
do
    echo ""
    echo "======================================="
    echo "EXPRESS GRADES TEST - $vus VUs"
    echo "======================================="

    k6 run \
        -e VUS=$vus \
        -e DURATION=30s \
        ./grades_test.js \
        --summary-export=./results/grades_${vus}_summary.json

    echo ""
    echo "======================================="
    echo "EXPRESS REGISTRATION TEST - $vus VUs"
    echo "======================================="

    k6 run \
        -e VUS=$vus \
        -e DURATION=30s \
        ./registration_test.js \
        --summary-export=./results/registration_${vus}_summary.json

done