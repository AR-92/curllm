#!/usr/bin/env bash

# Test performance and stress

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_perf_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

# Create a test config file
mkdir -p "$TEST_DIR/.config/curllm"
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# curllm configuration
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
EOF

echo "Testing performance and stress..."

# Test multiple rapid invocations
start_time=$(date +%s)
for i in {1..10}; do
    set +e
    MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "test prompt $i" > "/tmp/perf_test_$i.txt" 2>&1
    exit_code=$?
    set -e
    
    if [[ $exit_code -ne 0 ]]; then
        echo "FAIL: curllm failed on iteration $i"
        exit 1
    fi
done
end_time=$(date +%s)

duration=$((end_time - start_time))
echo "PASS: 10 rapid invocations completed in ${duration} seconds"

# Test with very large prompt
large_prompt=$(printf 'A%.0s' {1..5000})
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" time "$TEST_DIR/bin/curllm" chat "$large_prompt" > /tmp/perf_test_large.txt 2>&1
exit_code=$?
output=$(cat /tmp/perf_test_large.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: curllm handles very large prompt"
else
    echo "FAIL: curllm should handle very large prompt"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

echo "All performance and stress tests passed!"