#!/usr/bin/env bash

# Test Google Gemini provider functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_gemini_test"
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
DEFAULT_PROVIDER=gemini
DEFAULT_MODEL=gemini-pro
EOF

# Test that Google Gemini provider functions exist
echo "Testing Google Gemini provider functionality..."

# Source the provider directly and test functions
source "$TEST_DIR/lib/config.sh"
source "$TEST_DIR/lib/security.sh"
source "$TEST_DIR/providers/gemini.sh"

# Test that the gemini_chat_completion function exists
if declare -f gemini_chat_completion >/dev/null; then
    echo "PASS: gemini_chat_completion function exists"
else
    echo "FAIL: gemini_chat_completion function not found"
    exit 1
fi

# Test mock mode for Google Gemini
export MOCK_MODE=true
response=$(gemini_chat_completion "test prompt")
if echo "$response" | grep -q "mock response from Google Gemini"; then
    echo "PASS: Google Gemini mock mode works correctly"
else
    echo "FAIL: Google Gemini mock mode not working correctly"
    exit 1
fi

# Test Google Gemini through the main curllm script
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/gemini_test_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/gemini_test_output.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Google Gemini provider works through main curllm script"
else
    echo "FAIL: Google Gemini provider failed through main curllm script"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check that the response came from Google Gemini
if echo "$output" | grep -q "mock response from Google Gemini"; then
    echo "PASS: Google Gemini provider correctly used in main script"
else
    echo "FAIL: Google Gemini provider not correctly used in main script"
    echo "Output: $output"
    exit 1
fi

echo "All Google Gemini provider tests passed!"