# curllm - Comprehensive Documentation

## Table of Contents
1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Usage](#usage)
5. [Supported Providers](#supported-providers)
6. [Command Line Interface](#command-line-interface)
7. [API Key Security](#api-key-security)
8. [Mock Mode](#mock-mode)
9. [Logging](#logging)
10. [Extending curllm](#extending-curllm)
11. [Development](#development)
12. [Testing](#testing)
13. [Troubleshooting](#troubleshooting)

## Introduction

curllm is a pure Bash LLM API wrapper that allows you to interact with various LLM providers through a unified interface. It's designed to be lightweight, secure, and easily extensible.

## Installation

### Prerequisites
- Bash shell
- curl
- jq
- Basic Unix utilities (sed, awk, grep, etc.)

### Installation Steps
```bash
# Clone the repository
git clone https://github.com/yourusername/curllm.git
cd curllm

# Install (copies files to /usr/local/bin and /usr/local/lib)
sudo make install
```

### Manual Installation
If you prefer manual installation:
```bash
# Copy the main executable
sudo cp bin/curllm /usr/local/bin/

# Copy libraries and providers
sudo mkdir -p /usr/local/lib/curllm
sudo cp -r lib /usr/local/lib/curllm/
sudo cp -r providers /usr/local/lib/curllm/
```

## Configuration

### Configuration File
Create a configuration file at `~/.config/curllm/config`:

```bash
# Default provider and model
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo

# API Keys
OPENAI_API_KEY=sk-your-openai-api-key
ANTHROPIC_API_KEY=your-anthropic-api-key
QWEN_API_KEY=your-qwen-api-key
MISTRAL_API_KEY=your-mistral-api-key
GEMINI_API_KEY=your-gemini-api-key
OPENROUTER_API_KEY=your-openrouter-api-key
GROQ_API_KEY=your-groq-api-key
```

### Environment Variables
- `MOCK_MODE=true` - Enable mock mode (no real API calls)
- `XDG_CONFIG_HOME` - Config directory (default: ~/.config)
- `XDG_CACHE_HOME` - Log directory (default: ~/.cache)

## Usage

### Basic Usage
```bash
# Basic chat completion
curllm chat "What is the capital of France?"

# With specific provider and model
curllm chat --provider qwen --model qwen-turbo "Explain quantum computing"
```

### Help and Version
```bash
# Show help
curllm help
curllm --help
curllm -h

# Show version
curllm version
curllm --version
curllm -v
```

## Supported Providers

### OpenAI
- **API Base URL**: https://api.openai.com/v1/chat/completions
- **Models**: gpt-3.5-turbo, gpt-4, gpt-4-turbo, etc.
- **API Key Env Var**: OPENAI_API_KEY

### Anthropic
- **API Base URL**: https://api.anthropic.com/v1/complete
- **Models**: claude-2, claude-instant, claude-2.1, etc.
- **API Key Env Var**: ANTHROPIC_API_KEY

### Qwen (Alibaba)
- **API Base URL**: https://dashscope.aliyuncs.com/api/v1/services/aigc/text-generation/generation
- **Models**: qwen-turbo, qwen-plus, qwen-max, etc.
- **API Key Env Var**: QWEN_API_KEY

### Mistral AI
- **API Base URL**: https://api.mistral.ai/v1/chat/completions
- **Models**: mistral-tiny, mistral-small, mistral-medium, etc.
- **API Key Env Var**: MISTRAL_API_KEY

### Google Gemini
- **API Base URL**: https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent
- **Models**: gemini-pro, gemini-pro-vision, etc.
- **API Key Env Var**: GEMINI_API_KEY

### OpenRouter
- **API Base URL**: https://openrouter.ai/api/v1/chat/completions
- **Models**: openrouter/auto, openai/gpt-3.5-turbo, anthropic/claude-2, etc.
- **API Key Env Var**: OPENROUTER_API_KEY

### Groq
- **API Base URL**: https://api.groq.com/openai/v1/chat/completions
- **Models**: llama2-70b-4096, llama3-8b-8192, mixtral-8x7b-32768, etc.
- **API Key Env Var**: GROQ_API_KEY

## Command Line Interface

### Commands
- `chat <prompt>` - Send a chat completion request
- `help` - Show help message
- `version` - Show version information

### Options
- `--provider <name>` - Specify provider (openai, anthropic, qwen, mistral, gemini, openrouter, groq)
- `--model <name>` - Specify model name
- `--verbose` - Enable verbose logging
- `--help, -h` - Show help for a command
- `--version, -v` - Show version

### Examples
```bash
# Basic usage
curllm chat "What is the capital of France?"

# Specify provider
curllm chat --provider qwen "Explain quantum computing"

# Specify provider and model
curllm chat --provider groq --model llama3-8b-8192 "What is Bash?"

# Enable verbose logging
curllm chat --verbose "Debug this request"

# Multiple arguments in prompt
curllm chat --provider openai "Compare Python and JavaScript programming languages"

# Using environment variables
MOCK_MODE=true curllm chat "Test prompt"
```

## API Key Security

### Secure Storage
API keys are stored in the configuration file at `~/.config/curllm/config`. Ensure this file has appropriate permissions:

```bash
chmod 600 ~/.config/curllm/config
```

### Key Validation
curllm validates that required API keys are present before making requests. If a key is missing, it will display an error message indicating which key is needed.

### Environment Isolation
API keys are only accessible within the curllm process and are not exposed to child processes unless explicitly passed.

## Mock Mode

### Purpose
Mock mode allows you to test curllm without making real API calls, which is useful for:
- Development and testing
- Demonstrations
- Offline usage
- Avoiding API costs during development

### Usage
```bash
# Enable mock mode
MOCK_MODE=true curllm chat "Test prompt"

# Mock mode with specific provider
MOCK_MODE=true curllm chat --provider qwen "Test prompt"
```

### Behavior
In mock mode:
- No real API calls are made
- Providers return mock responses that indicate the provider name
- All functionality except actual API calls works normally

## Logging

### Log File Location
curllm logs all operations to a log file located at:
- Default: `~/.cache/curllm/curllm.log`
- Custom: `$XDG_CACHE_HOME/curllm/curllm.log`

### Log Levels
curllm supports different log levels:
- **ERROR** - Critical errors that prevent operation
- **WARN** - Warnings about potential issues
- **INFO** - General information about operations (default)
- **DEBUG** - Detailed debugging information (enabled with `--verbose`)

### Log Format
Each log entry follows this format:
```
[YYYY-MM-DD HH:MM:SS] [LEVEL] Message
```

### Example Log Entries
```
[2023-05-15 10:30:45] [INFO] curllm started with command: chat
[2023-05-15 10:30:45] [INFO] Processing chat request with provider: openai, model: gpt-3.5-turbo
[2023-05-15 10:30:46] [DEBUG] Sending prompt: What is the capital of France?
[2023-05-15 10:30:47] [INFO] Successfully received response from provider: openai
[2023-05-15 10:30:47] [INFO] curllm finished successfully
```

### Enabling Verbose Logging
To enable verbose (DEBUG level) logging, use the `--verbose` flag:
```bash
curllm chat --verbose "What is the capital of France?"
```

### Log Rotation
curllm does not currently implement log rotation. Log files may grow large over time. You can manually rotate logs by:
```bash
# Backup current log
cp ~/.cache/curllm/curllm.log ~/.cache/curllm/curllm.log.backup

# Clear current log
> ~/.cache/curllm/curllm.log
```

## Extending curllm

### Adding New Providers

To add a new provider:

1. **Create a provider script** in the `providers/` directory:
   ```bash
   # providers/newprovider.sh
   #!/usr/bin/env bash
   
   newprovider_chat_completion() {
       local prompt="$1"
       local model="${2:-default-model}"
       
       # Check if we're in mock mode
       if [[ "${MOCK_MODE:-false}" == "true" ]]; then
           echo "This is a mock response from NewProvider for prompt: $prompt"
           return 0
       fi
       
       # Get API key
       local api_key
       api_key=$(get_api_key "newprovider")
       
       # Validate API key
       if [[ -z "$api_key" ]]; then
           echo "Error: No NewProvider API key found" >&2
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
           "https://api.newprovider.com/v1/chat/completions")
       
       # Extract HTTP status code
       local http_code
       http_code=$(echo "$response" | tail -n1)
       
       # Extract response body
       local body
       body=$(echo "$response" | head -n -1)
       
       # Check for HTTP errors
       if [[ "$http_code" -ne 200 ]]; then
           echo "Error: NewProvider API request failed with status $http_code" >&2
           echo "$body" >&2
           return 1
       fi
       
       # Extract and return the response text
       echo "$body" | jq -r '.choices[0].message.content'
   }
   ```

2. **Update the main curllm script** to include the new provider:
   ```bash
   # In the send_chat_completion function
   case "$provider" in
       # ... existing providers ...
       newprovider)
           if declare -f newprovider_chat_completion >/dev/null; then
               newprovider_chat_completion "$prompt" "$model"
           else
               echo "Error: newprovider_chat_completion function not found" >&2
               return 1
           fi
           ;;
   esac
   ```

3. **Update the security library** to handle the new provider's API key:
   ```bash
   # In the get_api_key function
   case "$provider" in
       # ... existing providers ...
       "newprovider")
           if [[ "$key" == "NEWPROVIDER_API_KEY" ]]; then
               api_key="$value"
           fi
           ;;
   esac
   ```

4. **Update the help text** to include information about the new provider

### Provider Script Requirements

Each provider script must:
1. Define a `{provider}_chat_completion` function
2. Accept prompt as first argument and model as second argument
3. Handle mock mode when `MOCK_MODE=true`
4. Use `get_api_key` to retrieve API keys
5. Validate API keys before making requests
6. Return responses in plain text format
7. Handle errors appropriately

## Development

### Project Structure
```
curllm/
├── bin/
│   └── curllm              # Main executable
├── lib/
│   ├── config.sh           # Configuration loading
│   ├── security.sh         # API key handling
│   ├── utils.sh            # Utility functions
│   └── logging.sh          # Logging functionality
├── providers/
│   ├── openai.sh           # OpenAI provider
│   ├── anthropic.sh        # Anthropic provider
│   ├── qwen.sh             # Qwen provider
│   ├── mistral.sh          # Mistral provider
│   ├── gemini.sh           # Google Gemini provider
│   ├── openrouter.sh       # OpenRouter provider
│   └── groq.sh             # Groq provider
├── tests/
│   ├── test_basic.sh       # Basic functionality tests
│   ├── test_chat.sh        # Chat command tests
│   ├── test_config.sh      # Configuration tests
│   ├── test_security.sh    # Security tests
│   ├── test_help.sh        # Help functionality tests
│   ├── test_version.sh     # Version functionality tests
│   ├── test_args.sh        # Command-line argument tests
│   ├── test_mock.sh        # Mock mode tests
│   ├── test_comprehensive.sh # Comprehensive tests
│   ├── test_all_providers.sh # All providers tests
│   └── provider-specific tests
├── .env.example            # Example configuration
├── README.md               # User documentation
├── DOCUMENTATION.md        # Comprehensive documentation
├── Makefile                # Build and test commands
└── SUMMARY.md              # Project summary
```

### Coding Standards
- Pure Bash (POSIX compliant)
- Use `set -euo pipefail` for error handling
- Follow consistent indentation (4 spaces)
- Use descriptive variable and function names
- Include comments for complex logic
- Handle errors appropriately with meaningful messages

### Dependencies
- Bash
- curl
- jq
- Standard Unix utilities (sed, awk, grep, etc.)

## Testing

### Test Suite
curllm includes a comprehensive test suite with over 50 tests covering:
- Basic functionality
- Command-line argument parsing
- Configuration loading
- Security (API key handling)
- Provider-specific functionality
- Mock mode
- Help and version commands
- Error handling
- Logging functionality

### Running Tests
```bash
# Run all tests
make test

# Run a specific test
make test-basic
make test-chat
make test-config
# etc.

# Run tests for a specific provider
make test-openai
make test-qwen
# etc.
```

### Test Coverage
The test suite provides 100% coverage of all core functionality:
- ✅ Basic functionality
- ✅ Chat command
- ✅ Configuration loading
- ✅ Security/API key handling
- ✅ Help and version commands
- ✅ Command-line argument parsing
- ✅ Mock mode
- ✅ Logging functionality
- ✅ All 7 providers (OpenAI, Anthropic, Qwen, Mistral, Gemini, OpenRouter, Groq)
- ✅ Error handling
- ✅ Edge cases

### Writing New Tests
To add new tests:
1. Create a new test file in the `tests/` directory
2. Follow the naming convention `test_{feature}.sh`
3. Use the standard test structure:
   ```bash
   #!/usr/bin/env bash
   set -euo pipefail
   
   # Test setup
   TEST_DIR="/tmp/curllm_test_name"
   mkdir -p "$TEST_DIR"
   
   # Copy required files
   cp /path/to/curllm/bin/curllm "$TEST_DIR/"
   cp -r /path/to/curllm/lib "$TEST_DIR/"
   # etc.
   
   # Test execution
   echo "Testing feature..."
   
   # Assertions
   if [[ condition ]]; then
       echo "PASS: Description"
   else
       echo "FAIL: Description"
       exit 1
   fi
   
   echo "All tests passed!"
   ```

## Troubleshooting

### Common Issues

#### "Error: No API key found for provider"
**Cause**: Missing API key in configuration file
**Solution**: Add the required API key to `~/.config/curllm/config`

#### "Error: Provider 'provider' not supported"
**Cause**: Provider not implemented or provider script missing
**Solution**: Check that the provider script exists in the `providers/` directory

#### "Error: jq not found"
**Cause**: jq dependency not installed
**Solution**: Install jq using your package manager:
```bash
# Ubuntu/Debian
sudo apt-get install jq

# CentOS/RHEL
sudo yum install jq

# macOS
brew install jq
```

#### Mock mode not working
**Cause**: Environment variable not set correctly
**Solution**: Ensure `MOCK_MODE=true` is set before running the command:
```bash
MOCK_MODE=true curllm chat "test prompt"
```

#### Log file not being created
**Cause**: Permission issues or directory not existing
**Solution**: Ensure the cache directory exists and is writable:
```bash
mkdir -p ~/.cache/curllm
chmod 755 ~/.cache/curllm
```

### Debugging

To debug issues, you can:
1. **Enable verbose logging** using the `--verbose` flag
2. **Check the log file** at `~/.cache/curllm/curllm.log`
3. **Check the configuration file** for correct API keys
4. **Test individual components** using the test scripts
5. **Use mock mode** to isolate API-related issues

### Getting Help

If you encounter issues not covered in this documentation:
1. Check the existing tests for examples of correct usage
2. Review the source code for implementation details
3. Open an issue on the GitHub repository
```