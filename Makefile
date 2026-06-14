.PHONY: all test clean help poll poll-results rust-build rust-run

# Default target
all: test

# Build and test all Lean4 projects
test:
	@echo "Building all Lean4 projects via shell script..."
	@cargo run --release -- build

# Pull updates and build
poll:
	@echo "Pulling updates and building all projects..."
	@cargo run --release -- poll

# Fetch new results from Aristotle and test them
poll-results:
	@echo "Fetching new results from Aristotle and testing them..."
	@cargo run --release -- test

# Show build results
results:
	@echo "Build results:"
	@cargo run --release -- results 2>/dev/null || echo "No results found. Run 'make test' or 'make poll' first."

# ── Lean split-decls targets ─────────────────────────────────────────
LEAN_BIN := /nix/store/aqpyjzpqhs988lpqs8rnq8rw3i7ihrmi-lean/bin
LAKE := $(LEAN_BIN)/lake
LEAN := $(LEAN_BIN)/lean
SPLITTER := /home/mdupont/projects/lean-split-decls/SplitDecls.lean
ARIST_DIR := /mnt/data1/time-2026/05-may/07/arist
SPLIT_OUT := $(ARIST_DIR)/split-results

# Build mathlib4 dep once (cached for all projects)
split-build-deps:
	@echo "Building mathlib4 dependency (shared by all projects)..."
	@first=$$(find $(ARIST_DIR) -path '*_aristotle/*_aristotle/lakefile.toml' -exec dirname {} \; | head -1); \
	if [ -n "$$first" ]; then \
		echo "  First project: $$first"; \
		cd "$$first" && PATH="$(LEAN_BIN):$$PATH" lake build || echo "  Build had warnings but may be OK"; \
	else \
		echo "  No projects found"; \
	fi

# Run Lean declaration split on all Aristotle projects
split:
	@echo "Running Lean declaration splitter on all projects..."
	@LEAN_BIN=$(LEAN_BIN) cargo run --release -- split --input-dir $(ARIST_DIR) --output-dir $(SPLIT_OUT)

# Split a single project (usage: make split-one PROJ=<uuid>)
split-one:
	@if [ -z "$(PROJ)" ]; then echo "Usage: make split-one PROJ=<project-uuid>"; exit 1; fi; \
	for dir in $(ARIST_DIR)/$(PROJ)*_aristotle/*_aristotle/; do \
		if [ -d "$$dir" ] && [ -f "$$dir/lakefile.toml" ]; then \
			mod=$$(find "$$dir/RequestProject" -name '*.lean' -exec basename {} .lean \; | head -1); \
			echo "Splitting $$dir (module: RequestProject.$$mod)..."; \
			mkdir -p "$(SPLIT_OUT)/$(PROJ)"; \
			cd "$$dir" && PATH="$(LEAN_BIN):$$PATH" lake env lean --run $(SPLITTER) "RequestProject.$$mod" "$(SPLIT_OUT)/$(PROJ)" && echo "  ✓ Done"; \
		fi; \
	done

# Clean split results
split-clean:
	@echo "Cleaning split results..."
	rm -rf $(SPLIT_OUT)

# ── End split targets ────────────────────────────────────────────────

# Clean up result file
clean:
	@cargo run --release -- clean
	@echo "Cleaned up result file."

# Build the Rust project (using nix develop)
rust-build:
	@echo "Building Rust project..."
	@nix-shell --run "cargo build --release"

# Run the Rust project
rust-run:
	@echo "Running Rust project..."
	@nix-shell --run "cargo run --release -- $$(echo $$@) "

# Rust REPL (for development)
rust-repl:
	@echo "Starting Rust REPL..."
	@nix-shell --run "cargo repl"

# Run tests
rust-test:
	@echo "Running Rust tests..."
	@nix-shell --run "cargo test"

# Format code
rust-fmt:
	@echo "Formatting Rust code..."
	@nix-shell --run "cargo fmt"

# Lint code
rust-clippy:
	@echo "Running clippy..."
	@nix-shell --run "cargo clippy"

# Help
help:
	@echo "Available targets:"
	@echo "  all             : Default target, same as test"
	@echo "  test            : Build and test all Lean4 projects"
	@echo "  poll            : Pull updates and build all projects"
	@echo "  poll-results    : Fetch new results from Aristotle and test them"
	@echo "  results         : Show build results from last test/poll"
	@echo "  clean           : Remove result file"
	@echo "  split           : Run Lean decl splitter on all projects"
	@echo "  split-build-deps: Build mathlib4 once (shared cache)"
	@echo "  split-one PROJ= : Split single project by UUID"
	@echo "  split-clean     : Remove split results"
	@echo "  rust-build      : Build the Rust project"
	@echo "  rust-run        : Run the Rust project"
	@echo "  rust-repl       : Start Rust REPL"
	@echo "  rust-test       : Run Rust tests"
	@echo "  rust-fmt        : Format Rust code"
	@echo "  rust-clippy     : Run clippy linter"
	@echo "  help            : Show this help"