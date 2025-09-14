#!/usr/bin/env bash

# Test Qwen provider functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_qwen_test"
mkdir -p "$TEST_DIR"

# Copy curllm, lib, and providers to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp bin/curllm "$TEST_DIR/bin/"
cp lib/*.sh "$TEST_DIR/lib/"
cp providers/*.sh "$TEST_DIR/providers/"

# Create a test config file
mkdir -p "$TEST_DIR/.config/curllm"
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# curllm configuration
DEFAULT_PROVIDER=qwen
DEFAULT_MODEL=qwen-turbo
EOF

# Test that Qwen provider functions exist
echo "Testing Qwen provider functionality..."

# Source the provider directly and test functions
source "$TEST_DIR/lib/config.sh"
source "$TEST_DIR/lib/security.sh"
source "$TEST_DIR/providers/qwen.sh"

# Test that the qwen_chat_completion function exists
if declare -f qwen_chat_completion >/dev/null; then
    echo "PASS: qwen_chat_completion function exists"
else
    echo "FAIL: qwen_chat_completion function not found"
    exit 1
fi

# Test mock mode for Qwen
export MOCK_MODE=true
response=$(qwen_chat_completion "test prompt")
if echo "$response" | grep -q "mock response from Qwen"; then
    echo "PASS: Qwen mock mode works correctly"
else
    echo "FAIL: Qwen mock mode not working correctly"
    exit 1
fi

echo "All Qwen provider tests passed!"