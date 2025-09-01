#!/usr/bin/env bash

# Test security edge cases

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_security_edge_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

echo "Testing security edge cases..."

# Test with non-existent config file
mkdir -p "$TEST_DIR/.config/curllm"
rm -f "$TEST_DIR/.config/curllm/config"

set +e
XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/security_edge_test_no_config.txt 2>&1
exit_code=$?
output=$(cat /tmp/security_edge_test_no_config.txt)
set -e

# Should fail because no API key is available
if [[ $exit_code -eq 1 ]]; then
    echo "PASS: curllm correctly fails with no config file and no MOCK_MODE"
else
    echo "FAIL: curllm should fail with no config file and no MOCK_MODE"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test with config file but no API keys
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# Config file with no API keys
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
EOF

set +e
XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/security_edge_test_no_keys.txt 2>&1
exit_code=$?
output=$(cat /tmp/security_edge_test_no_keys.txt)
set -e

# Should fail because no API key is available
if [[ $exit_code -eq 1 ]]; then
    echo "PASS: curllm correctly fails with config file but no API keys"
else
    echo "FAIL: curllm should fail with config file but no API keys"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

echo "All security edge case tests passed!"