#!/usr/bin/env bash

# Test verbose logging functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_verbose_logging_test"
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

echo "Testing verbose logging functionality..."

# Test verbose logging produces more detailed output
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" XDG_CACHE_HOME="$TEST_DIR/.cache" "$TEST_DIR/bin/curllm" chat --verbose "verbose test prompt" > /tmp/verbose_logging_test_output.txt 2>&1
exit_code=$?
output=$(cat /tmp/verbose_logging_test_output.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Verbose chat with logging works"
else
    echo "FAIL: Verbose chat with logging failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Check that log file was created
log_file="$TEST_DIR/.cache/curllm/curllm.log"
if [[ -f "$log_file" ]]; then
    echo "PASS: Log file was created"
    
    # Check that log file contains debug level entries
    if grep -q "DEBUG" "$log_file"; then
        echo "PASS: Log file contains debug level entries (verbose mode working)"
    else
        echo "FAIL: Log file does not contain debug level entries"
        echo "Log file content:"
        cat "$log_file"
        exit 1
    fi
    
    # Check that log file contains the prompt
    if grep -q "verbose test prompt" "$log_file"; then
        echo "PASS: Log file contains prompt information"
    else
        echo "FAIL: Log file does not contain prompt information"
        echo "Log file content:"
        cat "$log_file"
        exit 1
    fi
else
    echo "FAIL: Log file was not created"
    exit 1
fi

echo "All verbose logging functionality tests passed!"