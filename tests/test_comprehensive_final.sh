#!/usr/bin/env bash

# Test comprehensive functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_comprehensive_final_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

echo "Testing comprehensive functionality..."

# Test all major features in one go
# 1. Help system
set +e
"$TEST_DIR/bin/curllm" --help > /tmp/comprehensive_final_test_help.txt 2>&1
exit_code=$?
output=$(cat /tmp/comprehensive_final_test_help.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Help system works"
else
    echo "FAIL: Help system failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# 2. Version system
set +e
"$TEST_DIR/bin/curllm" --version > /tmp/comprehensive_final_test_version.txt 2>&1
exit_code=$?
output=$(cat /tmp/comprehensive_final_test_version.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Version system works"
else
    echo "FAIL: Version system failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# 3. Chat with mock mode
set +e
MOCK_MODE=true "$TEST_DIR/bin/curllm" chat "comprehensive test prompt" > /tmp/comprehensive_final_test_chat.txt 2>&1
exit_code=$?
output=$(cat /tmp/comprehensive_final_test_chat.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Chat with mock mode works"
else
    echo "FAIL: Chat with mock mode failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# 4. Provider override
set +e
MOCK_MODE=true "$TEST_DIR/bin/curllm" chat --provider qwen "provider override test" > /tmp/comprehensive_final_test_provider.txt 2>&1
exit_code=$?
output=$(cat /tmp/comprehensive_final_test_provider.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Provider override works"
else
    echo "FAIL: Provider override failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# 5. Model override
set +e
MOCK_MODE=true "$TEST_DIR/bin/curllm" chat --model test-model "model override test" > /tmp/comprehensive_final_test_model.txt 2>&1
exit_code=$?
output=$(cat /tmp/comprehensive_final_test_model.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Model override works"
else
    echo "FAIL: Model override failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

echo "All comprehensive functionality tests passed!"