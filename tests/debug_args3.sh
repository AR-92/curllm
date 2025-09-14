#!/usr/bin/env bash

# Debug argument parsing

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_debug_args3"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp bin/curllm "$TEST_DIR/bin/"
cp lib/*.sh "$TEST_DIR/lib/"
cp providers/*.sh "$TEST_DIR/providers/"

# Create a test config file
mkdir -p "$TEST_DIR/.config/curllm"
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# curllm configuration
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
EOF

echo "Debugging argument parsing..."

# Test --provider option
echo "=== Testing --provider option ==="
set +e
MOCK_MODE=true XDG_CONFIG_HOME="$TEST_DIR/.config" "$TEST_DIR/bin/curllm" chat --provider qwen "test prompt" > /tmp/debug_provider.txt 2>&1
exit_code=$?
set -e
echo "Exit code: $exit_code"
echo "Output:"
cat /tmp/debug_provider.txt
echo ""

# Check if MOCK_MODE is being recognized
echo "=== Checking MOCK_MODE ==="
echo "MOCK_MODE is set to: ${MOCK_MODE:-not set}"