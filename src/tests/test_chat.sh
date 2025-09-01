#!/usr/bin/env bash

# Test chat command functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_chat_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

# Test chat command with a prompt
echo "Testing chat command..."

# Test with no arguments (should show usage)
set +e
output=$("$TEST_DIR/bin/curllm" chat 2>&1)
exit_code=$?
set -e

if [[ $exit_code -eq 1 ]] && echo "$output" | grep -q "Error: No prompt provided"; then
    echo "PASS: chat command with no prompt shows error"
else
    echo "FAIL: chat command with no prompt should show error"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test with a prompt argument (in mock mode)
set +e
MOCK_MODE=true "$TEST_DIR/bin/curllm" chat "Hello, world!" > /tmp/chat_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/chat_output.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: chat command with prompt executes successfully in mock mode"
else
    echo "FAIL: chat command with prompt should execute successfully in mock mode"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

echo "All chat command tests passed!"