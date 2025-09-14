#!/usr/bin/env bash

# curllm-config-manager.sh - Manage API keys for curllm

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration file location
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/curllm"
CONFIG_FILE="$CONFIG_DIR/config"

# Provider information
declare -A PROVIDERS=(
    ["openai"]="OpenAI GPT models"
    ["anthropic"]="Anthropic Claude models"
    ["qwen"]="Alibaba Qwen models"
    ["mistral"]="Mistral AI models"
    ["gemini"]="Google Gemini models"
    ["openrouter"]="OpenRouter models"
    ["groq"]="Groq models"
)

# Default values
DEFAULT_PROVIDER="gemini"
DEFAULT_MODEL="gemini-1.5-flash"

# Function to print header
print_header() {
    echo -e "${BLUE}=== curllm Configuration Manager ===${NC}"
    echo
}

# Function to print error
print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

# Function to print success
print_success() {
    echo -e "${GREEN}$1${NC}"
}

# Function to print info
print_info() {
    echo -e "${YELLOW}$1${NC}"
}

# Function to ensure config directory exists
ensure_config_dir() {
    mkdir -p "$CONFIG_DIR"
    chmod 700 "$CONFIG_DIR" 2>/dev/null || true
}

# Function to load current configuration
load_config() {
    declare -gA config_keys=()
    declare -g current_default_provider="$DEFAULT_PROVIDER"
    declare -g current_default_model="$DEFAULT_MODEL"
    
    if [[ -f "$CONFIG_FILE" ]]; then
        while IFS='=' read -r key value; do
            # Skip comments and empty lines
            [[ "$key" =~ ^[[:space:]]*# ]] && continue
            [[ -z "$key" ]] && continue
            
            # Trim whitespace
            key=$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            value=$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
            
            case "$key" in
                "DEFAULT_PROVIDER") current_default_provider="$value" ;;
                "DEFAULT_MODEL") current_default_model="$value" ;;
                *) config_keys["$key"]="$value" ;;
            esac
        done < "$CONFIG_FILE"
    fi
}

# Function to save configuration
save_config() {
    ensure_config_dir
    
    # Create temporary file
    local temp_file=$(mktemp)
    
    # Write header
    echo "# curllm configuration file" > "$temp_file"
    echo "# Generated on $(date)" >> "$temp_file"
    echo "" >> "$temp_file"
    
    # Write default settings
    echo "DEFAULT_PROVIDER=$current_default_provider" >> "$temp_file"
    echo "DEFAULT_MODEL=$current_default_model" >> "$temp_file"
    echo "" >> "$temp_file"
    
    # Write API keys (only non-empty ones)
    for key in "${!config_keys[@]}"; do
        if [[ -n "${config_keys[$key]}" ]]; then
            echo "$key=${config_keys[$key]}" >> "$temp_file"
        fi
    done
    
    # Move to final location
    mv "$temp_file" "$CONFIG_FILE"
    chmod 600 "$CONFIG_FILE"
    
    print_success "Configuration saved to $CONFIG_FILE"
}

# Function to list current configuration
list_config() {
    print_header
    echo "Current Configuration:"
    echo "======================"
    echo
    
    if [[ -f "$CONFIG_FILE" ]]; then
        echo "Configuration File: $CONFIG_FILE"
        echo "File Permissions: $(ls -l "$CONFIG_FILE" | awk '{print $1}')"
        echo
        echo "Settings:"
        echo "  Default Provider: $current_default_provider"
        echo "  Default Model: $current_default_model"
        echo
        echo "Configured API Keys:"
        
        local has_keys=false
        for provider in "${!PROVIDERS[@]}"; do
            local key_var="${provider^^}_API_KEY"
            key_var="${key_var//-/_}"  # Replace dashes with underscores
            
            if [[ -n "${config_keys[$key_var]:-}" ]]; then
                echo "  ✓ $provider - Configured (ends with: ...${config_keys[$key_var]: -4})"
                has_keys=true
            else
                echo "  ✗ $provider - Not configured"
            fi
        done
        
        if [[ "$has_keys" == false ]]; then
            echo "  No API keys configured"
        fi
    else
        echo "Configuration file not found: $CONFIG_FILE"
        echo "Run this script to create one."
    fi
    echo
}

