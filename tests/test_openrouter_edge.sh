#!/usr/bin/env bash

# Test OpenRouter provider edge cases

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_openrouter_edge_test"
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
DEFAULT_PROVIDER=openrouter
DEFAULT_MODEL=openrouter/auto
EOF

echo "Testing OpenRouter provider edge cases..."

# Test OpenRouter with different models
models=("openrouter/auto" "openai/gpt-3.5-turbo" "anthropic/claude-2")

for model in "${models[@]}"; do
    set +e
    MOCK_MODE=true "$TEST_DIR/bin/curllm" chat --model "$model" "test prompt" > "/tmp/openrouter_edge_test_${model}.txt" 2>&1
    exit_code=$?
    output=$(cat "/tmp/openrouter_edge_test_${model}.txt")
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "PASS: OpenRouter provider works with model $model"
    else
        echo "FAIL: OpenRouter provider failed with model $model"
        echo "Exit code: $exit_code"
        echo "Output: $output"
        exit 1
    fi
done

echo "All OpenRouter provider edge case tests passed!"