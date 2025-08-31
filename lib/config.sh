#!/usr/bin/env bash

# config.sh - Configuration loading for curllm

# Initialize default values
DEFAULT_PROVIDER="openai"
DEFAULT_MODEL="gpt-3.5-turbo"

# Function to load configuration
load_config() {
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
            
            # Set variables
            case "$key" in
                "DEFAULT_PROVIDER") DEFAULT_PROVIDER="$value" ;;
                "DEFAULT_MODEL") DEFAULT_MODEL="$value" ;;
            esac
        done < "$config_file"
    fi
}