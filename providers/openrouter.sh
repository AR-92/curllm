#!/usr/bin/env bash

# openrouter.sh - OpenRouter provider for curllm

# Function to send a chat completion request to OpenRouter
openrouter_chat_completion() {
    local prompt="$1"
    local model="${2:-openrouter/auto}"
    
    # Check if we're in mock mode
    if [[ "${MOCK_MODE:-false}" == "true" ]]; then
        echo "This is a mock response from OpenRouter for prompt: $prompt"
        return 0
    fi
    
    # Get API key
    local api_key
    api_key=$(get_api_key "openrouter")
    
    # Validate API key
    if [[ -z "$api_key" ]]; then
        echo "Error: No OpenRouter API key found" >&2
        return 1
    fi
    
    # Create JSON payload
    local payload
    payload=$(jq -n \
        --arg model "$model" \
        --arg prompt "$prompt" \
        '{
            model: $model,
            messages: [
                {
                    role: "user",
                    content: $prompt
                }
            ]
        }')
    
    # Make API request
    local response
    response=$(curl -s -w "\n%{http_code}" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $api_key" \
        -H "HTTP-Referer: https://github.com/yourusername/curllm" \
        -H "X-Title: curllm" \
        -d "$payload" \
        "https://openrouter.ai/api/v1/chat/completions")
    
    # Extract HTTP status code
    local http_code
    http_code=$(echo "$response" | tail -n1)
    
    # Extract response body
    local body
    body=$(echo "$response" | head -n -1)
    
    # Check for HTTP errors
    if [[ "$http_code" -ne 200 ]]; then
        echo "Error: OpenRouter API request failed with status $http_code" >&2
        echo "$body" >&2
        return 1
    fi
    
    # Extract and return the response text
    echo "$body" | jq -r '.choices[0].message.content'
}