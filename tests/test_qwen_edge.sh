#!/usr/bin/env bash

# Test Qwen provider edge cases

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_qwen_edge_test"
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
DEFAULT_PROVIDER=qwen
DEFAULT_MODEL=qwen-turbo
EOF

echo "Testing Qwen provider edge cases..."

# Test Qwen with different models
models=("qwen-turbo" "qwen-plus" "qwen-max")

for model in "${models[@]}"; do
    set +e
    MOCK_MODE=true "$TEST_DIR/bin/curllm" chat --model "$model" "test prompt" > "/tmp/qwen_edge_test_${model}.txt" 2>&1
    exit_code=$?
    output=$(cat "/tmp/qwen_edge_test_${model}.txt")
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "PASS: Qwen provider works with model $model"
    else
        echo "FAIL: Qwen provider failed with model $model"
        echo "Exit code: $exit_code"
        echo "Output: $output"
        exit 1
    fi
done

echo "All Qwen provider edge case tests passed!"