#!/usr/bin/env bash

# logging.sh - Logging functionality for curllm

# Log levels
LOG_LEVEL_ERROR=0
LOG_LEVEL_WARN=1
LOG_LEVEL_INFO=2
LOG_LEVEL_DEBUG=3

# Default log level
LOG_LEVEL=$LOG_LEVEL_INFO

# Log file location
LOG_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/curllm/curllm.log"

# Function to set log level
set_log_level() {
    local level="$1"
    case "$level" in
        "error") LOG_LEVEL=$LOG_LEVEL_ERROR ;;
        "warn") LOG_LEVEL=$LOG_LEVEL_WARN ;;
        "info") LOG_LEVEL=$LOG_LEVEL_INFO ;;
        "debug") LOG_LEVEL=$LOG_LEVEL_DEBUG ;;
        *) 
            if [[ "$level" =~ ^[0-3]$ ]]; then
                LOG_LEVEL=$level
            else
                LOG_LEVEL=$LOG_LEVEL_INFO
            fi
            ;;
    esac
}

# Function to ensure log directory exists
ensure_log_dir() {
    local log_dir
    log_dir=$(dirname "$LOG_FILE")
    mkdir -p "$log_dir"
}

# Function to log messages
log_message() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Determine if we should log this message based on log level
    local level_num
    case "$level" in
        "ERROR") level_num=$LOG_LEVEL_ERROR ;;
        "WARN") level_num=$LOG_LEVEL_WARN ;;
        "INFO") level_num=$LOG_LEVEL_INFO ;;
        "DEBUG") level_num=$LOG_LEVEL_DEBUG ;;
        *) level_num=$LOG_LEVEL_INFO ;;
    esac
    
    if [[ $level_num -le $LOG_LEVEL ]]; then
        # Ensure log directory exists
        ensure_log_dir
        
        # Write to log file
        echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
        
        # Also output to stderr for ERROR and WARN levels
        if [[ $level_num -le $LOG_LEVEL_WARN ]]; then
            echo "[$timestamp] [$level] $message" >&2
        fi
    fi
}

# Convenience functions for different log levels
log_error() {
    log_message "ERROR" "$1"
}

log_warn() {
    log_message "WARN" "$1"
}

log_info() {
    log_message "INFO" "$1"
}

log_debug() {
    log_message "DEBUG" "$1"
}