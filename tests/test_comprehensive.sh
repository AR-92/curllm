#!/usr/bin/env bash

# Test comprehensive functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_comprehensive_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp bin/curllm "$TEST_DIR/bin/"
cp lib/*.sh "$TEST_DIR/lib/"
cp providers/*.sh "$TEST_DIR/providers/"

# Create a test config file
mkdir -p "$TEST_DIR/.config/curllm"
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# curllm configuration
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
EOF

# Test comprehensive functionality
echo "Testing comprehensive functionality..."

# Test basic chat with default provider
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/comprehensive_test_output1.txt 2>&1
exit_code=$?
output=$(cat /tmp/comprehensive_test_output1.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Basic chat with default provider executed successfully"
else
    echo "FAIL: Basic chat with default provider failed with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test chat with command-line provider override
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat --provider qwen "test prompt" > /tmp/comprehensive_test_output2.txt 2>&1
exit_code=$?
output=$(cat /tmp/comprehensive_test_output2.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Chat with command-line provider override executed successfully"
else
    echo "FAIL: Chat with command-line provider override failed with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test help command
set +e
"$TEST_DIR/bin/curllm" help > /tmp/comprehensive_test_output3.txt 2>&1
exit_code=$?
output=$(cat /tmp/comprehensive_test_output3.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Help command executed successfully"
else
    echo "FAIL: Help command failed with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test version command
set +e
"$TEST_DIR/bin/curllm" version > /tmp/comprehensive_test_output4.txt 2>&1
exit_code=$?
output=$(cat /tmp/comprehensive_test_output4.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Version command executed successfully"
else
    echo "FAIL: Version command failed with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test no arguments (should show help)
set +e
"$TEST_DIR/bin/curllm" > /tmp/comprehensive_test_output5.txt 2>&1
exit_code=$?
output=$(cat /tmp/comprehensive_test_output5.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: No arguments correctly showed help"
else
    echo "FAIL: No arguments should have shown help with exit code 0"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

echo "All comprehensive functionality tests passed!"