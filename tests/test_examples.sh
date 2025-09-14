#!/usr/bin/env bash

# Test example usage scenarios

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_example_test"
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
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
EOF

echo "Testing example usage scenarios..."

# Test examples from README
examples=(
    "What is the capital of France?"
    "Explain quantum computing"
    "Compare Python and JavaScript programming languages"
)

for i in "${!examples[@]}"; do
    example="${examples[$i]}"
    
    set +e
    MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "$example" > "/tmp/example_test_$i.txt" 2>&1
    exit_code=$?
    output=$(cat "/tmp/example_test_$i.txt")
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "PASS: Example $((i+1)) works"
    else
        echo "FAIL: Example $((i+1)) failed"
        echo "Exit code: $exit_code"
        echo "Output: $output"
        exit 1
    fi
done

# Test provider-specific examples
provider_examples=(
    "--provider qwen \"Explain quantum computing\""
    "--provider groq --model llama3-8b-8192 \"What is Bash?\""
)

for i in "${!provider_examples[@]}"; do
    example_args="${provider_examples[$i]}"
    
    set +e
    MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat $example_args > "/tmp/provider_example_test_$i.txt" 2>&1
    exit_code=$?
    output=$(cat "/tmp/provider_example_test_$i.txt")
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "PASS: Provider example $((i+1)) works"
    else
        echo "FAIL: Provider example $((i+1)) failed"
        echo "Exit code: $exit_code"
        echo "Output: $output"
        exit 1
    fi
done

echo "All example usage tests passed!"