#!/usr/bin/env bash

# Test what's happening with the actual curllm script

set -euo pipefail

echo "Testing actual curllm script..."

# Test help --verbose
echo "=== Testing curllm help --verbose ==="
output=$(./curllm/bin/curllm help --verbose 2>&1)
exit_code=$?

echo "Exit code: $exit_code"
echo "First 5 lines of output:"
echo "$output" | head -n 5
echo ""

# Check if output contains verbose help indicators
if echo "$output" | grep -q "Universal LLM API Wrapper"; then
    echo "✓ Contains verbose help header"
else
    echo "✗ Does not contain verbose help header"
fi

if echo "$output" | grep -q "SUPPORTED PROVIDERS"; then
    echo "✓ Contains supported providers section"
else
    echo "✗ Does not contain supported providers section"
fi

# Compare lengths
standard_help_lines=$(/home/rana/Documents/Projects/curllm/bin/curllm help | wc -l)
verbose_help_lines=$(/home/rana/Documents/Projects/curllm/bin/curllm help --verbose | wc -l)

echo "Standard help lines: $standard_help_lines"
echo "Verbose help lines: $verbose_help_lines"

if [[ $verbose_help_lines -gt $standard_help_lines ]]; then
    echo "✓ Verbose help is longer than standard help"
else
    echo "✗ Verbose help is not longer than standard help"
fi