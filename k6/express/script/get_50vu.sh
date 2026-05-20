mkdir -p ../results

echo "Running Express GET 50 VU Test..."

VUS=50 DURATION=1m \
k6 run ../grades_test.js \
--out json=../results/express_get_50vu.json \
> ../results/express_get_50vu.txt

echo "Test completed."