#!/usr/bin/env bash

# Development utility script for curllm

set -euo pipefail

# Function to display usage
usage() {
    echo "curllm-dev - Development utilities for curllm"
    echo "Usage: ./dev.sh [command]"
    echo ""
    echo "Commands:"
    echo "  test          Run all tests"
    echo "  test-basic    Run basic functionality tests"
    echo "  test-chat     Run chat command tests"
    echo "  test-config   Run configuration tests"
    echo "  test-security Run security tests"
    echo "  test-providers Run provider tests"
    echo "  clean         Clean test directories"
    echo "  example       Run example usage"
    echo "  lint          Lint the code (requires shellcheck)"
    echo "  summary       Show project summary"
}

# Function to run all tests
run_all_tests() {
    echo "Running all tests..."
    make test
}

# Function to clean test directories
clean_tests() {
    echo "Cleaning test directories..."
    make clean
}

# Function to run example
run_example() {
    echo "Running example..."
    ./example.sh
}

# Function to lint code
lint_code() {
    echo "Linting code..."
    make lint
}

# Function to show summary
show_summary() {
    echo "Showing project summary..."
    cat SUMMARY.md
}

# Main function
main() {
    # Check if at least one argument is provided
    if [[ $# -lt 1 ]]; then
        usage
        exit 1
    fi

    # Parse command
    command="$1"
    shift

    case "$command" in
        test)
            run_all_tests
            ;;
        test-basic)
            cd /home/rana/Documents/Projects/curllm && ./tests/test_basic.sh
            ;;
        test-chat)
            cd /home/rana/Documents/Projects/curllm && ./tests/test_chat.sh
            ;;
        test-config)
            cd /home/rana/Documents/Projects/curllm && ./tests/test_config_loading.sh
            ;;
        test-security)
            cd /home/rana/Documents/Projects/curllm && ./tests/test_security.sh
            ;;
        test-providers)
            cd /home/rana/Documents/Projects/curllm && ./tests/test_openai_impl.sh
            cd /home/rana/Documents/Projects/curllm && ./tests/test_qwen.sh
            cd /home/rana/Documents/Projects/curllm && ./tests/test_anthropic.sh
            ;;
        clean)
            clean_tests
            ;;
        example)
            run_example
            ;;
        lint)
            lint_code
            ;;
        summary)
            show_summary
            ;;
        *)
            echo "Error: Unknown command '$command'"
            usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"