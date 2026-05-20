mkdir -p ../results

echo "Running Express POST 50 VU Test..."

VUS=50 DURATION=1m \
k6 run ../registration_test.js \
--out json=../results/express_post_50vu.json \
> ../results/express_post_50vu.txt

echo "Test completed."