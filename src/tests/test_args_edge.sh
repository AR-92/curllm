#!/usr/bin/env bash

# Test argument parsing edge cases

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_args_edge_test"
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

echo "Testing argument parsing edge cases..."

# Test with unknown command
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" unknown-command "test prompt" > /tmp/args_edge_test_unknown.txt 2>&1
exit_code=$?
output=$(cat /tmp/args_edge_test_unknown.txt)
set -e

if [[ $exit_code -eq 1 ]]; then
    echo "PASS: curllm correctly fails with unknown command"
else
    echo "FAIL: curllm should fail with unknown command"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test with unknown option
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat --unknown-option "test prompt" > /tmp/args_edge_test_unknown_option.txt 2>&1
exit_code=$?
output=$(cat /tmp/args_edge_test_unknown_option.txt)
set -e

if [[ $exit_code -eq 1 ]]; then
    echo "PASS: curllm correctly fails with unknown option"
else
    echo "FAIL: curllm should fail with unknown option"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test with multiple providers (should use the last one)
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat --provider qwen --provider anthropic "test prompt" > /tmp/args_edge_test_multiple_providers.txt 2>&1
exit_code=$?
output=$(cat /tmp/args_edge_test_multiple_providers.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: curllm works with multiple providers (uses last one)"
else
    echo "FAIL: curllm should work with multiple providers"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check that Anthropic was used (last provider)
if echo "$output" | grep -q "mock response from Anthropic"; then
    echo "PASS: curllm correctly used the last provider in multiple provider specification"
else
    echo "FAIL: curllm should use the last provider in multiple provider specification"
    echo "Output: $output"
    exit 1
fi

echo "All argument parsing edge case tests passed!"