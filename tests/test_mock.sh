#!/usr/bin/env bash

# Test mock mode functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_mock_test"
mkdir -p "$TEST_DIR"

# Copy curllm, lib, and providers to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

# Create a test config file (no API key needed for mock mode)
mkdir -p "$TEST_DIR/.config/curllm"
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# curllm configuration
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
EOF

# Test that mock mode works
echo "Testing mock mode functionality..."

# Test that curllm works in mock mode without an API key
set +e
MOCK_MODE=true "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/mock_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/mock_output.txt)
set -e

echo "Exit code: $exit_code"
echo "Output: $output"

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: curllm executed successfully in mock mode"
else
    echo "FAIL: curllm failed in mock mode with exit code $exit_code"
    exit 1
fi

# Check if output contains mock response
if echo "$output" | grep -q "This is a mock response for prompt: test prompt"; then
    echo "PASS: Mock response returned correctly"
else
    echo "FAIL: Mock response not found in output"
    echo "Output: $output"
    exit 1
fi

echo "All mock mode tests passed!"