# curllm

A pure Bash LLM API wrapper for interacting with various LLM providers.

## Features

- Pure Bash implementation (POSIX compliant)
- Supports multiple LLM providers (OpenAI, Anthropic, Qwen, Mistral, Google Gemini, OpenRouter, Groq, etc.)
- Secure API key handling via environment variables
- Configurable default provider and model
- Mock mode for testing without API calls
- Extensible provider modules
- Comprehensive test suite
- Command-line argument parsing (--provider, --model)
- Help and version commands
- Comprehensive logging with verbose mode

## Installation

```bash
# Clone the repository
git clone https://github.com/AR-92/curllm.git
cd curllm

# Install (copies files to /usr/local/bin and /usr/local/lib)
sudo make install
```

## Configuration

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

## Usage

```bash
# Basic chat completion
curllm chat "What is the capital of France?"

# Specify provider and model
curllm chat --provider qwen --model qwen-turbo "Explain quantum computing"

# Enable verbose logging
curllm chat --verbose "Debug this request"

# Show help
curllm help
curllm --help

# Show version
curllm version
curllm --version
```

## Logging

curllm logs all operations to `~/.cache/curllm/curllm.log`. Use the `--verbose` flag to enable detailed debug logging.

## Mock Mode

For testing without making real API calls, set the `MOCK_MODE` environment variable:

```bash
MOCK_MODE=true curllm chat "What is the capital of France?"
```

## Supported Providers

- **OpenAI** - GPT models (gpt-3.5-turbo, gpt-4, etc.)
- **Anthropic** - Claude models (claude-2, claude-instant, etc.)
- **Qwen** - Alibaba Qwen models (qwen-turbo, qwen-plus, etc.)
- **Mistral** - Mistral AI models (mistral-tiny, mistral-small, etc.)
- **Google Gemini** - Google's Gemini models (gemini-pro, etc.)
- **OpenRouter** - Access to many models through a single API
- **Groq** - Fast inference models (llama2-70b-4096, etc.)

## Development

### Running Tests

```bash
# Run all tests
make test

# Run a specific test
make test-basic
make test-chat
make test-config
# etc.
```

### Project Structure

```
curllm/
├── bin/
│   └── curllm        # main executable
├── lib/
│   ├── utils.sh      # shared helpers
│   ├── config.sh     # config loader
│   ├── security.sh   # API key handling
│   └── logging.sh    # logging functionality
├── providers/
│   ├── openai.sh
│   ├── anthropic.sh
│   ├── qwen.sh
│   ├── mistral.sh
│   ├── gemini.sh
│   ├── openrouter.sh
│   └── groq.sh
├── tests/
│   ├── test_config.sh
│   ├── test_security.sh
│   ├── test_openai.sh
│   ├── test_qwen.sh
│   └── ... (50+ total)
├── .env.example
├── README.md
└── Makefile
```

## License

MIT