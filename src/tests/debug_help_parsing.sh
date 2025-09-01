#!/usr/bin/env bash

# Debug help parsing

set -euo pipefail

# Test directory
TEST_DIR="/tmp/curllm_debug_help"
mkdir -p "$TEST_DIR"

# Copy curllm and lib to test directory, maintaining directory structure
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/lib" "$TEST_DIR/providers"
cp /home/rana/Documents/Projects/curllm/bin/curllm "$TEST_DIR/bin/"
cp /home/rana/Documents/Projects/curllm/lib/*.sh "$TEST_DIR/lib/"
cp /home/rana/Documents/Projects/curllm/providers/*.sh "$TEST_DIR/providers/"

echo "Debugging help parsing..."

# Test help --verbose
echo "=== Testing help --verbose ==="
set +e
"$TEST_DIR/bin/curllm" help --verbose > /tmp/debug_help_verbose.txt 2>&1
exit_code=$?
output=$(cat /tmp/debug_help_verbose.txt)
set -e

echo "Exit code: $exit_code"
echo "Output:"
echo "$output"
echo ""

# Let's also debug the parse_args function directly
echo "=== Debugging parse_args function ==="
# Create a simple debug script
cat > /tmp/debug_parse_args.sh << 'EOF'
#!/usr/bin/env bash
source /home/rana/Documents/Projects/curllm/lib/config.sh
source /home/rana/Documents/Projects/curllm/lib/security.sh
source /home/rana/Documents/Projects/curllm/lib/utils.sh
source /home/rana/Documents/Projects/curllm/lib/help.sh
source /home/rana/Documents/Projects/curllm/lib/logging.sh

# Mock the functions we need
load_config() { 
    DEFAULT_PROVIDER="openai"
    DEFAULT_MODEL="gpt-3.5-turbo"
}

log_error() { echo "ERROR: $1" >&2; }

# Copy the parse_args function from curllm
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

# Test the function
echo "Testing: help --verbose"
result=$(parse_args help --verbose)
echo "Result: $result"

echo "Testing: --help --verbose"
result=$(parse_args --help --verbose)
echo "Result: $result"
EOF

chmod +x /tmp/debug_parse_args.sh
/tmp/debug_parse_args.sh