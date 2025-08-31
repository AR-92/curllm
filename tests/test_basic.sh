#!/usr/bin/env bash

# Test basic curllm functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

# Run basic test
echo "Testing basic curllm execution..."

set +e
output=$("$TEST_DIR/bin/curllm" 2>&1)
exit_code=$?
set -e

echo "Exit code: $exit_code"
echo "Output: $output"

# When no arguments are provided, it should show help and exit with code 0
if [[ $exit_code -eq 0 ]]; then
    echo "PASS: curllm correctly exits with code 0 when no arguments provided"
else
    echo "FAIL: curllm should exit with code 0 when no arguments provided"
    exit 1
fi

# Check if output contains expected strings
if echo "$output" | grep -q "curllm - A pure Bash LLM API wrapper"; then
    echo "PASS: Output contains expected header"
else
    echo "FAIL: Output does not contain expected header"
    echo "Output: $output"
    exit 1
fi

if echo "$output" | grep -q "Usage:"; then
    echo "PASS: Output contains expected usage"
else
    echo "FAIL: Output does not contain expected usage"
    exit 1
fi

echo "All basic tests passed!"