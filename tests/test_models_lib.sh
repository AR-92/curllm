#!/usr/bin/env bash

# Test models library functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_models_lib_test"
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

# Test models library functions
echo "Testing models library functionality..."

# Test list_models function directly
set +e
(
    cd "$TEST_DIR"
    source lib/config.sh
    source lib/security.sh
    source lib/models.sh
    MOCK_MODE=true models_output=$(list_models "gemini")
    echo "$models_output"
) > /tmp/list_models_direct_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/list_models_direct_output.txt)
set -e

echo "Exit code: $exit_code"
echo "Output: $output"

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: list_models function executed successfully"
else
    echo "FAIL: list_models function failed"
    echo "Output: $output"
    exit 1
fi

# Check if output contains expected models
if echo "$output" | grep -q "gemini-1.5-pro-latest"; then
    echo "PASS: list_models output contains expected gemini model"
else
    echo "FAIL: list_models output does not contain expected gemini model"
    echo "Output: $output"
    exit 1
fi

# Test set_default_model function directly
set +e
(
    cd "$TEST_DIR"
    source lib/models.sh
    set_default_model "gemini" "gemini-1.5-pro"
    cat "$TEST_DIR/.config/curllm/config"
) > /tmp/set_default_model_direct_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/set_default_model_direct_output.txt)
set -e

echo "Exit code: $exit_code"
echo "Output: $output"

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: set_default_model function executed successfully"
else
    echo "FAIL: set_default_model function failed"
    echo "Output: $output"
    exit 1
fi

# Check if config file was updated correctly
if echo "$output" | grep -q "Default model set to 'gemini-1.5-pro' for provider 'gemini'"; then
    echo "PASS: Config file updated with new default model"
else
    echo "FAIL: Config file not updated with new default model"
    echo "Output: $output"
    exit 1
fi

echo "All models library tests passed!"