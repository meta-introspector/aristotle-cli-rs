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
SPLITTER := /home/mdupont/projects/lean-split-decls/static_split.py
ARIST_DIR := /mnt/data1/time-2026/05-may/07/arist
SPLIT_OUT := $(ARIST_DIR)/split-results
DASL_DIR := /home/mdupont/dasl
DASL_SPLIT_OUT := $(ARIST_DIR)/split-results-dasl

# Run static declaration split on all Aristotle projects (no build needed)
split:
	@echo "Running static declaration splitter on all projects..."
	@count=0; succ=0; fail=0; \
	for proj in $(ARIST_DIR)/*_aristotle/; do \
		for inner in "$$proj"*_aristotle/; do \
			if [ -d "$$inner/RequestProject" ]; then \
				name=$$(basename "$$proj"); \
				out="$(SPLIT_OUT)/$$name"; \
				mkdir -p "$$out"; \
				if python3 $(SPLITTER) "$$inner" "$$out" 2>/dev/null; then \
					succ=$$((succ+1)); \
				else \
					fail=$$((fail+1)); \
				fi; \
				count=$$((count+1)); \
				echo "[$$count] $$name: $$(find "$$out" -name 'flake.nix' 2>/dev/null | wc -l) flakes"; \
			fi; \
		done; \
	done; \
	echo "Done: $$succ succeeded, $$fail failed"

# Split a single project (usage: make split-one PROJ=<uuid>)
split-one:
	@if [ -z "$(PROJ)" ]; then echo "Usage: make split-one PROJ=<project-uuid>"; exit 1; fi; \
	for dir in $(ARIST_DIR)/$(PROJ)*_aristotle/*_aristotle/; do \
		if [ -d "$$dir/RequestProject" ]; then \
			name=$$(basename "$(ARIST_DIR)/$(PROJ)"*_aristotle); \
			out="$(SPLIT_OUT)/$$name"; \
			mkdir -p "$$out"; \
			echo "Splitting $$dir -> $$out"; \
			python3 $(SPLITTER) "$$dir" "$$out"; \
			echo "  Flakes: $$(find "$$out" -name 'flake.nix' 2>/dev/null | wc -l)"; \
		fi; \
	done

# Clean split results
split-clean:
	@echo "Cleaning split results..."
	rm -rf $(SPLIT_OUT)

# ── DASL dedup targets ───────────────────────────────────────────────

# Run static split on all Lean files in ~/dasl/
dedup-dasl:
	@echo "Running static declaration split on ~/dasl/ Lean files..."
	@cut -d: -f2- $(DASL_DIR)/index/lean.txt | sort -u | grep '\.lean$$' | grep -v '/\.lake/' | grep -v '/\.git/' > /tmp/dasl_lean_paths.txt; \
	count=$$(wc -l < /tmp/dasl_lean_paths.txt); \
	echo "  $$count Lean files found"; \
	dirs=$$(sed 's|/[^/]*\.lean$$||' /tmp/dasl_lean_paths.txt | sort -u); \
	ndirs=$$(echo "$$dirs" | wc -l); \
	echo "  $$ndirs unique project directories"; \
	n=0; total=0; \
	rm -rf $(DASL_SPLIT_OUT); mkdir -p $(DASL_SPLIT_OUT); \
	for dir in $$dirs; do \
		[ -d "$$dir" ] || continue; \
		name=$$(echo "$$dir" | tr '/' '-'); \
		out="$(DASL_SPLIT_OUT)/$$name"; \
		mkdir -p "$$out"; \
		python3 $(SPLITTER) "$$dir" "$$out" 2>/dev/null; \
		flakes=$$(find "$$out" -name 'flake.nix' 2>/dev/null | wc -l); \
		total=$$((total + flakes)); n=$$((n+1)); \
		echo "[$$n/$$ndirs] $$name: $$flakes flakes"; \
	done; \
	echo "Done: $$total total flakes across $$n directories"

# Count declarations in DASL lean files (dry-run)
dedup-dasl-dry:
	@echo "Counting declarations in ~/dasl/ Lean files..."
	@cut -d: -f2- $(DASL_DIR)/index/lean.txt | sort -u | grep '\.lean$$' | grep -v '/\.lake/' | grep -v '/\.git/' | while read f; do \
		[ -f "$$f" ] || continue; \
		decls=$$(grep -cE '^(def |theorem |lemma |example |inductive |structure |class |instance |opaque |axiom |abbrev )' "$$f" 2>/dev/null || echo 0); \
		[ "$$decls" -gt 0 ] && echo "$$decls $$f"; \
	done | awk '{sum+=$$1; print} END{print sum " TOTAL"}'

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
	@echo "  split           : Static decl split (no build), one flake.nix per decl"
	@echo "  split-one PROJ= : Split single project by UUID"
	@echo "  split-clean     : Remove split results"
	@echo "  dedup-dasl      : Run static dedup/split on all ~/dasl/ Lean files"
	@echo "  dedup-dasl-dry  : Count declarations in ~/dasl/ (no split)"
	@echo "  rust-build      : Build the Rust project"
	@echo "  rust-run        : Run the Rust project"
	@echo "  rust-repl       : Start Rust REPL"
	@echo "  rust-test       : Run Rust tests"
	@echo "  rust-fmt        : Format Rust code"
	@echo "  rust-clippy     : Run clippy linter"
	@echo "  help            : Show this help"