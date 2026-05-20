mkdir -p ../results

echo "Running fastify POST 10 VU Test..."

VUS=10 DURATION=1m \
k6 run ../registration_test.js \
--out json=../results/fastify_post_10vu.json \
> ../results/fastify_post_10vu.txt

echo "Test completed."