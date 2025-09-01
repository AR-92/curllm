#!/usr/bin/env bash

# Test mock mode edge cases

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_mock_edge_test"
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

echo "Testing mock mode edge cases..."

# Test MOCK_MODE with different values
mock_values=("true" "1" "yes" "TRUE" "True")

for mock_value in "${mock_values[@]}"; do
    set +e
    MOCK_MODE="$mock_value" XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "test prompt" > "/tmp/mock_edge_test_${mock_value}.txt" 2>&1
    exit_code=$?
    output=$(cat "/tmp/mock_edge_test_${mock_value}.txt")
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "PASS: curllm works with MOCK_MODE=$mock_value"
    else
        echo "FAIL: curllm should work with MOCK_MODE=$mock_value"
        echo "Exit code: $exit_code"
        echo "Output: $output"
        exit 1
    fi
done

# Test MOCK_MODE with false values
false_values=("false" "0" "no" "FALSE" "False" "")

for false_value in "${false_values[@]}"; do
    set +e
    MOCK_MODE="$false_value" XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "test prompt" > "/tmp/mock_edge_test_false_${false_value}.txt" 2>&1
    exit_code=$?
    output=$(cat "/tmp/mock_edge_test_false_${false_value}.txt")
    set -e
    
    # Should fail because no API key is available
    if [[ $exit_code -eq 1 ]]; then
        echo "PASS: curllm correctly fails with MOCK_MODE=$false_value and no API key"
    else
        echo "FAIL: curllm should fail with MOCK_MODE=$false_value and no API key"
        echo "Exit code: $exit_code"
        echo "Output: $output"
        exit 1
    fi
done

echo "All mock mode edge case tests passed!"