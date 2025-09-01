#!/usr/bin/env bash

# Add debug output to the parse_args function

parse_args() {
    local provider=""
    local model=""
    local command=""
    local prompt=""
    local verbose=0
    local help_verbose=0
    
    echo "DEBUG(parse_args): Starting with args: $*" >&2
    
    # Process all arguments
    while [[ $# -gt 0 ]]; do
        echo "DEBUG(parse_args): Processing arg: '$1'" >&2
        case $1 in
            chat)
                command="chat"
                shift
                # Collect the rest as prompt
                prompt="$*"
                echo "DEBUG(parse_args): Found chat command, prompt: '$prompt'" >&2
                break
                ;;
            help)
                command="help"
                shift
                echo "DEBUG(parse_args): Found help command" >&2
                # Check if --verbose follows
                if [[ "${1:-}" == "--verbose" ]]; then
                    help_verbose=1
                    echo "DEBUG(parse_args): Found --verbose flag" >&2
                    shift
                fi
                break
                ;;
            version)
                command="version"
                shift
                echo "DEBUG(parse_args): Found version command" >&2
                break
                ;;
            --help|-h)
                command="help"
                shift
                echo "DEBUG(parse_args): Found --help/-h flag" >&2
                # Check if --verbose follows
                if [[ "${1:-}" == "--verbose" ]]; then
                    help_verbose=1
                    echo "DEBUG(parse_args): Found --verbose flag after --help" >&2
                    shift
                fi
                break
                ;;
            --version|-v)
                command="version"
                shift
                echo "DEBUG(parse_args): Found --version/-v flag" >&2
                break
                ;;
            --verbose)
                verbose=1
                echo "DEBUG(parse_args): Found --verbose flag" >&2
                shift
                ;;
            --provider)
                if [[ -n "${2:-}" ]]; then
                    provider="$2"
                    echo "DEBUG(parse_args): Found --provider flag with value: '$provider'" >&2
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
                    echo "DEBUG(parse_args): Found --model flag with value: '$model'" >&2
                    shift 2
                else
                    log_error "--model requires a value"
                    echo "Error: --model requires a value" >&2
                    exit 1
                fi
                ;;
            *)
                # If we get here and no command is set, show help
                echo "DEBUG(parse_args): Unknown argument: '$1', showing help" >&2
                echo "|||"
                return
                ;;
        esac
    done
    
    # Handle help command with verbose
    if [[ "$command" == "help" ]] && [[ "$help_verbose" == "1" ]]; then
        echo "DEBUG(parse_args): Returning help_verbose|||" >&2
        echo "help_verbose|||"
        return
    fi
    
    if [[ "$command" == "help" ]]; then
        echo "DEBUG(parse_args): Returning help|||" >&2
        echo "help|||"
        return
    fi
    
    if [[ "$command" == "version" ]]; then
        echo "DEBUG(parse_args): Returning version|||" >&2
        echo "version|||"
        return
    fi
    
    echo "DEBUG(parse_args): Returning: $command|$provider|$model|$prompt|$verbose|$help_verbose" >&2
    echo "$command|$provider|$model|$prompt|$verbose|$help_verbose"
}