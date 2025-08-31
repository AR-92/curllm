#!/usr/bin/env bash

# Debug config loading

set -euo pipefail

# Source our config library
LIB_DIR="/home/rana/Documents/Projects/curllm/lib"
source "$LIB_DIR/config.sh"

# Create a test config file
TEST_DIR="/tmp/curllm_debug"
mkdir -p "$TEST_DIR/.config/curllm"
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# curllm configuration
DEFAULT_PROVIDER=anthropic
DEFAULT_MODEL=claude-2
EOF

# Set XDG_CONFIG_HOME to our test directory
export XDG_CONFIG_HOME="$TEST_DIR/.config"

echo "Before loading config:"
echo "DEFAULT_PROVIDER: $DEFAULT_PROVIDER"
echo "DEFAULT_MODEL: $DEFAULT_MODEL"

# Load configuration
load_config

echo "After loading config:"
echo "DEFAULT_PROVIDER: $DEFAULT_PROVIDER"
echo "DEFAULT_MODEL: $DEFAULT_MODEL"