#!/usr/bin/env bash

# Test utility functions

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_utils_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp bin/curllm "$TEST_DIR/bin/"
cp lib/*.sh "$TEST_DIR/lib/"
cp providers/*.sh "$TEST_DIR/providers/"

echo "Testing utility functions..."

# Test help function directly
source "$TEST_DIR/lib/utils.sh"

set +e
show_help > /tmp/utils_test_help.txt 2>&1
exit_code=$?
output=$(cat /tmp/utils_test_help.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: show_help function works"
else
    echo "FAIL: show_help function failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check that help output contains expected content
if echo "$output" | grep -q "curllm - A pure Bash LLM API wrapper"; then
    echo "PASS: show_help output contains expected header"
else
    echo "FAIL: show_help output does not contain expected header"
    echo "Output: $output"
    exit 1
fi

# Test version function directly
set +e
show_version > /tmp/utils_test_version.txt 2>&1
exit_code=$?
output=$(cat /tmp/utils_test_version.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: show_version function works"
else
    echo "FAIL: show_version function failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check that version output contains expected content
if echo "$output" | grep -q "curllm v0.1.0"; then
    echo "PASS: show_version output contains expected version"
else
    echo "FAIL: show_version output does not contain expected version"
    echo "Output: $output"
    exit 1
fi

echo "All utility function tests passed!"