# Function to add/update API key
add_key() {
    local provider="$1"
    local api_key="$2"
    
    # Validate provider
    if [[ -z "${PROVIDERS[$provider]:-}" ]]; then
        print_error "Invalid provider: $provider"
        echo "Valid providers: ${!PROVIDERS[@]}"
        return 1
    fi
    
    # Validate API key
    if [[ -z "$api_key" ]]; then
        print_error "API key cannot be empty"
        return 1
    fi
    
    # Set the key
    local key_var="${provider^^}_API_KEY"
    key_var="${key_var//-/_}"  # Replace dashes with underscores
    config_keys["$key_var"]="$api_key"
    
    print_success "API key for $provider has been set"
}

# Function to remove API key
remove_key() {
    local provider="$1"
    
    # Validate provider
    if [[ -z "${PROVIDERS[$provider]:-}" ]]; then
        print_error "Invalid provider: $provider"
        echo "Valid providers: ${!PROVIDERS[@]}"
        return 1
    fi
    
    # Remove the key
    local key_var="${provider^^}_API_KEY"
    key_var="${key_var//-/_}"  # Replace dashes with underscores
    
    if [[ -n "${config_keys[$key_var]:-}" ]]; then
        unset "config_keys[$key_var]"
        print_success "API key for $provider has been removed"
    else
        print_info "No API key found for $provider"
    fi
}

# Function to set default provider
set_default_provider() {
    local provider="$1"
    
    # Validate provider
    if [[ -z "${PROVIDERS[$provider]:-}" ]]; then
        print_error "Invalid provider: $provider"
        echo "Valid providers: ${!PROVIDERS[@]}"
        return 1
    fi
    
    current_default_provider="$provider"
    print_success "Default provider set to $provider"
}

# Function to set default model
set_default_model() {
    local model="$1"
    
    if [[ -z "$model" ]]; then
        print_error "Model name cannot be empty"
        return 1
    fi
    
    current_default_model="$model"
    print_success "Default model set to $model"
}

# Function to interactively add a key
interactive_add_key() {
    echo "Available Providers:"
    local i=1
    local provider_list=()
    for provider in "${!PROVIDERS[@]}"; do
        echo "  $i. $provider - ${PROVIDERS[$provider]}"
        provider_list+=("$provider")
        ((i++))
    done
    echo
    
    read -p "Select provider (1-${#provider_list[@]}): " selection
    
    if ! [[ "$selection" =~ ^[0-9]+$ ]] || [[ "$selection" -lt 1 ]] || [[ "$selection" -gt "${#provider_list[@]}" ]]; then
        print_error "Invalid selection"
        return 1
    fi
    
    local selected_provider="${provider_list[$((selection-1))]}"
    
    # Check if key already exists
    local key_var="${selected_provider^^}_API_KEY"
    key_var="${key_var//-/_}"
    if [[ -n "${config_keys[$key_var]:-}" ]]; then
        echo "API key for $selected_provider already exists (ends with: ...${config_keys[$key_var]: -4})"
        read -p "Do you want to overwrite it? (y/N): " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            print_info "Operation cancelled"
            return 0
        fi
    fi
    
    read -s -p "Enter API key for $selected_provider: " api_key
    echo
    
    if [[ -z "$api_key" ]]; then
        print_error "API key cannot be empty"
        return 1
    fi
    
    add_key "$selected_provider" "$api_key"
}

