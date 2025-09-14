#!/usr/bin/env bash

# Test error handling

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_error_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp bin/curllm "$TEST_DIR/bin/"
cp lib/*.sh "$TEST_DIR/lib/"
cp providers/*.sh "$TEST_DIR/providers/"

echo "Testing error handling..."

# Test with non-existent provider
set +e
MOCK_MODE=true "$TEST_DIR/bin/curllm" chat --provider nonexistent "test prompt" > /tmp/error_test_nonexistent.txt 2>&1
exit_code=$?
output=$(cat /tmp/error_test_nonexistent.txt)
set -e

if [[ $exit_code -eq 1 ]]; then
    echo "PASS: curllm correctly fails with non-existent provider"
else
    echo "FAIL: curllm should fail with non-existent provider"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test with non-existent model (should still work in mock mode)
set +e
MOCK_MODE=true "$TEST_DIR/bin/curllm" chat --model nonexistent-model "test prompt" > /tmp/error_test_nonexistent_model.txt 2>&1
exit_code=$?
output=$(cat /tmp/error_test_nonexistent_model.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: curllm works with non-existent model in mock mode"
else
    echo "FAIL: curllm should work with non-existent model in mock mode"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test missing library files
rm -f "$TEST_DIR/lib/config.sh"

set +e
"$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/error_test_missing_lib.txt 2>&1
exit_code=$?
output=$(cat /tmp/error_test_missing_lib.txt)
set -e

if [[ $exit_code -eq 1 ]]; then
    echo "PASS: curllm correctly fails with missing library"
else
    echo "FAIL: curllm should fail with missing library"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

echo "All error handling tests passed!"