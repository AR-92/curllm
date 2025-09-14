#!/usr/bin/env bash

# Test OpenRouter provider functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_openrouter_test"
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
DEFAULT_PROVIDER=openrouter
DEFAULT_MODEL=openrouter/auto
EOF

# Test that OpenRouter provider functions exist
echo "Testing OpenRouter provider functionality..."

# Source the provider directly and test functions
source "$TEST_DIR/lib/config.sh"
source "$TEST_DIR/lib/security.sh"
source "$TEST_DIR/providers/openrouter.sh"

# Test that the openrouter_chat_completion function exists
if declare -f openrouter_chat_completion >/dev/null; then
    echo "PASS: openrouter_chat_completion function exists"
else
    echo "FAIL: openrouter_chat_completion function not found"
    exit 1
fi

# Test mock mode for OpenRouter
export MOCK_MODE=true
response=$(openrouter_chat_completion "test prompt")
if echo "$response" | grep -q "mock response from OpenRouter"; then
    echo "PASS: OpenRouter mock mode works correctly"
else
    echo "FAIL: OpenRouter mock mode not working correctly"
    exit 1
fi

# Test OpenRouter through the main curllm script
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/openrouter_test_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/openrouter_test_output.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: OpenRouter provider works through main curllm script"
else
    echo "FAIL: OpenRouter provider failed through main curllm script"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check that the response came from OpenRouter
if echo "$output" | grep -q "mock response from OpenRouter"; then
    echo "PASS: OpenRouter provider correctly used in main script"
else
    echo "FAIL: OpenRouter provider not correctly used in main script"
    echo "Output: $output"
    exit 1
fi

echo "All OpenRouter provider tests passed!"