# Function to interactively remove a key
interactive_remove_key() {
    echo "Configured Providers:"
    local i=1
    local provider_list=()
    local has_configured_keys=false
    
    for provider in "${!PROVIDERS[@]}"; do
        local key_var="${provider^^}_API_KEY"
        key_var="${key_var//-/_}"
        if [[ -n "${config_keys[$key_var]:-}" ]]; then
            echo "  $i. $provider - Configured (ends with: ...${config_keys[$key_var]: -4})"
            provider_list+=("$provider")
            has_configured_keys=true
            ((i++))
        fi
    done
    
    if [[ "$has_configured_keys" == false ]]; then
        print_info "No providers have configured API keys"
        return 0
    fi
    
    echo
    read -p "Select provider to remove key (1-${#provider_list[@]}): " selection
    
    if ! [[ "$selection" =~ ^[0-9]+$ ]] || [[ "$selection" -lt 1 ]] || [[ "$selection" -gt "${#provider_list[@]}" ]]; then
        print_error "Invalid selection"
        return 1
    fi
    
    local selected_provider="${provider_list[$((selection-1))]}"
    
    read -p "Are you sure you want to remove the API key for $selected_provider? (y/N): " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_info "Operation cancelled"
        return 0
    fi
    
    remove_key "$selected_provider"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo
    echo "Commands:"
    echo "  list                    List current configuration"
    echo "  add <provider> <key>    Add/update API key for provider"
    echo "  remove <provider>       Remove API key for provider"
    echo "  set-default <provider>  Set default provider"
    echo "  set-model <model>       Set default model"
    echo "  interactive             Interactive configuration mode"
    echo "  help                    Show this help message"
    echo
    echo "Providers:"
    for provider in "${!PROVIDERS[@]}"; do
        echo "  $provider - ${PROVIDERS[$provider]}"
    done
    echo
    echo "Examples:"
    echo "  $0 list"
    echo "  $0 add openai sk-your-openai-key"
    echo "  $0 remove anthropic"
    echo "  $0 set-default qwen"
    echo "  $0 set-model gemini-1.5-pro"
    echo "  $0 interactive"
}

# Function for interactive mode
interactive_mode() {
    while true; do
        print_header
        list_config
        
        echo "Configuration Options:"
        echo "  1. Add/update API key"
        echo "  2. Remove API key"
        echo "  3. Set default provider"
        echo "  4. Set default model"
        echo "  5. Save and exit"
        echo "  6. Exit without saving"
        echo
        
        read -p "Select option (1-6): " choice
        
        case "$choice" in
            1)
                echo
                interactive_add_key
                echo
                read -p "Press Enter to continue..."
                ;;
            2)
                echo
                interactive_remove_key
                echo
                read -p "Press Enter to continue..."
                ;;
            3)
                echo
                echo "Available Providers:"
                local i=1
                for provider in "${!PROVIDERS[@]}"; do
                    echo "  $i. $provider - ${PROVIDERS[$provider]}"
                    ((i++))
                done
                echo
                read -p "Enter provider to set as default: " provider
                set_default_provider "$provider"
                echo
                read -p "Press Enter to continue..."
                ;;
            4)
                echo
                read -p "Enter model to set as default: " model
                set_default_model "$model"
                echo
                read -p "Press Enter to continue..."
                ;;
            5)
                save_config
                return 0
                ;;
            6)
                print_info "Exiting without saving"
                return 0
                ;;
            *)
                print_error "Invalid option: $choice"
                echo
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# Main function
main() {
    # Load current configuration
    load_config
    
    # Parse command line arguments
    if [[ $# -eq 0 ]]; then
        list_config
        return 0
    fi
    
    local command="$1"
    shift
    
    case "$command" in
        list)
            list_config
            ;;
        add)
            if [[ $# -ne 2 ]]; then
                print_error "Usage: $0 add <provider> <key>"
                return 1
            fi
            add_key "$1" "$2"
            save_config
            ;;
        remove)
            if [[ $# -ne 1 ]]; then
                print_error "Usage: $0 remove <provider>"
                return 1
            fi
            remove_key "$1"
            save_config
            ;;
        set-default)
            if [[ $# -ne 1 ]]; then
                print_error "Usage: $0 set-default <provider>"
                return 1
            fi
            set_default_provider "$1"
            save_config
            ;;
        set-model)
            if [[ $# -ne 1 ]]; then
                print_error "Usage: $0 set-model <model>"
                return 1
            fi
            set_default_model "$1"
            save_config
            ;;
        interactive)
            interactive_mode
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            print_error "Unknown command: $command"
            show_usage
            return 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"