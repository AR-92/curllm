#!/usr/bin/env bash

# Test version functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_version_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

# Test version command
echo "Testing version functionality..."

# Test version command
set +e
output=$("$TEST_DIR/bin/curllm" version 2>&1)
exit_code=$?
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: version command executed successfully"
else
    echo "FAIL: version command failed with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check if output contains expected version text
if echo "$output" | grep -q "curllm v0.1.0"; then
    echo "PASS: Output contains expected version"
else
    echo "FAIL: Output does not contain expected version"
    echo "Output: $output"
    exit 1
fi

# Test --version flag
set +e
output=$("$TEST_DIR/bin/curllm" --version 2>&1)
exit_code=$?
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: --version flag executed successfully"
else
    echo "FAIL: --version flag failed with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test -v flag
set +e
output=$("$TEST_DIR/bin/curllm" -v 2>&1)
exit_code=$?
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: -v flag executed successfully"
else
    echo "FAIL: -v flag failed with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

echo "All version functionality tests passed!"