#!/usr/bin/env bash

# Example usage of curllm

set -euo pipefail

# This is an example of how to use curllm
# It demonstrates the basic functionality

echo "=== curllm Example Usage ==="

# Create a config directory and file
mkdir -p ~/.config/curllm

# Create a config file (you would fill in your actual API keys)
cat > ~/.config/curllm/config << 'EOF'
# curllm configuration
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo
# OPENAI_API_KEY=sk-your-actual-key-here
EOF

echo "Created example config file at ~/.config/curllm/config"

# Show how to use curllm in mock mode (no API key needed)
echo ""
echo "=== Using curllm in mock mode ==="
MOCK_MODE=true /home/rana/Documents/Projects/curllm/bin/curllm chat "What is the capital of France?"

echo ""
echo "=== Using curllm with a different provider in mock mode ==="
# To use a different provider, you would modify the config file
# For this example, we'll just show the command
echo "To use Qwen:"
echo "  Edit ~/.config/curllm/config to set DEFAULT_PROVIDER=qwen"
echo "  Then run: MOCK_MODE=true /home/rana/Documents/Projects/curllm/bin/curllm chat \"What is the capital of France?\""

echo ""
echo "=== Example complete ==="