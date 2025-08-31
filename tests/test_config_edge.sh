#!/usr/bin/env bash

# Test configuration edge cases

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_config_edge_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

echo "Testing configuration edge cases..."

# Test with empty config file
mkdir -p "$TEST_DIR/.config/curllm"
touch "$TEST_DIR/.config/curllm/config"

set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/config_edge_test_empty.txt 2>&1
exit_code=$?
output=$(cat /tmp/config_edge_test_empty.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: curllm works with empty config file"
else
    echo "FAIL: curllm should work with empty config file"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test with malformed config file
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# This is a malformed config file
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
INVALID_LINE
KEY_WITHOUT_VALUE=
=VALUE_WITHOUT_KEY
EOF

set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/config_edge_test_malformed.txt 2>&1
exit_code=$?
output=$(cat /tmp/config_edge_test_malformed.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: curllm works with malformed config file"
else
    echo "FAIL: curllm should work with malformed config file"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test with config file containing spaces
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
  DEFAULT_PROVIDER  =  openai  
  DEFAULT_MODEL  =  gpt-3.5-turbo  
EOF

set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/config_edge_test_spaces.txt 2>&1
exit_code=$?
output=$(cat /tmp/config_edge_test_spaces.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: curllm works with config file containing spaces"
else
    echo "FAIL: curllm should work with config file containing spaces"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

echo "All configuration edge case tests passed!"