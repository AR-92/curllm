#!/usr/bin/env bash

# Test Mistral provider edge cases

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_mistral_edge_test"
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
DEFAULT_PROVIDER=mistral
DEFAULT_MODEL=mistral-tiny
EOF

echo "Testing Mistral provider edge cases..."

# Test Mistral with different models
models=("mistral-tiny" "mistral-small" "mistral-medium")

for model in "${models[@]}"; do
    set +e
    MOCK_MODE=true "$TEST_DIR/bin/curllm" chat --model "$model" "test prompt" > "/tmp/mistral_edge_test_${model}.txt" 2>&1
    exit_code=$?
    output=$(cat "/tmp/mistral_edge_test_${model}.txt")
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "PASS: Mistral provider works with model $model"
    else
        echo "FAIL: Mistral provider failed with model $model"
        echo "Exit code: $exit_code"
        echo "Output: $output"
        exit 1
    fi
done

echo "All Mistral provider edge case tests passed!"