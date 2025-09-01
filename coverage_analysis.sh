#!/bin/bash

echo "=== curllm Code Coverage Analysis ==="
echo

# Source files that need to be tested
echo "Source files to be tested:"
SOURCE_FILES=$(find src -name "*.sh" -not -path "src/tests/*" | sort)
echo "$SOURCE_FILES"
SOURCE_COUNT=$(echo "$SOURCE_FILES" | wc -l)
echo "Total source files: $SOURCE_COUNT"
echo

# Test files
echo "Test files:"
TEST_FILES=$(ls src/tests/test_*.sh | sort)
echo "$TEST_FILES"
TEST_COUNT=$(echo "$TEST_FILES" | wc -l)
echo "Total test files: $TEST_COUNT"
echo

# Check which source files have corresponding test files
echo "Coverage analysis:"
echo "=================="

COVERED_COUNT=0
NOT_COVERED=()

for source_file in $SOURCE_FILES; do
    filename=$(basename "$source_file")
    name_without_ext="${filename%.*}"
    
    # Look for test files that might test this source file
    if ls src/tests/test_*"$name_without_ext"*.sh 1> /dev/null 2>&1; then
        matching_tests=$(ls src/tests/test_*"$name_without_ext"*.sh 2>/dev/null)
        echo "✓ $filename - Covered by:"
        for test in $matching_tests; do
            echo "  - $(basename "$test")"
        done
        COVERED_COUNT=$((COVERED_COUNT + 1))
    else
        echo "✗ $filename - No specific tests found"
        NOT_COVERED+=("$filename")
    fi
    echo
done

echo "=== Summary ==="
echo "Total source files: $SOURCE_COUNT"
echo "Files with specific tests: $COVERED_COUNT"
echo "Files without specific tests: ${#NOT_COVERED[@]}"

if [ ${#NOT_COVERED[@]} -gt 0 ]; then
    echo "Files without specific tests:"
    for file in "${NOT_COVERED[@]}"; do
        echo "  - $file"
    done
fi

COVERAGE_PERCENTAGE=$((COVERED_COUNT * 100 / SOURCE_COUNT))
echo "Coverage percentage: $COVERAGE_PERCENTAGE%"