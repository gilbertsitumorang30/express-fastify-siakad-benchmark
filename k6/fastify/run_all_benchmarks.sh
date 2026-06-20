#!/bin/bash

CSV_FILE="./benchmark_log.csv"

echo "========================================="
echo "EXPRESS BENCHMARK"
echo "========================================="

#
# Load Environment
#
source ../express.env

#
# Warm Up
#
echo ""
echo "========================================="
echo "WARM-UP 30 DETIK"
echo "========================================="

VUS=5 DURATION=30s BASE_URL=$BASE_URL \
k6 run ./grades_test.js > /dev/null 2>&1

echo "Warm-up selesai"
echo "Menunggu 30 detik..."
sleep 30

run_scenario() {

    ENDPOINT=$1
    VU=$2
    SCRIPT=$3

    echo ""
    echo "========================================="
    echo "$ENDPOINT - $VU VU"
    echo "========================================="

    for RUN in 1 2 3
    do

        echo ""
        echo "RUN $RUN"

        START=$(date '+%F %T')

        (
            cd script
            ./$SCRIPT $RUN
        )

        STATUS=$?

        if [ $STATUS -ne 0 ]; then
            echo ""
            echo "Benchmark gagal"
            echo "Endpoint : $ENDPOINT"
            echo "VU       : $VU"
            echo "Run      : $RUN"
            exit 1
        fi

        END=$(date '+%F %T')

        echo "Express,$ENDPOINT,$VU,$RUN,$START,$END" >> "$CSV_FILE"

        echo "Start : $START"
        echo "End   : $END"

        #
        # Cooldown antar run
        #
        if [ "$RUN" -lt 3 ]; then
            echo ""
            echo "Cooling down antar run (60 detik)..."
            sleep 60
        fi

    done

    #
    # Cooldown antar skenario
    #
    echo ""
    echo "Cooling down antar skenario (120 detik)..."
    sleep 120
}

#
# GET TEST
#
run_scenario GET_GRADES 10 get_10vu.sh
run_scenario GET_GRADES 50 get_50vu.sh
run_scenario GET_GRADES 100 get_100vu.sh
run_scenario GET_GRADES 200 get_200vu.sh

#
# POST TEST
#
run_scenario POST_REGISTRATION 10 post_10vu.sh
run_scenario POST_REGISTRATION 50 post_50vu.sh
run_scenario POST_REGISTRATION 100 post_100vu.sh
run_scenario POST_REGISTRATION 200 post_200vu.sh

echo ""
echo "========================================="
echo "SEMUA BENCHMARK SELESAI"
echo "========================================="