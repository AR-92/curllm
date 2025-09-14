#!/usr/bin/env bash

# Test regression scenarios

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_regression_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp bin/curllm "$TEST_DIR/bin/"
cp lib/*.sh "$TEST_DIR/lib/"
cp providers/*.sh "$TEST_DIR/providers/"

echo "Testing regression scenarios..."

# Test that previously fixed bugs don't reappear
# Bug 1: Help command should work without config file
set +e
"$TEST_DIR/bin/curllm" help > /tmp/regression_test_help_no_config.txt 2>&1
exit_code=$?
output=$(cat /tmp/regression_test_help_no_config.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Help command works without config file"
else
    echo "FAIL: Help command should work without config file"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Bug 2: Version command should work without config file
set +e
"$TEST_DIR/bin/curllm" version > /tmp/regression_test_version_no_config.txt 2>&1
exit_code=$?
output=$(cat /tmp/regression_test_version_no_config.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Version command works without config file"
else
    echo "FAIL: Version command should work without config file"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Bug 3: No arguments should show help, not error
set +e
"$TEST_DIR/bin/curllm" > /tmp/regression_test_no_args.txt 2>&1
exit_code=$?
output=$(cat /tmp/regression_test_no_args.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: No arguments shows help"
else
    echo "FAIL: No arguments should show help"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

echo "All regression tests passed!"