#!/usr/bin/env bash

# Simple test to debug the issue

echo "Testing argument parsing..."

# Function to parse arguments
parse_args() {
    local command=""
    local help_verbose=0
    
    echo "DEBUG: Starting with args: $*" >&2
    
    # Process all arguments
    while [[ $# -gt 0 ]]; do
        echo "DEBUG: Processing arg: '$1'" >&2
        case $1 in
            help)
                command="help"
                shift
                echo "DEBUG: Found help command" >&2
                # Check if --verbose follows
                if [[ "${1:-}" == "--verbose" ]]; then
                    help_verbose=1
                    echo "DEBUG: Found --verbose flag" >&2
                    shift
                fi
                break
                ;;
            --help|-h)
                command="help"
                shift
                echo "DEBUG: Found --help/-h flag" >&2
                # Check if --verbose follows
                if [[ "${1:-}" == "--verbose" ]]; then
                    help_verbose=1
                    echo "DEBUG: Found --verbose flag after --help" >&2
                    shift
                fi
                break
                ;;
            --verbose)
                verbose=1
                echo "DEBUG: Found --verbose flag" >&2
                shift
                ;;
            *)
                echo "DEBUG: Unknown argument: '$1'" >&2
                shift
                ;;
        esac
    done
    
    # Handle help command with verbose
    if [[ "$command" == "help" ]] && [[ "$help_verbose" == "1" ]]; then
        echo "DEBUG: Returning help_verbose|||" >&2
        echo "help_verbose|||"
        return
    fi
    
    if [[ "$command" == "help" ]]; then
        echo "DEBUG: Returning help|||" >&2
        echo "help|||"
        return
    fi
    
    echo "DEBUG: Returning default |||" >&2
    echo "|||"
}

# Test the function
echo "=== Test 1: help --verbose ==="
result=$(parse_args help --verbose)
echo "Result: $result"
echo ""

echo "=== Test 2: --help --verbose ==="
result=$(parse_args --help --verbose)
echo "Result: $result"
echo ""

echo "=== Test 3: help ==="
result=$(parse_args help)
echo "Result: $result"
echo ""