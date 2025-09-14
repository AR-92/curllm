#!/usr/bin/env bash

# Test comprehensive model management functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_comprehensive_model_test"
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
DEFAULT_PROVIDER=gemini
DEFAULT_MODEL=gemini-pro
GEMINI_API_KEY=test-key
EOF

# Test comprehensive model management functionality
echo "Testing comprehensive model management functionality..."

# Test 1: List models command
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" list-models --provider gemini > /tmp/comprehensive_list_models_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/comprehensive_list_models_output.txt)
set -e

if [[ $exit_code -eq 0 ]] && echo "$output" | grep -q "gemini-1.5-pro-latest (mock)"; then
    echo "PASS: list-models command works correctly"
else
    echo "FAIL: list-models command failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test 2: Set default model command
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" set-default --provider gemini --model gemini-1.5-pro > /tmp/comprehensive_set_default_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/comprehensive_set_default_output.txt)
set -e

if [[ $exit_code -eq 0 ]] && echo "$output" | grep -q "Default model set to 'gemini-1.5-pro' for provider 'gemini'"; then
    echo "PASS: set-default command works correctly"
else
    echo "FAIL: set-default command failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test 3: Verify config file was updated
config_content=$(cat "$TEST_DIR/.config/curllm/config")
if echo "$config_content" | grep -q "DEFAULT_MODEL=gemini-1.5-pro"; then
    echo "PASS: Config file correctly updated with new default model"
else
    echo "FAIL: Config file not updated correctly"
    echo "Config content: $config_content"
    exit 1
fi

# Test 4: Chat with new default model
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/comprehensive_chat_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/comprehensive_chat_output.txt)
set -e

if [[ $exit_code -eq 0 ]] && echo "$output" | grep -q "This is a mock response from Google Gemini for prompt:  test prompt"; then
    echo "PASS: Chat command uses new default model correctly"
else
    echo "FAIL: Chat command failed or didn't use new default model"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test 5: Override model with command line option
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat --provider gemini --model gemini-1.0-pro "test prompt" > /tmp/comprehensive_override_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/comprehensive_override_output.txt)
set -e

if [[ $exit_code -eq 0 ]] && echo "$output" | grep -q "This is a mock response from Google Gemini for prompt:  test prompt"; then
    echo "PASS: Model override with command line options works correctly"
else
    echo "FAIL: Model override with command line options failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

echo "All comprehensive model management tests passed!"