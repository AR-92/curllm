#!/usr/bin/env bash

# openai.sh - OpenAI provider for curllm

# Function to send a chat completion request to OpenAI
openai_chat_completion() {
    local prompt="$1"
    local model="${2:-gpt-3.5-turbo}"
    
    # Check if we're in mock mode
    if [[ "${MOCK_MODE:-false}" == "true" ]]; then
        echo "This is a mock response from OpenAI for prompt: $prompt"
        return 0
    fi
    
    # Get API key
    local api_key
    api_key=$(get_api_key "openai")
    
    # Validate API key
    if [[ -z "$api_key" ]]; then
        echo "Error: No OpenAI API key found" >&2
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
        -d "$payload" \
        "https://api.openai.com/v1/chat/completions")
    
    # Extract HTTP status code
    local http_code
    http_code=$(echo "$response" | tail -n1)
    
    # Extract response body
    local body
    body=$(echo "$response" | head -n -1)
    
    # Check for HTTP errors
    if [[ "$http_code" -ne 200 ]]; then
        echo "Error: OpenAI API request failed with status $http_code" >&2
        echo "$body" >&2
        return 1
    fi
    
    # Extract and return the response text
    echo "$body" | jq -r '.choices[0].message.content'
}