#!/usr/bin/env bash

# gemini.sh - Google Gemini provider for curllm

# Function to send a chat completion request to Google Gemini
gemini_chat_completion() {
    local prompt="$1"
    local model="${2:-gemini-pro}"
    
    # Check if we're in mock mode
    if [[ "${MOCK_MODE:-false}" == "true" ]]; then
        echo "This is a mock response from Google Gemini for prompt: $prompt"
        return 0
    fi
    
    # Get API key
    local api_key
    api_key=$(get_api_key "gemini")
    
    # Validate API key
    if [[ -z "$api_key" ]]; then
        echo "Error: No Google Gemini API key found" >&2
        return 1
    fi
    
    # Create JSON payload
    local payload
    payload=$(jq -n \
        --arg prompt "$prompt" \
        '{
            contents: [
                {
                    parts: [
                        {
                            text: $prompt
                        }
                    ]
                }
            ]
        }')
    
    # Make API request
    local response
    response=$(curl -s -w "\n%{http_code}" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$api_key")
    
    # Extract HTTP status code
    local http_code
    http_code=$(echo "$response" | tail -n1)
    
    # Extract response body
    local body
    body=$(echo "$response" | head -n -1)
    
    # Check for HTTP errors
    if [[ "$http_code" -ne 200 ]]; then
        echo "Error: Google Gemini API request failed with status $http_code" >&2
        echo "$body" >&2
        return 1
    fi
    
    # Extract and return the response text
    echo "$body" | jq -r '.candidates[0].content.parts[0].text'
}