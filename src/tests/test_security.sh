#!/usr/bin/env bash

# Test security functionality

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_security_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
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

# Test that API keys are handled correctly
echo "Testing security functionality..."

# Test that the API key is loaded correctly
source "$TEST_DIR/lib/security.sh"
export XDG_CONFIG_HOME="$TEST_DIR/.config"

api_key=$(get_api_key "openai")
if [[ "$api_key" == "sk-test123456789" ]]; then
    echo "PASS: API key loaded correctly"
else
    echo "FAIL: API key not loaded correctly. Got: $api_key"
    exit 1
fi

# Test validation function
if validate_api_key "openai" >/dev/null 2>&1; then
    echo "PASS: API key validation passed"
else
    echo "FAIL: API key validation failed"
    exit 1
fi

# Test validation with missing key
if ! validate_api_key "anthropic" >/dev/null 2>&1; then
    echo "PASS: API key validation correctly failed for missing key"
else
    echo "FAIL: API key validation should have failed for missing key"
    exit 1
fi

echo "All security tests passed!"