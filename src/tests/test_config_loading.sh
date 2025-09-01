#!/usr/bin/env bash

# Test config loading functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_config_test"
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
DEFAULT_PROVIDER=anthropic
DEFAULT_MODEL=claude-2
EOF

# Test config loading by directly sourcing and running functions
echo "Testing config loading directly..."

# Source the script and config
source "$TEST_DIR/lib/config.sh"

# Set the XDG_CONFIG_HOME to point to our test config
XDG_CONFIG_HOME="$TEST_DIR/.config"

# Load config
load_config

# Check the values
if [[ "$DEFAULT_PROVIDER" == "anthropic" ]]; then
    echo "PASS: DEFAULT_PROVIDER loaded correctly"
else
    echo "FAIL: DEFAULT_PROVIDER not loaded correctly. Got: $DEFAULT_PROVIDER"
    exit 1
fi

if [[ "$DEFAULT_MODEL" == "claude-2" ]]; then
    echo "PASS: DEFAULT_MODEL loaded correctly"
else
    echo "FAIL: DEFAULT_MODEL not loaded correctly. Got: $DEFAULT_MODEL"
    exit 1
fi

echo "All direct config loading tests passed!"