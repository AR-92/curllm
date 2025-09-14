# Makefile for curllm

# Default target
.PHONY: all
all: test

# Run all tests
.PHONY: test
test:
	@echo "Running all tests..."
	@cd $(CURDIR) && ./tests/test_basic.sh
	@cd $(CURDIR) && ./tests/test_chat.sh
	@cd $(CURDIR) && ./tests/test_config.sh
	@cd $(CURDIR) && ./tests/test_config_loading.sh
	@cd $(CURDIR) && ./tests/test_config_direct.sh
	@cd $(CURDIR) && ./tests/test_security.sh
	@cd $(CURDIR) && ./tests/test_openai.sh
	@cd $(CURDIR) && ./tests/test_openai_impl.sh
	@cd $(CURDIR) && ./tests/test_openai_edge.sh
	@cd $(CURDIR) && ./tests/test_qwen.sh
	@cd $(CURDIR) && ./tests/test_qwen_edge.sh
	@cd $(CURDIR) && ./tests/test_anthropic.sh
	@cd $(CURDIR) && ./tests/test_anthropic_edge.sh
	@cd $(CURDIR) && ./tests/test_mistral.sh
	@cd $(CURDIR) && ./tests/test_mistral_edge.sh
	@cd $(CURDIR) && ./tests/test_gemini.sh
	@cd $(CURDIR) && ./tests/test_gemini_edge.sh
	@cd $(CURDIR) && ./tests/test_openrouter.sh
	@cd $(CURDIR) && ./tests/test_openrouter_edge.sh
	@cd $(CURDIR) && ./tests/test_groq.sh
	@cd $(CURDIR) && ./tests/test_groq_edge.sh
	@cd $(CURDIR) && ./tests/test_help.sh
	@cd $(CURDIR) && ./tests/test_version.sh
	@cd $(CURDIR) && ./tests/test_args.sh
	@cd $(CURDIR) && ./tests/test_args_edge.sh
	@cd $(CURDIR) && ./tests/test_comprehensive.sh
	@cd $(CURDIR) && ./tests/test_all_providers.sh
	@cd $(CURDIR) && ./tests/test_mock.sh
	@cd $(CURDIR) && ./tests/test_mock_edge.sh
	@cd $(CURDIR) && ./tests/test_config_edge.sh
	@cd $(CURDIR) && ./tests/test_security_edge.sh
	@cd $(CURDIR) && ./tests/test_chat_edge.sh
	@cd $(CURDIR) && ./tests/test_provider_combo.sh
	@cd $(CURDIR) && ./tests/test_env.sh
	@cd $(CURDIR) && ./tests/test_utils.sh
	@cd $(CURDIR) && ./tests/test_lib.sh
	@cd $(CURDIR) && ./tests/test_integration.sh
	@cd $(CURDIR) && ./tests/test_error.sh
	@cd $(CURDIR) && ./tests/test_perf.sh
	@cd $(CURDIR) && ./tests/test_compat.sh
	@cd $(CURDIR) && ./tests/test_examples.sh
	@cd $(CURDIR) && ./tests/test_docs.sh
	@cd $(CURDIR) && ./tests/test_validation.sh
	@cd $(CURDIR) && ./tests/test_boundary.sh
	@cd $(CURDIR) && ./tests/test_regression.sh
	@cd $(CURDIR) && ./tests/test_install.sh
	@cd $(CURDIR) && ./tests/test_comprehensive_final.sh
	@cd $(CURDIR) && ./tests/test_makefile.sh
	@cd $(CURDIR) && ./tests/test_doc_files.sh
	@cd $(CURDIR) && ./tests/test_logging.sh
	@cd $(CURDIR) && ./tests/test_verbose_logging.sh
	@cd $(CURDIR) && ./tests/test_list_models.sh
	@cd $(CURDIR) && ./tests/test_set_default.sh
	@cd $(CURDIR) && ./tests/test_browse_models.sh
	@cd $(CURDIR) && ./tests/test_models_lib.sh
	@cd $(CURDIR) && ./tests/test_comprehensive_model_management.sh
	@echo "All tests passed!"

# Run a specific test
.PHONY: test-%
test-%:
	@cd $(CURDIR) && ./tests/test_$*.sh

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