#!/usr/bin/env bash

# Test chat functionality edge cases

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_chat_edge_test"
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

echo "Testing chat functionality edge cases..."

# Test chat with multi-line prompt
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "This is a multi-line prompt.
It spans multiple lines.
This is the third line." > /tmp/chat_edge_test_multiline.txt 2>&1
exit_code=$?
output=$(cat /tmp/chat_edge_test_multiline.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: curllm works with multi-line prompt"
else
    echo "FAIL: curllm should work with multi-line prompt"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test chat with special characters
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "Prompt with special characters: !@#$%^&*()_+-=[]{}|;':\",./<>?" > /tmp/chat_edge_test_special.txt 2>&1
exit_code=$?
output=$(cat /tmp/chat_edge_test_special.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: curllm works with special characters in prompt"
else
    echo "FAIL: curllm should work with special characters in prompt"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test chat with very long prompt
long_prompt=$(printf 'A%.0s' {1..1000})
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "$long_prompt" > /tmp/chat_edge_test_long.txt 2>&1
exit_code=$?
output=$(cat /tmp/chat_edge_test_long.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: curllm works with very long prompt"
else
    echo "FAIL: curllm should work with very long prompt"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

echo "All chat functionality edge case tests passed!"