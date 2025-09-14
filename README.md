# curllm

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A universal LLM API wrapper written in pure Bash that provides a unified interface to interact with multiple Large Language Model providers.

## Description

`curllm` is a powerful, pure Bash LLM API wrapper that allows you to interact with various LLM providers through a unified interface. It's designed to be lightweight, secure, and easily extensible with support for:

- OpenAI GPT models
- Anthropic Claude models
- Alibaba Qwen models
- Mistral AI models
- Google Gemini models
- OpenRouter models (100+ models from various providers)
- Groq models

## Key Features

- 🌐 **Universal Interface**: Single command to interact with any supported LLM provider
- 🔧 **Easy Configuration**: Simple config file at `~/.config/curllm/config`
- 🔒 **Secure**: API keys stored securely in config file (not in code)
- 🧪 **Mock Mode**: Test without making real API calls
- 📋 **Model Management**: List, browse, and set default models for each provider
- 📝 **Comprehensive Logging**: Detailed logs for debugging and monitoring
- 🧩 **Extensible**: Easy to add new providers
- 🧪 **Well Tested**: 50+ test cases covering all functionality
- 📚 **Pure Bash**: No external dependencies beyond standard tools (curl, jq)

## Supported Providers

| Provider    | Models | API Key Variable |
|-------------|--------|------------------|
| OpenAI      | GPT-4, GPT-3.5, etc. | `OPENAI_API_KEY` |
| Anthropic   | Claude 3, Claude 2, etc. | `ANTHROPIC_API_KEY` |
| Qwen        | Qwen Turbo, Plus, Max, etc. | `QWEN_API_KEY` |
| Mistral     | Mistral Large, Medium, Small, etc. | `MISTRAL_API_KEY` |
| Gemini      | Gemini Pro, Flash, etc. | `GEMINI_API_KEY` |
| OpenRouter  | 100+ models from multiple providers | `OPENROUTER_API_KEY` |
| Groq        | Llama 3, Mixtral, etc. | `GROQ_API_KEY` |

## Installation

### Prerequisites

- Bash shell
- curl
- jq
- Basic Unix utilities (sed, awk, grep, etc.)

### Installation Steps

```bash
# Clone the repository
git clone https://github.com/AR-92/curllm.git
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

Create a configuration file at `~/.config/curllm/config`:

```bash
# Default provider and model
DEFAULT_PROVIDER=openai
DEFAULT_MODEL=gpt-3.5-turbo

# API Keys (add the ones you need)
OPENAI_API_KEY=sk-your-openai-api-key
ANTHROPIC_API_KEY=your-anthropic-api-key
QWEN_API_KEY=your-qwen-api-key
MISTRAL_API_KEY=your-mistral-api-key
GEMINI_API_KEY=your-gemini-api-key
OPENROUTER_API_KEY=your-openrouter-api-key
GROQ_API_KEY=your-groq-api-key
```

Secure your config file:

```bash
chmod 600 ~/.config/curllm/config
```

## Usage

### Basic Usage

```bash
# Basic chat completion with default provider
curllm chat "What is the capital of France?"

# Specify provider
curllm chat --provider qwen "Explain quantum computing"

# Specify provider and model
curllm chat --provider groq --model llama3-8b-8192 "Write a Python function"

# Enable verbose logging
curllm chat --verbose "Debug this request"
```

### Model Management

```bash
# List available models for a provider
curllm list-models --provider gemini

# Interactively browse and select models
curllm browse-models --provider gemini

# Set default model for a provider
curllm set-default --provider gemini --model gemini-1.5-pro
```

### Mock Mode

Test without making real API calls:

```bash
MOCK_MODE=true curllm chat "Test prompt"
MOCK_MODE=true curllm chat --provider qwen "Test prompt"
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

## Environment Variables

- `MOCK_MODE=true` - Enable mock mode (no real API calls)
- `XDG_CONFIG_HOME` - Config directory (default: ~/.config)
- `XDG_CACHE_HOME` - Log directory (default: ~/.cache)

## Logging

All operations are logged to `~/.cache/curllm/curllm.log` with the following log levels:
- ERROR - Critical errors that prevent operation
- WARN - Warnings about potential issues
- INFO - General information about operations (default)
- DEBUG - Detailed debugging information (enabled with `--verbose`)

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
│   ├── logging.sh          # Logging functionality
│   └── models.sh           # Model management
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
│   └── ... (50+ total)
├── README.md               # User documentation
├── DOCUMENTATION.md        # Comprehensive documentation
├── Makefile                # Build and test commands
└── SUMMARY.md              # Project summary
```

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

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature-name`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add some feature'`)
5. Push to the branch (`git push origin feature/your-feature-name`)
6. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

- GitHub: [AR-92](https://github.com/AR-92)