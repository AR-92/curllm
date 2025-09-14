#!/usr/bin/env bash

# Test Groq provider edge cases

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_groq_edge_test"
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
DEFAULT_PROVIDER=groq
DEFAULT_MODEL=llama3-8b-8192
EOF

echo "Testing Groq provider edge cases..."

# Test Groq with different models
models=("llama3-8b-8192" "llama2-70b-4096" "mixtral-8x7b-32768")

for model in "${models[@]}"; do
    set +e
    MOCK_MODE=true "$TEST_DIR/bin/curllm" chat --model "$model" "test prompt" > "/tmp/groq_edge_test_${model}.txt" 2>&1
    exit_code=$?
    output=$(cat "/tmp/groq_edge_test_${model}.txt")
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "PASS: Groq provider works with model $model"
    else
        echo "FAIL: Groq provider failed with model $model"
        echo "Exit code: $exit_code"
        echo "Output: $output"
        exit 1
    fi
done

echo "All Groq provider edge case tests passed!"