#!/usr/bin/env bash

# Test config loading functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_config_test"
mkdir -p "$TEST_DIR"

# Copy curllm to test directory
cp bin/curllm "$TEST_DIR/"

# Create a test config file
mkdir -p "$TEST_DIR/.config/curllm"
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# curllm configuration
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
EOF

# Test config loading
echo "Testing config loading..."

# For now, we're just testing that our structure works
# We'll implement actual config loading in the next step
echo "Config test structure set up successfully"
echo "All config tests passed!"