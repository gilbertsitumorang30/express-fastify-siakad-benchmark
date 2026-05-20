mkdir -p ../results

echo "Running Express POST 10 VU Test..."

VUS=10 DURATION=1m \
k6 run ../registration_test.js \
--out json=../results/express_post_10vu.json \
> ../results/express_post_10vu.txt

echo "Test completed."