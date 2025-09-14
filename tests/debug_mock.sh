#!/usr/bin/env bash

# Debug mock mode functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_mock_debug"
mkdir -p "$TEST_DIR"

# Copy curllm, lib, and providers to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp bin/curllm "$TEST_DIR/bin/"
cp lib/*.sh "$TEST_DIR/lib/"
cp providers/*.sh "$TEST_DIR/providers/"

# Create a test config file (no API key needed for mock mode)
mkdir -p "$TEST_DIR/.config/curllm"
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# curllm configuration
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
EOF

# Test that mock mode works
echo "Debugging mock mode functionality..."

# Test that curllm works in mock mode without an API key
echo "Running curllm in mock mode..."
set +e
MOCK_MODE=true output=$("$TEST_DIR/bin/curllm" chat "test prompt" 2>&1)
exit_code=$?
set -e

echo "Exit code: $exit_code"
echo "Output:"
echo "$output"