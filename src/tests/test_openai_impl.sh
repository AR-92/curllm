#!/usr/bin/env bash

# Test OpenAI provider implementation

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_openai_impl_test"
mkdir -p "$TEST_DIR"

# Copy curllm, lib, and providers to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

# Create a test config file with API key
mkdir -p "$TEST_DIR/.config/curllm"
cat > "$TEST_DIR/.config/curllm/config" << 'EOF'
# curllm configuration
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
OPENAI_API_KEY=sk-test123456789
EOF

# Test that OpenAI provider functions work
echo "Testing OpenAI provider implementation..."

# Source the provider directly and test functions
source "$TEST_DIR/lib/config.sh"
source "$TEST_DIR/lib/security.sh"
source "$TEST_DIR/providers/openai.sh"

export XDG_CONFIG_HOME="$TEST_DIR/.config"

# Load config
load_config

# Test that the API key is loaded correctly
api_key=$(get_api_key "openai")
if [[ "$api_key" == "sk-test123456789" ]]; then
    echo "PASS: API key loaded correctly"
else
    echo "FAIL: API key not loaded correctly. Got: $api_key"
    exit 1
fi

# Test that the openai_chat_completion function exists
if declare -f openai_chat_completion >/dev/null; then
    echo "PASS: openai_chat_completion function exists"
else
    echo "FAIL: openai_chat_completion function not found"
    exit 1
fi

echo "All OpenAI provider implementation tests passed!"