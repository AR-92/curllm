# Makefile for curllm

# Default target
.PHONY: all
all: test

# Run all tests
.PHONY: test
test:
	@echo "Running all tests..."
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_basic.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_chat.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_config.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_config_loading.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_config_direct.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_security.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_openai.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_openai_impl.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_openai_edge.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_qwen.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_qwen_edge.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_anthropic.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_anthropic_edge.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_mistral.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_mistral_edge.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_gemini.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_gemini_edge.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_openrouter.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_openrouter_edge.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_groq.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_groq_edge.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_help.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_version.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_args.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_args_edge.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_comprehensive.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_all_providers.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_mock.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_mock_edge.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_config_edge.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_security_edge.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_chat_edge.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_provider_combo.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_env.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_utils.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_lib.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_integration.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_error.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_perf.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_compat.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_examples.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_docs.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_validation.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_boundary.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_regression.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_install.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_comprehensive_final.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_makefile.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_doc_files.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_logging.sh
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_verbose_logging.sh
	@echo "All tests passed!"

# Run a specific test
.PHONY: test-%
test-%:
	@cd /home/rana/Documents/Projects/curllm && ./tests/test_$*.sh

# Install curllm (copy to /usr/local/bin)
.PHONY: install
install:
	@echo "Installing curllm to /usr/local/bin..."
	@sudo cp bin/curllm /usr/local/bin/
	@sudo cp -r lib /usr/local/lib/curllm
	@sudo cp -r providers /usr/local/lib/curllm/
	@echo "Installation complete!"

# Uninstall curllm
.PHONY: uninstall
uninstall:
	@echo "Uninstalling curllm from /usr/local/bin..."
	@sudo rm -f /usr/local/bin/curllm
	@sudo rm -rf /usr/local/lib/curllm
	@echo "Uninstallation complete!"

# Clean test directories
.PHONY: clean
clean:
	@echo "Cleaning test directories..."
	@rm -rf /tmp/curllm_*
	@echo "Clean complete!"

# Lint the code with shellcheck
.PHONY: lint
lint:
	@echo "Linting with shellcheck..."
	@shellcheck bin/curllm lib/*.sh providers/*.sh tests/*.sh
	@echo "Linting complete!"