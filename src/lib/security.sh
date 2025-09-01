#!/usr/bin/env bash

# security.sh - API key handling for curllm

# Function to get API key for a provider
get_api_key() {
    local provider="$1"
    local api_key=""
    
    # Config file location
    local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/curllm/config"
    
    # Check if config file exists
    if [[ -f "$config_file" ]]; then
        # Parse key=value pairs
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            [[ "$key" =~ ^[[:space:]]*# ]] && continue
            [[ -z "$key" ]] && continue
            
            # Trim whitespace
            key=$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            
            # Check if this is the API key we're looking for
            case "$provider" in
                "openai")
                    if [[ "$key" == "OPENAI_API_KEY" ]]; then
                        api_key="$value"
                    fi
                    ;;
                "anthropic")
                    if [[ "$key" == "ANTHROPIC_API_KEY" ]]; then
                        api_key="$value"
                    fi
                    ;;
                "qwen")
                    if [[ "$key" == "QWEN_API_KEY" ]]; then
                        api_key="$value"
                    fi
                    ;;
                "mistral")
                    if [[ "$key" == "MISTRAL_API_KEY" ]]; then
                        api_key="$value"
                    fi
                    ;;
                "gemini")
                    if [[ "$key" == "GEMINI_API_KEY" ]]; then
                        api_key="$value"
                    fi
                    ;;
                "openrouter")
                    if [[ "$key" == "OPENROUTER_API_KEY" ]]; then
                        api_key="$value"
                    fi
                    ;;
                "groq")
                    if [[ "$key" == "GROQ_API_KEY" ]]; then
                        api_key="$value"
                    fi
                    ;;
            esac
        done < "$config_file"
    fi
    
    echo "$api_key"
}

# Function to validate that an API key is present
validate_api_key() {
    local provider="$1"
    local api_key
    api_key=$(get_api_key "$provider")
    
    if [[ -z "$api_key" ]]; then
        echo "Error: No API key found for provider '$provider'" >&2
        echo "Please add your API key to ${XDG_CONFIG_HOME:-$HOME/.config}/curllm/config" >&2
        return 1
    fi
    
    return 0
}