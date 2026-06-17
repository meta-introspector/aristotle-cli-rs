.PHONY: all test clean help poll poll-results rust-build rust-run \
        split split-all split-one split-clean \
        dedup-dasl dedup-dasl-dry \
        refresh decl-table merge index

# ── Rust binary ──────────────────────────────────────────────────────
CARGO := cargo run --release --

# Default target
all: test

# Build and test all Lean4 projects
test:
	@echo "Building all Lean4 projects..."
	@$(CARGO) build

# Pull updates and build
poll:
	@echo "Pulling updates and building all projects..."
	@$(CARGO) poll

# Fetch new results from Aristotle and test them
poll-results:
	@echo "Fetching new results from Aristotle and testing them..."
	@$(CARGO) test

# Show build results
results:
	@echo "Build results:"
	@$(CARGO) results 2>/dev/null || echo "No results found. Run 'make test' or 'make poll' first."

# Full pipeline: poll + download + split + decl-table
refresh:
	@echo "Running full refresh pipeline..."
	@$(CARGO) refresh

# ── Lean split-decls targets (Rust-driven) ─────────────────────────
#
# All split targets now go through the Rust aristotle-manager CLI,
# which calls the Lean SplitDecls.lean splitter internally.
# The old Python static_split.py is no longer used.

# Split all Aristotle projects (Lean kernel API, exact deps)
split:
	@echo "Splitting all Aristotle projects via Rust+Lean..."
	@$(CARGO) split

# Batch split via shell script driver
split-all:
	@echo "Batch splitting all projects..."
	@$(CARGO) split-all

# Split a single project (usage: make split-one PROJ=<uuid>)
split-one:
	@if [ -z "$(PROJ)" ]; then echo "Usage: make split-one PROJ=<project-uuid>"; exit 1; fi
	@echo "Splitting project $(PROJ)..."
	@$(CARGO) split --input-dir ./aristotles_results/$(PROJ)*_aristotle/

# Clean split results
split-clean:
	@echo "Cleaning split results..."
	@rm -rf ./split-results

# Build canonical declaration table from split results
decl-table:
	@echo "Building declaration table..."
	@$(CARGO) decl-table

# Merge split results
merge:
	@echo "Merging split results..."
	@$(CARGO) merge

# Generate DASL-compatible blocks.json index
index:
	@echo "Indexing Aristotle runs..."
	@$(CARGO) index

# ── DASL dedup targets ───────────────────────────────────────────────

# Run split on all Lean files in ~/dasl/ (via Rust)
dedup-dasl:
	@echo "Splitting ~/dasl/ Lean files via Rust+Lean..."
	@$(CARGO) split --input-dir ~/dasl --output-dir ./split-results-dasl

# Count declarations in DASL lean files (dry-run)
dedup-dasl-dry:
	@echo "Counting declarations in ~/dasl/ Lean files..."
	@cut -d: -f2- ~/dasl/index/lean.txt | sort -u | grep '\.lean$$' | grep -v '/\.lake/' | grep -v '/\.git/' | while read f; do \
		[ -f "$$f" ] || continue; \
		decls=$$(grep -cE '^(def |theorem |lemma |example |inductive |structure |class |instance |opaque |axiom |abbrev )' "$$f" 2>/dev/null || echo 0); \
		[ "$$decls" -gt 0 ] && echo "$$decls $$f"; \
	done | awk '{sum+=$$1; print} END{print sum " TOTAL"}'

# ── End split targets ────────────────────────────────────────────────

# Clean up result file
clean:
	@$(CARGO) clean
	@echo "Cleaned up result file."

# Build the Rust project
rust-build:
	@echo "Building Rust project..."
	@cargo build --release

# Run the Rust project
rust-run:
	@echo "Running Rust project..."
	@cargo run --release -- $(filter-out $@,$(MAKECMDGOALS))

# Run tests
rust-test:
	@echo "Running Rust tests..."
	@cargo test

# Format code
rust-fmt:
	@echo "Formatting Rust code..."
	@cargo fmt

# Lint code
rust-clippy:
	@echo "Running clippy..."
	@cargo clippy

# Help
help:
	@echo "Available targets:"
	@echo "  all             : Default target, same as test"
	@echo "  test            : Build and test all Lean4 projects"
	@echo "  poll            : Pull updates and build all projects"
	@echo "  poll-results    : Fetch new results from Aristotle and test them"
	@echo "  results         : Show build results from last test/poll"
	@echo "  refresh         : Full pipeline: poll + download + split + decl-table"
	@echo "  clean           : Remove result file"
	@echo ""
	@echo "  Split targets (Rust+Lean, replaces Python):"
	@echo "  split           : Split all projects via Rust+Lean (exact deps)"
	@echo "  split-all       : Batch split via shell script driver"
	@echo "  split-one PROJ= : Split single project by UUID"
	@echo "  split-clean     : Remove split results"
	@echo "  decl-table      : Build canonical declaration table"
	@echo "  merge           : Merge split results"
	@echo "  index           : Generate DASL blocks.json index"
	@echo ""
	@echo "  DASL targets:"
	@echo "  dedup-dasl      : Split all ~/dasl/ Lean files via Rust+Lean"
	@echo "  dedup-dasl-dry  : Count declarations in ~/dasl/ (no split)"
	@echo ""
	@echo "  Rust targets:"
	@echo "  rust-build      : Build the Rust project"
	@echo "  rust-run        : Run the Rust project"
	@echo "  rust-test       : Run Rust tests"
	@echo "  rust-fmt        : Format Rust code"
	@echo "  rust-clippy     : Run clippy linter"
	@echo "  help            : Show this help"
