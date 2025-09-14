#!/usr/bin/env bash

# Debug argument parsing

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_debug_args"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp bin/curllm "$TEST_DIR/bin/"
cp lib/*.sh "$TEST_DIR/lib/"
cp providers/*.sh "$TEST_DIR/providers/"

echo "Debugging argument parsing..."

# Test different argument combinations
echo "=== Testing 'help' command ==="
set +e
"$TEST_DIR/bin/curllm" help > /tmp/debug_help.txt 2>&1
exit_code=$?
set -e
echo "Exit code: $exit_code"
echo "Output:"
cat /tmp/debug_help.txt
echo ""

echo "=== Testing '--help' flag ==="
set +e
"$TEST_DIR/bin/curllm" --help > /tmp/debug_help_flag.txt 2>&1
exit_code=$?
set -e
echo "Exit code: $exit_code"
echo "Output:"
cat /tmp/debug_help_flag.txt
echo ""