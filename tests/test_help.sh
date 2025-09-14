#!/usr/bin/env bash

# Test help functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_help_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp bin/curllm "$TEST_DIR/bin/"
cp lib/*.sh "$TEST_DIR/lib/"
cp providers/*.sh "$TEST_DIR/providers/"

# Test help command
echo "Testing help functionality..."

# Test help command
set +e
output=$("$TEST_DIR/bin/curllm" help 2>&1)
exit_code=$?
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: help command executed successfully"
else
    echo "FAIL: help command failed with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check if output contains expected help text
if echo "$output" | grep -q "curllm - A pure Bash LLM API wrapper"; then
    echo "PASS: Output contains expected help header"
else
    echo "FAIL: Output does not contain expected help header"
    echo "Output: $output"
    exit 1
fi

if echo "$output" | grep -q "Commands:"; then
    echo "PASS: Output contains commands section"
else
    echo "FAIL: Output does not contain commands section"
    echo "Output: $output"
    exit 1
fi

if echo "$output" | grep -q "chat <prompt>"; then
    echo "PASS: Output contains chat command description"
else
    echo "FAIL: Output does not contain chat command description"
    echo "Output: $output"
    exit 1
fi

# Test --help flag
set +e
output=$("$TEST_DIR/bin/curllm" --help 2>&1)
exit_code=$?
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: --help flag executed successfully"
else
    echo "FAIL: --help flag failed with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test -h flag
set +e
output=$("$TEST_DIR/bin/curllm" -h 2>&1)
exit_code=$?
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: -h flag executed successfully"
else
    echo "FAIL: -h flag failed with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

echo "All help functionality tests passed!"