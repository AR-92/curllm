#!/usr/bin/env bash

# Test installation scenarios

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_install_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

echo "Testing installation scenarios..."

# Test that all required files are present
required_files=(
    "bin/curllm"
    "lib/config.sh"
    "lib/security.sh"
    "lib/utils.sh"
    "providers/openai.sh"
    "providers/qwen.sh"
    "providers/anthropic.sh"
    "providers/mistral.sh"
    "providers/gemini.sh"
    "providers/openrouter.sh"
    "providers/groq.sh"
)

for file in "${required_files[@]}"; do
    if [[ -f "/home/rana/Documents/Projects/curllm/$file" ]]; then
        echo "PASS: Required file $file is present"
    else
        echo "FAIL: Required file $file is missing"
        exit 1
    fi
done

# Test that all provider functions are defined
providers=("openai" "qwen" "anthropic" "mistral" "gemini" "openrouter" "groq")
functions=("chat_completion")

for provider in "${providers[@]}"; do
    # Source the provider script
    source "/home/rana/Documents/Projects/curllm/providers/${provider}.sh"
    
    # Check if the function exists
    function_name="${provider}_chat_completion"
    if declare -f "$function_name" >/dev/null; then
        echo "PASS: Function $function_name is defined"
    else
        echo "FAIL: Function $function_name is not defined"
        exit 1
    fi
done

echo "All installation tests passed!"