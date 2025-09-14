#!/usr/bin/env bash

# anthropic.sh - Anthropic provider for curllm

# Function to list available models for Anthropic
anthropic_list_models() {
    # Check if we're in mock mode
    if [[ "${MOCK_MODE:-false}" == "true" ]]; then
        echo "claude-3-opus-20240229 (mock)"
        echo "claude-3-sonnet-20240229 (mock)"
        echo "claude-3-haiku-20240307 (mock)"
        echo "claude-2.1 (mock)"
        echo "claude-2.0 (mock)"
        echo "claude-instant-1.2 (mock)"
        return 0
    fi
    
    # Get API key
    local api_key
    api_key=$(get_api_key "anthropic")
    
    # Validate API key
    if [[ -z "$api_key" ]]; then
        echo "Error: No Anthropic API key found" >&2
        return 1
    fi
    
    # For Anthropic, we'll return a static list since there's no API to list models
    echo "claude-3-opus-20240229"
    echo "claude-3-sonnet-20240229"
    echo "claude-3-haiku-20240307"
    echo "claude-2.1"
    echo "claude-2.0"
    echo "claude-instant-1.2"
}

# Function to send a chat completion request to Anthropic
anthropic_chat_completion() {
    local prompt="$1"
    local model="${2:-claude-2}"
    
    # Check if we're in mock mode
    if [[ "${MOCK_MODE:-false}" == "true" ]]; then
        echo "This is a mock response from Anthropic for prompt: $prompt"
        return 0
    fi
    
    # Get API key
    local api_key
    api_key=$(get_api_key "anthropic")
    
    # Validate API key
    if [[ -z "$api_key" ]]; then
        echo "Error: No Anthropic API key found" >&2
        return 1
    fi
    
    # Create JSON payload
    local payload
    payload=$(jq -n \
        --arg model "$model" \
        --arg prompt "$prompt" \
        '{
            model: $model,
            prompt: $prompt,
            max_tokens_to_sample: 1000
        }')
    
    # Make API request
    local response
    response=$(curl -s -w "\n%{http_code}" \
        -H "Content-Type: application/json" \
        -H "x-api-key: $api_key" \
        -d "$payload" \
        "https://api.anthropic.com/v1/complete")
    
    # Extract HTTP status code
    local http_code
    http_code=$(echo "$response" | tail -n1)
    
    # Extract response body
    local body
    body=$(echo "$response" | head -n -1)
    
    # Check for HTTP errors
    if [[ "$http_code" -ne 200 ]]; then
        echo "Error: Anthropic API request failed with status $http_code" >&2
        echo "$body" >&2
        return 1
    fi
    
    # Extract and return the response text
    echo "$body" | jq -r '.completion'
}