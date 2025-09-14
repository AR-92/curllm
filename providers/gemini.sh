#!/usr/bin/env bash

# gemini.sh - Google Gemini provider for curllm

# Function to list available models for Google Gemini
gemini_list_models() {
    # Check if we're in mock mode
    if [[ "${MOCK_MODE:-false}" == "true" ]]; then
        echo "gemini-1.5-pro-latest (mock)"
        echo "gemini-1.5-pro (mock)"
        echo "gemini-1.5-flash-latest (mock)"
        echo "gemini-1.5-flash (mock)"
        echo "gemini-1.0-pro (mock)"
        echo "gemini-pro (mock)"
        echo "gemini-pro-vision (mock)"
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
    
    # Make API request to list models
    local response
    response=$(curl -s "https://generativelanguage.googleapis.com/v1beta/models?key=$api_key")
    
    # Check if we got a valid response
    if echo "$response" | jq -e .models >/dev/null 2>&1; then
        # Extract and list model names
        echo "$response" | jq -r '.models[].name' | sed 's/models\///'
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
}

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