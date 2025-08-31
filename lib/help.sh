#!/usr/bin/env bash

# help.sh - Help system for curllm

# Function to display general help
show_help() {
    echo "curllm - A pure Bash LLM API wrapper"
    echo ""
    echo "Usage: curllm [command] [options]"
    echo ""
    echo "Commands:"
    echo "  chat <prompt>     Send a chat completion request"
    echo "  search <query>    Search the web for information"
    echo "  help              Show this help message"
    echo "  version           Show version information"
    echo ""
    echo "Options:"
    echo "  --provider <name>     Specify provider (openai, anthropic, qwen, groq, google, gemini, openrouter)"
    echo "  --model <name>        Specify model"
    echo "  --mock               Use mock mode (no real API calls)"
    echo "  --help               Show help for a specific command"
    echo "  --version            Show version information"
    echo ""
    echo "Configuration:"
    echo "  Config file: ~/.config/curllm/config"
    echo "  See .env.example for configuration options"
    echo ""
    echo "Examples:"
    echo "  curllm chat \"What is the capital of France?\""
    echo "  curllm search \"latest news about AI\""
    echo "  curllm chat --provider groq --model llama3-8b-8192 \"Hello!\""
    echo "  MOCK_MODE=true curllm chat \"Test prompt\""
}

# Function to display help for chat command
show_chat_help() {
    echo "curllm chat - Send a chat completion request"
    echo ""
    echo "Usage: curllm chat [options] <prompt>"
    echo ""
    echo "Options:"
    echo "  --provider <name>     Specify provider (openai, anthropic, qwen, groq, google, gemini, openrouter)"
    echo "  --model <name>        Specify model"
    echo "  --mock               Use mock mode (no real API calls)"
    echo ""
    echo "Examples:"
    echo "  curllm chat \"What is the capital of France?\""
    echo "  curllm chat --provider groq --model llama3-8b-8192 \"Hello!\""
    echo "  MOCK_MODE=true curllm chat \"Test prompt\""
}

# Function to display help for search command
show_search_help() {
    echo "curllm search - Search the web for information"
    echo ""
    echo "Usage: curllm search [options] <query>"
    echo ""
    echo "Options:"
    echo "  --provider <name>     Specify provider (openai, anthropic, qwen, groq, google, gemini, openrouter)"
    echo "  --model <name>        Specify model"
    echo "  --mock               Use mock mode (no real API calls)"
    echo ""
    echo "Examples:"
    echo "  curllm search \"latest news about AI\""
    echo "  curllm search --provider google \"weather in New York\""
}

# Function to display version information
show_version() {
    echo "curllm v1.0.0"
    echo "A pure Bash LLM API wrapper"
}