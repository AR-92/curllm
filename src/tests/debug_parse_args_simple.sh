#!/usr/bin/env bash

# Debug the parse_args function

# Test directory
TEST_DIR="/tmp/curllm_debug"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

echo "Debugging parse_args function..."

# Create a simple debug script
cat > /tmp/debug_parse_args_simple.sh << 'EOF'
#!/usr/bin/env bash

# Source the libraries from the test directory
SCRIPT_DIR="/tmp/curllm_debug"
LIB_DIR="$SCRIPT_DIR/lib"
PROVIDERS_DIR="$SCRIPT_DIR/providers"

# Source config library
if [[ -f "$LIB_DIR/config.sh" ]]; then
    source "$LIB_DIR/config.sh"
else
    echo "Error: Missing config library"
    exit 1
fi

# Source security library
if [[ -f "$LIB_DIR/security.sh" ]]; then
    source "$LIB_DIR/security.sh"
else
    echo "Error: Missing security library"
    exit 1
fi

# Source utils library
if [[ -f "$LIB_DIR/utils.sh" ]]; then
    source "$LIB_DIR/utils.sh"
else
    echo "Error: Missing utils library"
    exit 1
fi

# Source help library
if [[ -f "$LIB_DIR/help.sh" ]]; then
    source "$LIB_DIR/help.sh"
else
    echo "Error: Missing help library"
    exit 1
fi

# Source logging library
if [[ -f "$LIB_DIR/logging.sh" ]]; then
    source "$LIB_DIR/logging.sh"
else
    echo "Error: Missing logging library"
    exit 1
fi

# Mock functions
load_config() {
    DEFAULT_PROVIDER="openai"
    DEFAULT_MODEL="gpt-3.5-turbo"
}

log_error() {
    echo "ERROR: $1" >&2
}

set_log_level() {
    echo "Setting log level to: $1"
}

log_info() {
    echo "INFO: $1"
}

log_debug() {
    echo "DEBUG: $1"
}

# Copy the parse_args function
parse_args() {
    local provider=""
    local model=""
    local command=""
    local prompt=""
    local verbose=0
    local help_verbose=0
    
    # Process all arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            chat)
                command="chat"
                shift
                # Collect the rest as prompt
                prompt="$*"
                break
                ;;
            help)
                command="help"
                shift
                # Check if --verbose follows
                if [[ "${1:-}" == "--verbose" ]]; then
                    help_verbose=1
                    shift
                fi
                break
                ;;
            version)
                command="version"
                shift
                break
                ;;
            --help|-h)
                command="help"
                shift
                # Check if --verbose follows
                if [[ "${1:-}" == "--verbose" ]]; then
                    help_verbose=1
                    shift
                fi
                break
                ;;
            --version|-v)
                command="version"
                shift
                break
                ;;
            --verbose)
                verbose=1
                shift
                ;;
            --provider)
                if [[ -n "${2:-}" ]]; then
                    provider="$2"
                    shift 2
                else
                    log_error "--provider requires a value"
                    echo "Error: --provider requires a value" >&2
                    exit 1
                fi
                ;;
            --model)
                if [[ -n "${2:-}" ]]; then
                    model="$2"
                    shift 2
                else
                    log_error "--model requires a value"
                    echo "Error: --model requires a value" >&2
                    exit 1
                fi
                ;;
            *)
                # If we get here and no command is set, show help
                echo "|||"
                return
                ;;
        esac
    done
    
    # Handle help command with verbose
    if [[ "$command" == "help" ]] && [[ "$help_verbose" == "1" ]]; then
        echo "help_verbose|||"
        return
    fi
    
    if [[ "$command" == "help" ]]; then
        echo "help|||"
        return
    fi
    
    if [[ "$command" == "version" ]]; then
        echo "version|||"
        return
    fi
    
    echo "$command|$provider|$model|$prompt|$verbose|$help_verbose"
}

# Test different argument combinations
echo "Testing: help --verbose"
result=$(parse_args help --verbose)
echo "Result: $result"
echo ""

echo "Testing: --help --verbose"
result=$(parse_args --help --verbose)
echo "Result: $result"
echo ""

echo "Testing: help"
result=$(parse_args help)
echo "Result: $result"
echo ""
EOF

chmod +x /tmp/debug_parse_args_simple.sh
/tmp/debug_parse_args_simple.sh