#!/usr/bin/env bash

# Test Groq provider functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_groq_test"
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
DEFAULT_PROVIDER=groq
DEFAULT_MODEL=llama3-8b-8192
EOF

# Test that Groq provider functions exist
echo "Testing Groq provider functionality..."

# Source the provider directly and test functions
source "$TEST_DIR/lib/config.sh"
source "$TEST_DIR/lib/security.sh"
source "$TEST_DIR/providers/groq.sh"

# Test that the groq_chat_completion function exists
if declare -f groq_chat_completion >/dev/null; then
    echo "PASS: groq_chat_completion function exists"
else
    echo "FAIL: groq_chat_completion function not found"
    exit 1
fi

# Test mock mode for Groq
export MOCK_MODE=true
response=$(groq_chat_completion "test prompt")
if echo "$response" | grep -q "mock response from Groq"; then
    echo "PASS: Groq mock mode works correctly"
else
    echo "FAIL: Groq mock mode not working correctly"
    exit 1
fi

# Test Groq through the main curllm script
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/groq_test_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/groq_test_output.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Groq provider works through main curllm script"
else
    echo "FAIL: Groq provider failed through main curllm script"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check that the response came from Groq
if echo "$output" | grep -q "mock response from Groq"; then
    echo "PASS: Groq provider correctly used in main script"
else
    echo "FAIL: Groq provider not correctly used in main script"
    echo "Output: $output"
    exit 1
fi

echo "All Groq provider tests passed!"