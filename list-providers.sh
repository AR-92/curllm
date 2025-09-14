#!/usr/bin/env bash

# Script to list all integrated LLM providers and check which ones are configured

echo "=== curllm Integrated LLM Providers ==="
echo ""

# List all providers integrated in the project
echo "Integrated Providers:"
echo "  1. openai      - OpenAI GPT models"
echo "  2. anthropic   - Anthropic Claude models"
echo "  3. qwen        - Alibaba Qwen models"
echo "  4. mistral     - Mistral AI models"
echo "  5. gemini      - Google Gemini models"
echo "  6. openrouter  - OpenRouter models"
echo "  7. groq        - Groq models"
echo ""

# Check configuration file
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/curllm/config"

if [[ -f "$CONFIG_FILE" ]]; then
    echo "Configuration File: $CONFIG_FILE"
    echo ""
    
    # Check which providers are configured with API keys
    echo "Configured Providers:"
    
    # Read the config file
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ "$key" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$key" ]] && continue
        
        # Trim whitespace
        key=$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        
        case "$key" in
            "OPENAI_API_KEY")
                if [[ -n "$value" ]]; then
                    echo "  ✓ openai      - API key configured"
                else
                    echo "  ✗ openai      - No API key"
                fi
                ;;
            "ANTHROPIC_API_KEY")
                if [[ -n "$value" ]]; then
                    echo "  ✓ anthropic   - API key configured"
                else
                    echo "  ✗ anthropic   - No API key"
                fi
                ;;
            "QWEN_API_KEY")
                if [[ -n "$value" ]]; then
                    echo "  ✓ qwen        - API key configured"
                else
                    echo "  ✗ qwen        - No API key"
                fi
                ;;
            "MISTRAL_API_KEY")
                if [[ -n "$value" ]]; then
                    echo "  ✓ mistral     - API key configured"
                else
                    echo "  ✗ mistral     - No API key"
                fi
                ;;
            "GEMINI_API_KEY")
                if [[ -n "$value" ]]; then
                    echo "  ✓ gemini      - API key configured"
                else
                    echo "  ✗ gemini      - No API key"
                fi
                ;;
            "OPENROUTER_API_KEY")
                if [[ -n "$value" ]]; then
                    echo "  ✓ openrouter  - API key configured"
                else
                    echo "  ✗ openrouter  - No API key"
                fi
                ;;
            "GROQ_API_KEY")
                if [[ -n "$value" ]]; then
                    echo "  ✓ groq        - API key configured"
                else
                    echo "  ✗ groq        - No API key"
                fi
                ;;
            "DEFAULT_PROVIDER")
                echo "  Default Provider: $value"
                ;;
            "DEFAULT_MODEL")
                echo "  Default Model: $value"
                ;;
        esac
    done < "$CONFIG_FILE"
else
    echo "Configuration file not found: $CONFIG_FILE"
    echo "Please create a configuration file with your API keys."
fi

echo ""
echo "=== Usage Examples ==="
echo "curllm chat \"Your prompt here\"                    # Uses default provider"
echo "curllm chat --provider gemini \"Your prompt\"       # Uses specific provider"
echo "MOCK_MODE=true curllm chat \"Test prompt\"         # Test without API keys"