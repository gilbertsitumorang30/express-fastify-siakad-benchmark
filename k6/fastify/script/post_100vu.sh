mkdir -p ../results

echo "Running fastify POST 100 VU Test..."

VUS=100 DURATION=1m \
k6 run ../registration_test.js \
--out json=../results/fastify_post_100vu.json \
> ../results/fastify_post_100vu.txt

echo "Test completed."