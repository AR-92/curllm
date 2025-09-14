#!/usr/bin/env bash

# models.sh - Model management functions for curllm

# Source our libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$SCRIPT_DIR"
PROVIDERS_DIR="$(dirname "$LIB_DIR")/providers"

# Source required libraries
if [[ -f "$LIB_DIR/config.sh" ]]; then
    source "$LIB_DIR/config.sh"
fi

if [[ -f "$LIB_DIR/security.sh" ]]; then
    source "$LIB_DIR/security.sh"
fi

if [[ -f "$LIB_DIR/logging.sh" ]]; then
    source "$LIB_DIR/logging.sh"
fi

# Function to list models for a provider
list_models() {
    local provider="$1"
    
    # Source the provider module
    local provider_file="$PROVIDERS_DIR/${provider}.sh"
    if [[ -f "$provider_file" ]]; then
        source "$provider_file"
    else
        echo "Error: Provider '$provider' not supported" >&2
        return 1
    fi
    
    # Call the provider-specific function
    case "$provider" in
        openai)
            if declare -f openai_list_models >/dev/null; then
                openai_list_models
            else
                # Fallback to static list
                echo "gpt-4-turbo"
                echo "gpt-4"
                echo "gpt-4-32k"
                echo "gpt-3.5-turbo"
                echo "gpt-3.5-turbo-16k"
            fi
            ;;
        qwen)
            if declare -f qwen_list_models >/dev/null; then
                qwen_list_models
            else
                # Fallback to static list
                echo "qwen-turbo"
                echo "qwen-plus"
                echo "qwen-max"
                echo "qwen-max-longcontext"
            fi
            ;;
        anthropic)
            if declare -f anthropic_list_models >/dev/null; then
                anthropic_list_models
            else
                # Fallback to static list
                echo "claude-3-opus-20240229"
                echo "claude-3-sonnet-20240229"
                echo "claude-3-haiku-20240307"
                echo "claude-2.1"
                echo "claude-2.0"
                echo "claude-instant-1.2"
            fi
            ;;
        mistral)
            if declare -f mistral_list_models >/dev/null; then
                mistral_list_models
            else
                # Fallback to static list
                echo "mistral-large-latest"
                echo "mistral-medium"
                echo "mistral-small"
                echo "mistral-tiny"
                echo "open-mistral-7b"
                echo "open-mixtral-8x7b"
                echo "open-mixtral-8x22b"
            fi
            ;;
        gemini)
            if declare -f gemini_list_models >/dev/null; then
                gemini_list_models
            else
                # Fallback to static list
                echo "gemini-1.5-pro-latest"
                echo "gemini-1.5-pro"
                echo "gemini-1.5-flash-latest"
                echo "gemini-1.5-flash"
                echo "gemini-1.0-pro"
                echo "gemini-pro"
                echo "gemini-pro-vision"
            fi
            ;;
        openrouter)
            if declare -f openrouter_list_models >/dev/null; then
                openrouter_list_models
            else
                # Fallback to static list
                echo "openrouter/auto"
                echo "openai/gpt-4-turbo"
                echo "openai/gpt-4"
                echo "openai/gpt-3.5-turbo"
                echo "anthropic/claude-3-opus"
                echo "anthropic/claude-3-sonnet"
                echo "anthropic/claude-3-haiku"
                echo "meta-llama/llama-3-70b-instruct"
                echo "meta-llama/llama-3-8b-instruct"
                echo "mistralai/mistral-7b-instruct"
                echo "mistralai/mixtral-8x7b-instruct"
                echo "google/gemini-pro"
                echo "google/gemini-pro-vision"
            fi
            ;;
        groq)
            if declare -f groq_list_models >/dev/null; then
                groq_list_models
            else
                # Fallback to static list
                echo "llama3-70b-8192"
                echo "llama3-8b-8192"
                echo "llama2-70b-4096"
                echo "mixtral-8x7b-32768"
                echo "gemma-7b-it"
            fi
            ;;
        *)
            echo "Error: Provider '$provider' not implemented" >&2
            return 1
            ;;
    esac
}

# Function to browse models interactively for a provider
browse_models() {
    local provider="$1"
    
    # Source the provider module
    local provider_file="$PROVIDERS_DIR/${provider}.sh"
    if [[ -f "$provider_file" ]]; then
        source "$provider_file"
    else
        echo "Error: Provider '$provider' not supported" >&2
        return 1
    fi
    
    # Get models for the provider
    local models
    models=$(list_models "$provider")
    
    # Check if we got any models
    if [[ -z "$models" ]]; then
        echo "No models found for provider: $provider"
        return 1
    fi
    
    # Convert models to array
    local model_array=()
    while IFS= read -r line; do
        # Remove any mock indicator if present
        local clean_line
        clean_line=$(echo "$line" | sed 's/ (mock)$//')
        model_array+=("$clean_line")
    done <<< "$models"
    
    # Check if we have any models
    if [[ ${#model_array[@]} -eq 0 ]]; then
        echo "No models found for provider: $provider"
        return 1
    fi
    
    echo "Interactive Model Browser for $provider"
    echo "======================================"
    echo
    
    # Display models with numbers
    local i=1
    for model in "${model_array[@]}"; do
        echo "$i. $model"
        ((i++))
    done
    
    echo
    echo "Enter the number of the model you want to select, or 'q' to quit: "
    
    # Read user input
    local choice
    read -r choice
    
    # Check if user wants to quit
    if [[ "$choice" == "q" ]] || [[ "$choice" == "Q" ]]; then
        echo "Goodbye!"
        return 0
    fi
    
    # Validate choice
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [[ "$choice" -lt 1 ]] || [[ "$choice" -gt ${#model_array[@]} ]]; then
        echo "Invalid choice. Please enter a number between 1 and ${#model_array[@]}, or 'q' to quit."
        return 1
    fi
    
    # Get selected model
    local selected_model="${model_array[$((choice-1))]}"
    
    echo
    echo "Selected model: $selected_model"
    echo
    echo "Options:"
    echo "1. Use this model for a single request"
    echo "2. Set as default model for $provider"
    echo "3. Cancel"
    echo
    echo "Enter your choice (1-3): "
    
    # Read user input
    local action
    read -r action
    
    case "$action" in
        1)
            # Use this model for a single request
            echo "Model '$selected_model' selected for single use."
            echo "To use it, run: curllm chat --provider $provider --model $selected_model \"your prompt\""
            ;;
        2)
            # Set as default model
            set_default_model "$provider" "$selected_model"
            echo "Model '$selected_model' set as default for provider '$provider'."
            ;;
        3|q|Q)
            echo "Operation cancelled."
            ;;
        *)
            echo "Invalid choice. Operation cancelled."
            ;;
    esac
}

# Function to set default model in config
set_default_model() {
    local provider="$1"
    local model="$2"
    
    # Config file location
    local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/curllm/config"
    
    # Check if config file exists
    if [[ -f "$config_file" ]]; then
        # Create a temporary file
        local temp_file=$(mktemp)
        
        # Copy all lines except DEFAULT_MODEL
        grep -v "^DEFAULT_MODEL=" "$config_file" > "$temp_file" || true
        
        # Add the new DEFAULT_MODEL
        echo "DEFAULT_MODEL=$model" >> "$temp_file"
        
        # Replace the original file
        mv "$temp_file" "$config_file"
        
        echo "Default model set to '$model' for provider '$provider'"
    else
        # Create new config file
        echo "DEFAULT_PROVIDER=$provider" > "$config_file"
        echo "DEFAULT_MODEL=$model" >> "$config_file"
        echo "Default model set to '$model' for provider '$provider'"
    fi
}