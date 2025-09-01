#!/usr/bin/env bash

# Final comprehensive test

set -euo pipefail

echo "=== Final Comprehensive Test ==="

# Test help
echo "=== Testing: help ==="
output=$(./curllm/bin/curllm help 2>&1)
if echo "$output" | grep -q "curllm - A pure Bash LLM API wrapper"; then
    echo "✓ help works correctly"
else
    echo "✗ help failed"
    exit 1
fi

# Test help --verbose
echo "=== Testing: help --verbose ==="
output=$(./curllm/bin/curllm help --verbose 2>&1)
if echo "$output" | grep -q "curllm - Universal LLM API Wrapper"; then
    echo "✓ help --verbose works correctly"
else
    echo "✗ help --verbose failed"
    exit 1
fi

# Test --help --verbose
echo "=== Testing: --help --verbose ==="
output=$(./curllm/bin/curllm --help --verbose 2>&1)
if echo "$output" | grep -q "curllm - Universal LLM API Wrapper"; then
    echo "✓ --help --verbose works correctly"
else
    echo "✗ --help --verbose failed"
    exit 1
fi

# Test version
echo "=== Testing: version ==="
output=$(./curllm/bin/curllm version 2>&1)
if echo "$output" | grep -q "curllm v0.1.0"; then
    echo "✓ version works correctly"
else
    echo "✗ version failed"
    exit 1
fi

# Test --version
echo "=== Testing: --version ==="
output=$(./curllm/bin/curllm --version 2>&1)
if echo "$output" | grep -q "curllm v0.1.0"; then
    echo "✓ --version works correctly"
else
    echo "✗ --version failed"
    exit 1
fi

# Test standard help vs verbose help length
standard_lines=$(./curllm/bin/curllm help | wc -l)
verbose_lines=$(./curllm/bin/curllm help --verbose | wc -l)

if [[ $verbose_lines -gt $standard_lines ]]; then
    echo "✓ Verbose help is longer than standard help ($verbose_lines > $standard_lines)"
else
    echo "✗ Verbose help should be longer than standard help ($verbose_lines <= $standard_lines)"
    exit 1
fi

echo ""
echo "🎉 All tests passed! The verbose help system is working correctly."