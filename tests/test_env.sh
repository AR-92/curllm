#!/usr/bin/env bash

# Test environment variable handling

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_env_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp bin/curllm "$TEST_DIR/bin/"
cp lib/*.sh "$TEST_DIR/lib/"
cp providers/*.sh "$TEST_DIR/providers/"

echo "Testing environment variable handling..."

# Test XDG_CONFIG_HOME
mkdir -p "$TEST_DIR/custom-config/curllm"
cat > "$TEST_DIR/custom-config/curllm/config" << 'EOF'
DEFAULT_PROVIDER=qwen
DEFAULT_MODEL=qwen-turbo
EOF

set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/custom-config" "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/env_test_xdg.txt 2>&1
exit_code=$?
output=$(cat /tmp/env_test_xdg.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: curllm works with custom XDG_CONFIG_HOME"
else
    echo "FAIL: curllm should work with custom XDG_CONFIG_HOME"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check that Qwen was used
if echo "$output" | grep -q "mock response from Qwen"; then
    echo "PASS: curllm correctly used Qwen with custom XDG_CONFIG_HOME"
else
    echo "FAIL: curllm did not correctly use Qwen with custom XDG_CONFIG_HOME"
    echo "Output: $output"
    exit 1
fi

echo "All environment variable tests passed!"