#!/usr/bin/env bash

# Test all providers functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_all_providers_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp bin/curllm "$TEST_DIR/bin/"
cp lib/*.sh "$TEST_DIR/lib/"
cp providers/*.sh "$TEST_DIR/providers/"

# Test that all provider functions exist
echo "Testing all providers functionality..."

# Source all provider scripts and test functions
source "$TEST_DIR/lib/config.sh"
source "$TEST_DIR/lib/security.sh"

# Test OpenAI provider
source "$TEST_DIR/providers/openai.sh"
if declare -f openai_chat_completion >/dev/null; then
    echo "PASS: openai_chat_completion function exists"
else
    echo "FAIL: openai_chat_completion function not found"
    exit 1
fi

# Test Qwen provider
source "$TEST_DIR/providers/qwen.sh"
if declare -f qwen_chat_completion >/dev/null; then
    echo "PASS: qwen_chat_completion function exists"
else
    echo "FAIL: qwen_chat_completion function not found"
    exit 1
fi

# Test Anthropic provider
source "$TEST_DIR/providers/anthropic.sh"
if declare -f anthropic_chat_completion >/dev/null; then
    echo "PASS: anthropic_chat_completion function exists"
else
    echo "FAIL: anthropic_chat_completion function not found"
    exit 1
fi

# Test Mistral provider
source "$TEST_DIR/providers/mistral.sh"
if declare -f mistral_chat_completion >/dev/null; then
    echo "PASS: mistral_chat_completion function exists"
else
    echo "FAIL: mistral_chat_completion function not found"
    exit 1
fi

# Test Google Gemini provider
source "$TEST_DIR/providers/gemini.sh"
if declare -f gemini_chat_completion >/dev/null; then
    echo "PASS: gemini_chat_completion function exists"
else
    echo "FAIL: gemini_chat_completion function not found"
    exit 1
fi

# Test OpenRouter provider
source "$TEST_DIR/providers/openrouter.sh"
if declare -f openrouter_chat_completion >/dev/null; then
    echo "PASS: openrouter_chat_completion function exists"
else
    echo "FAIL: openrouter_chat_completion function not found"
    exit 1
fi

# Test Groq provider
source "$TEST_DIR/providers/groq.sh"
if declare -f groq_chat_completion >/dev/null; then
    echo "PASS: groq_chat_completion function exists"
else
    echo "FAIL: groq_chat_completion function not found"
    exit 1
fi

# Test all providers through the main curllm script
echo "Testing all providers through main curllm script..."

# Create a test config file
mkdir -p "$TEST_DIR/.config/curllm"
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# curllm configuration
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
EOF

# Test each provider with mock mode
providers=("openai" "qwen" "anthropic" "mistral" "gemini" "openrouter" "groq")
expected_strings=("OpenAI" "Qwen" "Anthropic" "Mistral" "Google Gemini" "OpenRouter" "Groq")

for i in "${!providers[@]}"; do
    provider="${providers[$i]}"
    expected_string="${expected_strings[$i]}"
    
    set +e
    MOCK_MODE=true "$TEST_DIR/bin/curllm" chat --provider "$provider" "test prompt" > "/tmp/all_providers_test_${provider}.txt" 2>&1
    exit_code=$?
    output=$(cat "/tmp/all_providers_test_${provider}.txt")
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "PASS: $provider provider works through main curllm script"
    else
        echo "FAIL: $provider provider failed through main curllm script"
        echo "Exit code: $exit_code"
        echo "Output: $output"
        exit 1
    fi
    
    # Check that the response came from the correct provider
    if echo "$output" | grep -q "mock response from $expected_string"; then
        echo "PASS: $provider provider correctly used in main script"
    else
        echo "FAIL: $provider provider not correctly used in main script"
        echo "Output: $output"
        exit 1
    fi
done

echo "All providers functionality tests passed!"