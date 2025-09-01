#!/usr/bin/env bash

# Simple test for mock mode

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_simple_mock_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

# Create a test config file (no API key needed for mock mode)
mkdir -p "$TEST_DIR/.config/curllm"
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# curllm configuration
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
EOF

# Test that mock mode works by directly sourcing and testing
echo "Testing mock mode directly..."

# Source the provider directly and test functions
source "$TEST_DIR/lib/config.sh"
source "$TEST_DIR/lib/security.sh"
source "$TEST_DIR/providers/openai.sh"

export XDG_CONFIG_HOME="$TEST_DIR/.config"

# Load config
load_config

# Test mock mode
export MOCK_MODE=true
echo "MOCK_MODE is set to: ${MOCK_MODE:-unset}"

# Test the openai_chat_completion function in mock mode
response=$(openai_chat_completion "test prompt")
exit_code=$?

echo "Exit code: $exit_code"
echo "Response: $response"

if [[ $exit_code -eq 0 ]] && echo "$response" | grep -q "mock response"; then
    echo "PASS: Mock mode works correctly"
else
    echo "FAIL: Mock mode not working correctly"
    exit 1
fi

echo "All direct mock mode tests passed!"