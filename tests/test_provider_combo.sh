#!/usr/bin/env bash

# Test provider combinations

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_provider_combo_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp bin/curllm "$TEST_DIR/bin/"
cp lib/*.sh "$TEST_DIR/lib/"
cp providers/*.sh "$TEST_DIR/providers/"

echo "Testing provider combinations..."

# Test switching between providers in the same session
providers=("openai" "qwen" "anthropic" "mistral" "gemini" "openrouter" "groq")
expected_strings=("OpenAI" "Qwen" "Anthropic" "Mistral" "Google Gemini" "OpenRouter" "Groq")

for i in "${!providers[@]}"; do
    provider="${providers[$i]}"
    expected_string="${expected_strings[$i]}"
    
    # Create a config file for this provider
    mkdir -p "$TEST_DIR/.config/curllm"
    cat > "$TEST_DIR/.config/curllm/config" << EOF
DEFAULT_PROVIDER=$provider
DEFAULT_MODEL=test-model
EOF
    
    set +e
    MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat "test prompt" > "/tmp/provider_combo_test_${provider}.txt" 2>&1
    exit_code=$?
    output=$(cat "/tmp/provider_combo_test_${provider}.txt")
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "PASS: curllm works with provider $provider"
    else
        echo "FAIL: curllm failed with provider $provider"
        echo "Exit code: $exit_code"
        echo "Output: $output"
        exit 1
    fi
    
    # Check that the response came from the correct provider
    if echo "$output" | grep -q "mock response from $expected_string"; then
        echo "PASS: curllm correctly used provider $provider"
    else
        echo "FAIL: curllm did not correctly use provider $provider"
        echo "Output: $output"
        exit 1
    fi
done

echo "All provider combination tests passed!"