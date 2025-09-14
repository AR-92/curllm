#!/usr/bin/env bash

# Test library functions

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_lib_test"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp bin/curllm "$TEST_DIR/bin/"
cp lib/*.sh "$TEST_DIR/lib/"
cp providers/*.sh "$TEST_DIR/providers/"

echo "Testing library functions..."

# Test config library functions
source "$TEST_DIR/lib/config.sh"

# Test load_config with no config file
XDG_CONFIG_HOME="$TEST_DIR/.config"
load_config

if [[ "$DEFAULT_PROVIDER" == "openai" ]]; then
    echo "PASS: load_config correctly sets default provider"
else
    echo "FAIL: load_config did not correctly set default provider"
    echo "DEFAULT_PROVIDER: $DEFAULT_PROVIDER"
    exit 1
fi

if [[ "$DEFAULT_MODEL" == "gpt-3.5-turbo" ]]; then
    echo "PASS: load_config correctly sets default model"
else
    echo "FAIL: load_config did not correctly set default model"
    echo "DEFAULT_MODEL: $DEFAULT_MODEL"
    exit 1
fi

# Test security library functions
source "$TEST_DIR/lib/security.sh"

# Test get_api_key with no config file
api_key=$(get_api_key "openai")

if [[ -z "$api_key" ]]; then
    echo "PASS: get_api_key correctly returns empty string for missing key"
else
    echo "FAIL: get_api_key should return empty string for missing key"
    echo "api_key: $api_key"
    exit 1
fi

echo "All library function tests passed!"