#!/usr/bin/env bash

# Test command-line argument parsing

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_args_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

# Create a test config file
mkdir -p "$TEST_DIR/.config/curllm"
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# curllm configuration
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
EOF

# Test command-line argument parsing
echo "Testing command-line argument parsing..."

# Test --provider option
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat --provider qwen "test prompt" > /tmp/args_test_output1.txt 2>&1
exit_code=$?
output=$(cat /tmp/args_test_output1.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: --provider option executed successfully"
else
    echo "FAIL: --provider option failed with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check that the response came from Qwen
if echo "$output" | grep -q "mock response from Qwen"; then
    echo "PASS: --provider option correctly used Qwen provider"
else
    echo "FAIL: --provider option did not correctly use Qwen provider"
    echo "Output: $output"
    exit 1
fi

# Test --model option
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat --model gpt-4 "test prompt" > /tmp/args_test_output2.txt 2>&1
exit_code=$?
output=$(cat /tmp/args_test_output2.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: --model option executed successfully"
else
    echo "FAIL: --model option failed with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test combined --provider and --model options
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat --provider anthropic --model claude-2 "test prompt" > /tmp/args_test_output3.txt 2>&1
exit_code=$?
output=$(cat /tmp/args_test_output3.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Combined --provider and --model options executed successfully"
else
    echo "FAIL: Combined --provider and --model options failed with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check that the response came from Anthropic
if echo "$output" | grep -q "mock response from Anthropic"; then
    echo "PASS: Combined --provider and --model options correctly used Anthropic provider"
else
    echo "FAIL: Combined --provider and --model options did not correctly use Anthropic provider"
    echo "Output: $output"
    exit 1
fi

# Test missing value for --provider
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat --provider > /tmp/args_test_output4.txt 2>&1
exit_code=$?
output=$(cat /tmp/args_test_output4.txt)
set -e

if [[ $exit_code -eq 1 ]]; then
    echo "PASS: Missing value for --provider correctly failed"
else
    echo "FAIL: Missing value for --provider should have failed with exit code 1"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test missing value for --model
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat --model > /tmp/args_test_output5.txt 2>&1
exit_code=$?
output=$(cat /tmp/args_test_output5.txt)
set -e

if [[ $exit_code -eq 1 ]]; then
    echo "PASS: Missing value for --model correctly failed"
else
    echo "FAIL: Missing value for --model should have failed with exit code 1"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

echo "All command-line argument parsing tests passed!"