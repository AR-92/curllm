#!/usr/bin/env bash

# Test Mistral provider functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_mistral_test"
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
DEFAULT_PROVIDER=mistral
DEFAULT_MODEL=mistral-tiny
EOF

# Test that Mistral provider functions exist
echo "Testing Mistral provider functionality..."

# Source the provider directly and test functions
source "$TEST_DIR/lib/config.sh"
source "$TEST_DIR/lib/security.sh"
source "$TEST_DIR/providers/mistral.sh"

# Test that the mistral_chat_completion function exists
if declare -f mistral_chat_completion >/dev/null; then
    echo "PASS: mistral_chat_completion function exists"
else
    echo "FAIL: mistral_chat_completion function not found"
    exit 1
fi

# Test mock mode for Mistral
export MOCK_MODE=true
response=$(mistral_chat_completion "test prompt")
if echo "$response" | grep -q "mock response from Mistral"; then
    echo "PASS: Mistral mock mode works correctly"
else
    echo "FAIL: Mistral mock mode not working correctly"
    exit 1
fi

# Test Mistral through the main curllm script
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/mistral_test_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/mistral_test_output.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Mistral provider works through main curllm script"
else
    echo "FAIL: Mistral provider failed through main curllm script"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check that the response came from Mistral
if echo "$output" | grep -q "mock response from Mistral"; then
    echo "PASS: Mistral provider correctly used in main script"
else
    echo "FAIL: Mistral provider not correctly used in main script"
    echo "Output: $output"
    exit 1
fi

echo "All Mistral provider tests passed!"