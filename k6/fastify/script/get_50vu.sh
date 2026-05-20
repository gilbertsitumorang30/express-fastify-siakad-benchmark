mkdir -p ../results

echo "Running fastify GET 50 VU Test..."

VUS=50 DURATION=1m \
k6 run ../grades_test.js \
--out json=../results/fastify_get_50vu.json \
> ../results/fastify_get_50vu.txt

echo "Test completed."