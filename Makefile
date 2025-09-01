# Makefile for curllm

# Default target
.PHONY: all
all: test

# Run all tests
.PHONY: test
test:
	@echo "Running all tests..."
	@cd src && ./tests/test_basic.sh
	@cd src && ./tests/test_chat.sh
	@cd src && ./tests/test_config.sh
	@cd src && ./tests/test_config_loading.sh
	@cd src && ./tests/test_config_direct.sh
	@cd src && ./tests/test_security.sh
	@cd src && ./tests/test_openai.sh
	@cd src && ./tests/test_openai_impl.sh
	@cd src && ./tests/test_openai_edge.sh
	@cd src && ./tests/test_qwen.sh
	@cd src && ./tests/test_qwen_edge.sh
	@cd src && ./tests/test_anthropic.sh
	@cd src && ./tests/test_anthropic_edge.sh
	@cd src && ./tests/test_mistral.sh
	@cd src && ./tests/test_mistral_edge.sh
	@cd src && ./tests/test_gemini.sh
	@cd src && ./tests/test_gemini_edge.sh
	@cd src && ./tests/test_openrouter.sh
	@cd src && ./tests/test_openrouter_edge.sh
	@cd src && ./tests/test_groq.sh
	@cd src && ./tests/test_groq_edge.sh
	@cd src && ./tests/test_help.sh
	@cd src && ./tests/test_version.sh
	@cd src && ./tests/test_args.sh
	@cd src && ./tests/test_args_edge.sh
	@cd src && ./tests/test_comprehensive.sh
	@cd src && ./tests/test_all_providers.sh
	@cd src && ./tests/test_mock.sh
	@cd src && ./tests/test_mock_edge.sh
	@cd src && ./tests/test_config_edge.sh
	@cd src && ./tests/test_security_edge.sh
	@cd src && ./tests/test_chat_edge.sh
	@cd src && ./tests/test_provider_combo.sh
	@cd src && ./tests/test_env.sh
	@cd src && ./tests/test_utils.sh
	@cd src && ./tests/test_lib.sh
	@cd src && ./tests/test_integration.sh
	@cd src && ./tests/test_error.sh
	@cd src && ./tests/test_perf.sh
	@cd src && ./tests/test_compat.sh
	@cd src && ./tests/test_examples.sh
	@cd src && ./tests/test_docs.sh
	@cd src && ./tests/test_validation.sh
	@cd src && ./tests/test_boundary.sh
	@cd src && ./tests/test_regression.sh
	@cd src && ./tests/test_install.sh
	@cd src && ./tests/test_comprehensive_final.sh
	@cd src && ./tests/test_makefile.sh
	@cd src && ./tests/test_doc_files.sh
	@cd src && ./tests/test_logging.sh
	@cd src && ./tests/test_verbose_logging.sh
	@echo "All tests passed!"

# Run a specific test
.PHONY: test-%
test-%:
	@cd src && ./tests/test_$*.sh

# Install curllm (copy to /usr/local/bin)
.PHONY: install
install:
	@echo "Installing curllm to /usr/local/bin..."
	@sudo cp src/bin/curllm /usr/local/bin/
	@sudo cp -r src/lib /usr/local/lib/curllm
	@sudo cp -r src/providers /usr/local/lib/curllm/
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
	@shellcheck src/bin/curllm src/lib/*.sh src/providers/*.sh src/tests/*.sh
	@echo "Linting complete!"