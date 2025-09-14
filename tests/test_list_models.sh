#!/usr/bin/env bash

# Test list-models functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_list_models_test"
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

# Test list-models command
echo "Testing list-models functionality..."

# Test list-models with gemini provider
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" list-models --provider gemini > /tmp/list_models_gemini_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/list_models_gemini_output.txt)
set -e

echo "Exit code: $exit_code"
echo "Output: $output"

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: list-models command executed successfully for gemini"
else
    echo "FAIL: list-models command failed for gemini with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check if output contains expected models
if echo "$output" | grep -q "gemini-1.5-pro-latest (mock)"; then
    echo "PASS: Output contains expected gemini model"
else
    echo "FAIL: Output does not contain expected gemini model"
    echo "Output: $output"
    exit 1
fi

# Test list-models with openai provider
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" list-models --provider openai > /tmp/list_models_openai_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/list_models_openai_output.txt)
set -e

echo "Exit code: $exit_code"
echo "Output: $output"

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: list-models command executed successfully for openai"
else
    echo "FAIL: list-models command failed for openai with exit code $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check if output contains expected models
if echo "$output" | grep -q "gpt-4-turbo (mock)"; then
    echo "PASS: Output contains expected openai model"
else
    echo "FAIL: Output does not contain expected openai model"
    echo "Output: $output"
    exit 1
fi

echo "All list-models tests passed!"