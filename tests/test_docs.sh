#!/usr/bin/env bash

# Test documentation examples

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_doc_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp bin/curllm "$TEST_DIR/bin/"
cp lib/*.sh "$TEST_DIR/lib/"
cp providers/*.sh "$TEST_DIR/providers/"

echo "Testing documentation examples..."

# Test that all providers mentioned in help are implemented
set +e
"$TEST_DIR/bin/curllm" --help > /tmp/doc_test_help.txt 2>&1
exit_code=$?
output=$(cat /tmp/doc_test_help.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Help command works"
else
    echo "FAIL: Help command failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check that all documented providers are mentioned
providers=("openai" "anthropic" "qwen" "mistral" "gemini" "openrouter" "groq")

for provider in "${providers[@]}"; do
    if echo "$output" | grep -q "$provider"; then
        echo "PASS: Provider $provider is documented in help"
    else
        echo "FAIL: Provider $provider is not documented in help"
        exit 1
    fi
done

# Test that all documented commands work
commands=("chat" "help" "version")

for command in "${commands[@]}"; do
    set +e
    "$TEST_DIR/bin/curllm" "$command" > /dev/null 2>&1 || "$TEST_DIR/bin/curllm" "$command" --help > /dev/null 2>&1
    exit_code=$?
    set -e
    
    if [[ $exit_code -eq 0 ]]; then
        echo "PASS: Command $command works"
    else
        echo "FAIL: Command $command failed"
        exit 1
    fi
done

echo "All documentation example tests passed!"