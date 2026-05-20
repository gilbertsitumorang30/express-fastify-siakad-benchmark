mkdir -p ../results

echo "Running fastify GET 200 VU Test..."

VUS=200 DURATION=1m \
k6 run ../grades_test.js \
--out json=../results/fastify_get_200vu.json \
> ../results/fastify_get_200vu.txt

echo "Test completed."