#!/usr/bin/env bash

# Test documentation files

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_doc_files_test"
mkdir -p "$TEST_DIR"

echo "Testing documentation files..."

# Test that all required documentation files exist
doc_files=(
    "README.md"
    "DOCUMENTATION.md"
    ".env.example"
)

for file in "${doc_files[@]}"; do
    if [[ -f "../$file" ]]; then
        echo "PASS: Documentation file $file exists"
    else
        echo "FAIL: Documentation file $file is missing"
        exit 1
    fi
done

# Test that README.md contains expected sections
readme_content=$(cat ../README.md)

sections=("Introduction" "Installation" "Configuration" "Usage" "Mock Mode" "Supported Providers" "Development")

for section in "${sections[@]}"; do
    if echo "$readme_content" | grep -q "# $section"; then
        echo "PASS: README.md contains section $section"
    else
        echo "FAIL: README.md is missing section $section"
        exit 1
    fi
done

# Test that DOCUMENTATION.md is comprehensive
doc_content=$(cat ../DOCUMENTATION.md)

if echo "$doc_content" | grep -q "Table of Contents"; then
    echo "PASS: DOCUMENTATION.md contains Table of Contents"
else
    echo "FAIL: DOCUMENTATION.md is missing Table of Contents"
    exit 1
fi

echo "All documentation file tests passed!"