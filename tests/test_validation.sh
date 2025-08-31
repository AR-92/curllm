#!/usr/bin/env bash

# Test input validation

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_validation_test"
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

echo "Testing input validation..."

# Test with various prompt formats
prompts=(
    ""  # Empty prompt (should fail)
    " "  # Space only
    "A"  # Single character
    "1234567890"  # Numbers only
    "!@#$%^&*()"  # Special characters only
    "Test prompt with unicode: 你好世界 🌍"  # Unicode characters
)

for i in "${!prompts[@]}"; do
    prompt="${prompts[$i]}"
    
    # Skip empty prompt test as it should fail
    if [[ -z "$prompt" ]]; then
        set +e
        MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "$prompt" > "/tmp/validation_test_${i}.txt" 2>&1
        exit_code=$?
        output=$(cat "/tmp/validation_test_${i}.txt")
        set -e
        
        if [[ $exit_code -eq 1 ]]; then
            echo "PASS: Empty prompt correctly rejected"
        else
            echo "FAIL: Empty prompt should be rejected"
            echo "Exit code: $exit_code"
            echo "Output: $output"
            exit 1
        fi
        continue
    fi
    
    set +e
    MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "$prompt" > "/tmp/validation_test_${i}.txt" 2>&1
    exit_code=$?
    output=$(cat "/tmp/validation_test_${i}.txt")
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "PASS: Prompt format $((i+1)) works"
    else
        echo "FAIL: Prompt format $((i+1)) failed"
        echo "Exit code: $exit_code"
        echo "Output: $output"
        exit 1
    fi
done

echo "All input validation tests passed!"