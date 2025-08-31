#!/usr/bin/env bash

# Test integration scenarios

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_integration_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

echo "Testing integration scenarios..."

# Test complete workflow: config -> chat -> different provider -> chat
mkdir -p "$TEST_DIR/.config/curllm"

# Step 1: Use OpenAI as default
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
EOF

set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "first test prompt" > /tmp/integration_test_step1.txt 2>&1
exit_code=$?
output=$(cat /tmp/integration_test_step1.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: First chat with default OpenAI provider works"
else
    echo "FAIL: First chat with default OpenAI provider failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check that OpenAI was used
if echo "$output" | grep -q "mock response from OpenAI"; then
    echo "PASS: First chat correctly used OpenAI provider"
else
    echo "FAIL: First chat did not correctly use OpenAI provider"
    echo "Output: $output"
    exit 1
fi

# Step 2: Override with Qwen provider
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat --provider qwen "second test prompt" > /tmp/integration_test_step2.txt 2>&1
exit_code=$?
output=$(cat /tmp/integration_test_step2.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Second chat with Qwen provider override works"
else
    echo "FAIL: Second chat with Qwen provider override failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check that Qwen was used
if echo "$output" | grep -q "mock response from Qwen"; then
    echo "PASS: Second chat correctly used Qwen provider"
else
    echo "FAIL: Second chat did not correctly use Qwen provider"
    echo "Output: $output"
    exit 1
fi

# Step 3: Use default again (should be OpenAI)
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "third test prompt" > /tmp/integration_test_step3.txt 2>&1
exit_code=$?
output=$(cat /tmp/integration_test_step3.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Third chat with default provider works"
else
    echo "FAIL: Third chat with default provider failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check that OpenAI was used (default)
if echo "$output" | grep -q "mock response from OpenAI"; then
    echo "PASS: Third chat correctly used default OpenAI provider"
else
    echo "FAIL: Third chat did not correctly use default OpenAI provider"
    echo "Output: $output"
    exit 1
fi

echo "All integration scenario tests passed!"