#!/usr/bin/env bash

# Test set-default functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_set_default_test"
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

# Test set-default command
echo "Testing set-default functionality..."

# Test set-default with gemini provider
set +e
XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" set-default --provider gemini --model gemini-1.5-pro > /tmp/set_default_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/set_default_output.txt)
set -e

echo "Exit code: $exit_code"
echo "Output: $output"

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: set-default command executed successfully"
else
    echo "FAIL: set-default command failed with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check if output contains success message
if echo "$output" | grep -q "Default model set to 'gemini-1.5-pro' for provider 'gemini'"; then
    echo "PASS: Output contains expected success message"
else
    echo "FAIL: Output does not contain expected success message"
    echo "Output: $output"
    exit 1
fi

# Check if config file was updated correctly
config_content=$(cat "$TEST_DIR/.config/curllm/config")
if echo "$config_content" | grep -q "DEFAULT_MODEL=gemini-1.5-pro"; then
    echo "PASS: Config file updated with new default model"
else
    echo "FAIL: Config file not updated with new default model"
    echo "Config content: $config_content"
    exit 1
fi

# Test set-default without provider (should fail)
set +e
XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" set-default --model gemini-1.5-pro > /tmp/set_default_no_provider_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/set_default_no_provider_output.txt)
set -e

# Even without --provider, it will require explicit provider and model
if [[ $exit_code -ne 0 ]]; then
    echo "PASS: set-default without explicit provider correctly failed"
else
    echo "FAIL: set-default without explicit provider should have failed"
    echo "Output: $output"
    exit 1
fi

# Test set-default without model (should fail)
set +e
XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" set-default --provider gemini > /tmp/set_default_no_model_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/set_default_no_model_output.txt)
set -e

if [[ $exit_code -ne 0 ]]; then
    echo "PASS: set-default without model correctly failed"
else
    echo "FAIL: set-default without model should have failed"
    echo "Output: $output"
    exit 1
fi

echo "All set-default tests passed!"