#!/usr/bin/env bash

# Test Anthropic provider functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_anthropic_test"
mkdir -p "$TEST_DIR"

# Copy curllm, lib, and providers to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

# Create a test config file
mkdir -p "$TEST_DIR/.config/curllm"
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# curllm configuration
DEFAULT_PROVIDER=anthropic
DEFAULT_MODEL=claude-2
EOF

# Test that Anthropic provider functions exist
echo "Testing Anthropic provider functionality..."

# Source the provider directly and test functions
source "$TEST_DIR/lib/config.sh"
source "$TEST_DIR/lib/security.sh"
source "$TEST_DIR/providers/anthropic.sh"

# Test that the anthropic_chat_completion function exists
if declare -f anthropic_chat_completion >/dev/null; then
    echo "PASS: anthropic_chat_completion function exists"
else
    echo "FAIL: anthropic_chat_completion function not found"
    exit 1
fi

# Test mock mode for Anthropic
export MOCK_MODE=true
response=$(anthropic_chat_completion "test prompt")
if echo "$response" | grep -q "mock response from Anthropic"; then
    echo "PASS: Anthropic mock mode works correctly"
else
    echo "FAIL: Anthropic mock mode not working correctly"
    exit 1
fi

echo "All Anthropic provider tests passed!"