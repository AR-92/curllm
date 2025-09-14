#!/usr/bin/env bash

# Test compatibility with different environments

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_compat_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp bin/curllm "$TEST_DIR/bin/"
cp lib/*.sh "$TEST_DIR/lib/"
cp providers/*.sh "$TEST_DIR/providers/"

echo "Testing compatibility with different environments..."

# Test with different shell options
set +e
MOCK_MODE=true bash -e "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/compat_test_bash_e.txt 2>&1
exit_code=$?
output=$(cat /tmp/compat_test_bash_e.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: curllm works with bash -e"
else
    echo "FAIL: curllm should work with bash -e"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test with different locales
set +e
MOCK_MODE=true LANG=C "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/compat_test_lang_c.txt 2>&1
exit_code=$?
output=$(cat /tmp/compat_test_lang_c.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: curllm works with LANG=C"
else
    echo "FAIL: curllm should work with LANG=C"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

echo "All compatibility tests passed!"