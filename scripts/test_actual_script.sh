#!/usr/bin/env bash

# Test the actual curllm script to see what's going wrong

set -euo pipefail

echo "=== Testing actual curllm script ==="

# Test help
echo "=== Testing: help ==="
output=$(./curllm/bin/curllm help 2>&1)
echo "Exit code: $?"
echo "First line: $(echo "$output" | head -n 1)"
echo ""

# Test help --verbose
echo "=== Testing: help --verbose ==="
output=$(./curllm/bin/curllm help --verbose 2>&1)
echo "Exit code: $?"
echo "First line: $(echo "$output" | head -n 1)"
echo ""

# Check if verbose help contains the unique header
if echo "$output" | grep -q "curllm - Universal LLM API Wrapper"; then
    echo "✓ Contains verbose help header"
else
    echo "✗ Does not contain verbose help header"
fi

# Check if standard help contains its header
if echo "$output" | grep -q "curllm - A pure Bash LLM API wrapper"; then
    echo "✓ Contains standard help header"
else
    echo "✗ Does not contain standard help header"
fi