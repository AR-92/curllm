#!/usr/bin/env bash

# Test OpenAI provider edge cases

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_openai_edge_test"
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
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
EOF

echo "Testing OpenAI provider edge cases..."

# Test OpenAI with different models
models=("gpt-3.5-turbo" "gpt-4" "gpt-4-turbo")

for model in "${models[@]}"; do
    set +e
    MOCK_MODE=true "$TEST_DIR/bin/curllm" chat --model "$model" "test prompt" > "/tmp/openai_edge_test_${model}.txt" 2>&1
    exit_code=$?
    output=$(cat "/tmp/openai_edge_test_${model}.txt")
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "PASS: OpenAI provider works with model $model"
    else
        echo "FAIL: OpenAI provider failed with model $model"
        echo "Exit code: $exit_code"
        echo "Output: $output"
        exit 1
    fi
done

# Test OpenAI with empty prompt
set +e
MOCK_MODE=true "$TEST_DIR/bin/curllm" chat "" > /tmp/openai_edge_test_empty.txt 2>&1
exit_code=$?
output=$(cat /tmp/openai_edge_test_empty.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: OpenAI provider handles empty prompt"
else
    echo "FAIL: OpenAI provider should handle empty prompt"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

echo "All OpenAI provider edge case tests passed!"