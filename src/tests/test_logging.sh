#!/usr/bin/env bash

# Test logging functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_logging_test"
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

echo "Testing logging functionality..."

# Test basic logging
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" XDG_CACHE_HOME="$TEST_DIR/.cache" "$TEST_DIR/bin/curllm" chat "test prompt" > /tmp/logging_test_basic.txt 2>&1
exit_code=$?
output=$(cat /tmp/logging_test_basic.txt)
set -e

if [[ $exit_code -eq 0 ]]; then
    echo "PASS: Basic chat with logging works"
else
    echo "FAIL: Basic chat with logging failed"
    echo "Exit code: $exit_code"
    echo "Output: $output"
    exit 1
fi

# Test verbose logging
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" XDG_CACHE_HOME="$TEST_DIR/.cache" "$TEST_DIR/bin/curllm" chat --verbose "verbose test prompt" > /tmp/logging_test_verbose.txt 2>&1
exit_code=$?
output=$(cat /tmp/logging_test_verbose.txt)
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
    
    # Check that log file contains expected content
    if grep -q "curllm started" "$log_file" && grep -q "curllm finished" "$log_file"; then
        echo "PASS: Log file contains expected entries"
    else
        echo "FAIL: Log file does not contain expected entries"
        echo "Log file content:"
        cat "$log_file"
        exit 1
    fi
else
    echo "FAIL: Log file was not created"
    echo "Expected log file location: $log_file"
    echo "Contents of cache directory:"
    ls -la "$TEST_DIR/.cache" 2>/dev/null || echo "Cache directory does not exist"
    echo "Contents of cache/curllm directory:"
    ls -la "$TEST_DIR/.cache/curllm" 2>/dev/null || echo "Cache/curllm directory does not exist"
    exit 1
fi

echo "All logging functionality tests passed!"