#!/usr/bin/env bash

# Test Makefile functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_makefile_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

echo "Testing Makefile functionality..."

# Test that Makefile exists
if [[ -f "/home/rana/Documents/Projects/curllm/Makefile" ]]; then
    echo "PASS: Makefile exists"
else
    echo "FAIL: Makefile is missing"
    exit 1
fi

# Test that Makefile contains expected targets
makefile_content=$(cat /home/rana/Documents/Projects/curllm/Makefile)

targets=("test" "install" "uninstall" "clean" "lint")

for target in "${targets[@]}"; do
    if echo "$makefile_content" | grep -q "\.PHONY: $target"; then
        echo "PASS: Makefile contains target $target"
    else
        echo "FAIL: Makefile is missing target $target"
        exit 1
    fi
done

echo "All Makefile tests passed!"