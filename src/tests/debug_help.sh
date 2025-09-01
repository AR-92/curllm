#!/usr/bin/env bash

# Test help functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_help_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

echo "Testing help functionality..."

# Test basic help
echo "=== Testing basic help ==="
set +e
output=$("$TEST_DIR/bin/curllm" help 2>&1)
exit_code=$?
set -e

echo "Exit code: $exit_code"
echo "Output:"
echo "$output"
echo ""

# Test help with verbose flag
echo "=== Testing help --verbose ==="
set +e
output=$("$TEST_DIR/bin/curllm" help --verbose 2>&1)
exit_code=$?
set -e

echo "Exit code: $exit_code"
echo "Output:"
echo "$output"
echo ""