#!/usr/bin/env bash

# Test Google Gemini provider edge cases

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_gemini_edge_test"
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

echo "Testing Google Gemini provider edge cases..."

# Test Google Gemini with different models
models=("gemini-pro" "gemini-pro-vision")

for model in "${models[@]}"; do
    set +e
    MOCK_MODE=true "$TEST_DIR/bin/curllm" chat --model "$model" "test prompt" > "/tmp/gemini_edge_test_${model}.txt" 2>&1
    exit_code=$?
    output=$(cat "/tmp/gemini_edge_test_${model}.txt")
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "PASS: Google Gemini provider works with model $model"
    else
        echo "FAIL: Google Gemini provider failed with model $model"
        echo "Exit code: $exit_code"
        echo "Output: $output"
        exit 1
    fi
done

echo "All Google Gemini provider edge case tests passed!"