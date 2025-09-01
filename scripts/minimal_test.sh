#!/usr/bin/env bash

# Minimal test to reproduce the issue

set -euo pipefail

echo "=== Creating minimal test ==="

# Create temporary directory
TEST_DIR="/tmp/minimal_test"
mkdir -p "$TEST_DIR"

# Copy necessary files
mkdir -p "$TEST_DIR/lib" "$TEST_DIR/bin"
cp lib/help.sh "$TEST_DIR/lib/"
cp lib/config.sh "$TEST_DIR/lib/" 2>/dev/null || echo "No config.sh"
cp lib/security.sh "$TEST_DIR/lib/" 2>/dev/null || echo "No security.sh"
cp lib/utils.sh "$TEST_DIR/lib/" 2>/dev/null || echo "No utils.sh"
cp lib/logging.sh "$TEST_DIR/lib/" 2>/dev/null || echo "No logging.sh"

# Create minimal main script
cat > "$TEST_DIR/bin/curllm" << 'EOF'
#!/usr/bin/env bash

set -euo pipefail

# Source libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$(dirname "$SCRIPT_DIR")/lib"

# Source help library
if [[ -f "$LIB_DIR/help.sh" ]]; then
    source "$LIB_DIR/help.sh"
else
    echo "Error: Missing help library"
    exit 1
fi

# Parse command line arguments
parse_args() {
    local command=""
    local help_verbose=0
    
    # Process all arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
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
            --verbose)
                verbose=1
                shift
                ;;
            *)
                shift
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
    
    echo "|||"
}

# Main function
main() {
    # Parse arguments
    local parsed_args
    parsed_args=$(parse_args "$@")
    
    echo "DEBUG: parsed_args = '$parsed_args'" >&2
    
    # Check if we just need to show help or version
    if [[ "$parsed_args" == "help_verbose|||" ]]; then
        echo "DEBUG: Calling show_verbose_help" >&2
        show_verbose_help
        exit 0
    fi
    
    if [[ "$parsed_args" == "help|||" ]] || [[ "$parsed_args" == "|||" ]]; then
        echo "DEBUG: Calling show_help" >&2
        show_help
        exit 0
    fi
    
    echo "DEBUG: No match, showing default help" >&2
    show_help
    exit 0
}

# Run main function with all arguments
main "$@"
EOF

chmod +x "$TEST_DIR/bin/curllm"

echo "=== Testing help ==="
output=$("$TEST_DIR/bin/curllm" help 2>&1)
echo "Output:"
echo "$output"
echo ""

echo "=== Testing help --verbose ==="
output=$("$TEST_DIR/bin/curllm" help --verbose 2>&1)
echo "Output:"
echo "$output"
echo ""

echo "=== Testing --help --verbose ==="
output=$("$TEST_DIR/bin/curllm" --help --verbose 2>&1)
echo "Output:"
echo "$output"
echo ""