mkdir -p ../results

echo "Running fastify GET 100 VU Test..."

VUS=100 DURATION=1m \
k6 run ../grades_test.js \
--out json=../results/fastify_get_100vu.json \
> ../results/fastify_get_100vu.txt

echo "Test completed."