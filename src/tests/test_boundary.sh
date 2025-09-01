#!/usr/bin/env bash

# Test boundary conditions

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_boundary_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

# Create a test config file
mkdir -p "$TEST_DIR/.config/curllm"
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# curllm configuration
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
EOF

echo "Testing boundary conditions..."

# Test with very short model names
short_models=("a" "ab" "abc")

for model in "${short_models[@]}"; do
    set +e
    MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat --model "$model" "test prompt" > "/tmp/boundary_test_short_model_${model}.txt" 2>&1
    exit_code=$?
    output=$(cat "/tmp/boundary_test_short_model_${model}.txt")
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "PASS: Very short model name '$model' works"
    else
        echo "FAIL: Very short model name '$model' failed"
        echo "Exit code: $exit_code"
        echo "Output: $output"
        exit 1
    fi
done

# Test with model names containing special characters
special_models=("model-v1" "model_v2" "model.v3" "model:v4")

for model in "${special_models[@]}"; do
    set +e
    MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat --model "$model" "test prompt" > "/tmp/boundary_test_special_model_${model}.txt" 2>&1
    exit_code=$?
    output=$(cat "/tmp/boundary_test_special_model_${model}.txt")
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "PASS: Model name with special characters '$model' works"
    else
        echo "FAIL: Model name with special characters '$model' failed"
        echo "Exit code: $exit_code"
        echo "Output: $output"
        exit 1
    fi
done

echo "All boundary condition tests passed!"