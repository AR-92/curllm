#!/usr/bin/env bash

# Test browse-models functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_browse_models_test"
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

# Test browse-models command
echo "Testing browse-models functionality..."

# Test browse-models with gemini provider
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" browse-models --provider gemini > /tmp/browse_models_gemini_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/browse_models_gemini_output.txt)
set -e

echo "Exit code: $exit_code"
# We expect exit code 1 because we can't provide input in automated test

# Check if output contains expected header
if echo "$output" | grep -q "Interactive Model Browser for gemini"; then
    echo "PASS: browse-models command executed successfully for gemini"
else
    echo "FAIL: browse-models command failed for gemini"
    echo "Output: $output"
    exit 1
fi

# Check if output contains expected models
if echo "$output" | grep -q "gemini-1.5-pro-latest"; then
    echo "PASS: Output contains expected gemini model"
else
    echo "FAIL: Output does not contain expected gemini model"
    echo "Output: $output"
    exit 1
fi

# Test browse-models with openai provider
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" browse-models --provider openai > /tmp/browse_models_openai_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/browse_models_openai_output.txt)
set -e

# Check if output contains expected header
if echo "$output" | grep -q "Interactive Model Browser for openai"; then
    echo "PASS: browse-models command executed successfully for openai"
else
    echo "FAIL: browse-models command failed for openai"
    echo "Output: $output"
    exit 1
fi

# Check if output contains expected models
if echo "$output" | grep -q "gpt-4-turbo"; then
    echo "PASS: Output contains expected openai model"
else
    echo "FAIL: Output does not contain expected openai model"
    echo "Output: $output"
    exit 1
fi

echo "All browse-models tests passed!"