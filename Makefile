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
# ── Enrichment Pipeline Targets ─────────────────────────────────────
ARISTO := $(ARIST_DIR)/target/release/aristotle-manager
VENDORMOD := /mnt/data1/time-2026/06-june/letta-unified/target/release/cargo-vendormod
UPPER := d79d4cfd-1c60-40fc-ae16-bb0498953ec1
RESULTS := /mnt/data1/aristotle-results

# Run full enrichment pipeline (task-enricher + GOAP pipeline)
enrich:
	@echo "Running full enrichment pipeline..."
	@$(ARISTO) enrich --project-id $(UPPER)

# Run enrichment with skipped GOAP (task-enricher only)
enrich-task:
	@echo "Running task-enricher only (skipping GOAP)..."
	@$(ARISTO) enrich --project-id $(UPPER) --skip-goap

# Run enrichment with skipped task-enricher (GOAP only)
enrich-goap:
	@echo "Running GOAP pipeline only (skipping task-enricher)..."
	@$(ARISTO) enrich --project-id $(UPPER) --skip-task-enricher

# Individual GOAP pipeline steps
enrich-consolidate:
	@echo "Running consolidate step..."
	@$(ARISTO) consolidate --project-id $(UPPER)

enrich-jkey:
	@echo "Running J-key stratification..."
	@$(ARISTO) j-key --input-dir $(RESULTS)/consolidated --output-dir $(RESULTS)/j-key

enrich-depgraph:
	@echo "Running dependency graph..."
	@$(ARISTO) dep-graph --input-dir $(RESULTS)/consolidated --output-dir $(RESULTS)/dep-graph

enrich-mycelium:
	@echo "Running mycelium (0/1/2-cells)..."
	@$(ARISTO) mycelium --input-dir $(RESULTS)/dep-graph --output-dir $(RESULTS)/mycelium

enrich-arrows:
	@echo "Running functor arrows (2-category)..."
	@$(ARISTO) arrows --input-dir $(RESULTS)/mycelium --output-dir $(RESULTS)/arrows

# Deep analysis targets using vendormod
deep-scan-aristo:
	@echo "Running deep-scan on aristotle/ prefix..."
	@$(VENDORMOD) deep-scan --prefix "aristotle/" --max-size 100000 --shmem -v

deep-scan-vendormod:
	@echo "Running deep-scan on vendormod/full/ prefix..."
	@$(VENDORMOD) deep-scan --prefix "vendormod/full/" --shmem -v

cid-scan:
	@echo "Running CID scan for 0xD8 0x2A signatures..."
	@$(VENDORMOD) cid-scan --prefix "vendormod/" --shmem -v

graph-analyze:
	@echo "Running graph analysis..."
	@$(VENDORMOD) graph analyze --input-path $(RESULTS)/dep-graph/dep-graph.json --output-dir $(RESULTS)/graph-analysis

# Term graph targets
term-graph-build:
	@echo "Building term-graph..."
	@$(ARISTO) term-graph --git-base $(ARIST_DIR) --output-dir $(RESULTS)/term-graph --json

term-graph-load:
	@echo "Loading term-graph to shared memory..."
	@$(ARISTO) load-term-graph-to-shmem --dir $(RESULTS)/term-graph

term-graph-overlap:
	@echo "Finding overlapping projects..."
	@$(ARISTO) overlap --reference $(UPPER) --min-shared 3 --top 30

# Refusal audit targets
refusal-audit:
	@echo "Running refusal audit..."
	@$(ARISTO) refusal-audit --base-dir $(RESULTS) --output $(RESULTS)/aristo-refusal-audit.json

refusal-corpus:
	@echo "Building refusal corpus..."
	@$(ARISTO) refusal-corpus

refusal-glossary:
	@echo "Building refusal glossary..."
	@$(ARISTO) refusal-glossary

# NotebookLM dump target
notebooklm-dump:
	@echo "Generating NotebookLM dump..."
	@$(ARISTO) notebooklm-dump --output-dir $(RESULTS)/notebooklm-dump

# Feed results back to Aristotle targets
feed-index:
	@echo "Feeding tantivy index chunks..."
	@$(ARISTO) feed-index $(UPPER) --chunk-size 50

feed-arrows:
	@echo "Feeding enrichment results via ask (arrows)..."
	@$(ARISTO) ask $(UPPER) "Enrichment: arrows, mycelium, dep-graph, j-key bands complete" \
	  --inject-dir $(RESULTS)/arrows

feed-deepscan:
	@echo "Feeding deep scan results via ask..."
	@$(ARISTO) ask $(UPPER) "Deep scan: Hecke scores, entropy, functor arrows from shmem" \
	  --inject-dir $(RESULTS)/deep-scan

feed-diagonalize:
	@echo "Feeding diagonalization results via ask..."
	@$(ARISTO) ask $(UPPER) "Diagonalization: pipeline applied to itself" \
	  --inject-dir $(RESULTS)/diagonalize

feed-refusal:
	@echo "Feeding refusal audit results via ask..."
	@$(ARISTO) ask $(UPPER) "Refusal audit: failure patterns classified" \
	  --inject-dir $(RESULTS)/refusal-audit

# Convenience targets for running stages from the task file
stage2-enrich: enrich-consolidate enrich-jkey enrich-depgraph enrich-mycelium enrich-arrows

stage3-diagonalize:
	@echo "Running diagonalization pipeline..."
	@$(ARISTO) diagonalize --dry-run --output-dir $(RESULTS)/diagonalize
	@$(ARISTO) diagonalize --output-dir $(RESULTS)/diagonalize
	@$(ARISTO) diagonalize --core-only --output-dir $(RESULTS)/diagonalize-core
	@$(ARISTO) diagonalize --repair --output-dir $(RESULTS)/diagonalize-repair

stage4-deepanalysis: deep-scan-aristo deep-scan-vendormod cid-scan graph-analyze

stage5-termgraph: term-graph-build term-graph-load term-graph-overlap

stage6-refusal: refusal-audit refusal-corpus refusal-glossary

stage7-notebooklm: notebooklm-dump

stage8-feed: feed-index feed-arrows feed-deepscan feed-diagonalize feed-refusal

# Full pipeline from task file
full-pipeline: stage2-enrich stage3-diagonalize stage4-deepanalysis stage5-termgraph stage6-refusal stage7-notebooklm stage8-feed

# Update help target
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
	@echo "  enrich          : Run full enrichment pipeline (task-enricher + GOAP)"
	@echo "  enrich-task     : Run task-enricher only (skipping GOAP)"
	@echo "  enrich-goap     : Run GOAP pipeline only (skipping task-enricher)"
	@echo "  enrich-consolidate: Run consolidate step"
	@echo "  enrich-jkey     : Run J-key stratification"
	@echo "  enrich-depgraph : Run dependency graph"
	@echo "  enrich-mycelium : Run mycelium (0/1/2-cells)"
	@echo "  enrich-arrows   : Run functor arrows (2-category)"
	@echo "  deep-scan-aristo: Deep-scan aristotle/ prefix"
	@echo "  deep-scan-vendormod: Deep-scan vendormod/full/ prefix"
	@echo "  cid-scan        : CID scan for 0xD8 0x2A signatures"
	@echo "  graph-analyze   : Graph analysis"
	@echo "  term-graph-build: Build term-graph"
	@echo "  term-graph-load : Load term-graph to shared memory"
	@echo "  term-graph-overlap: Find overlapping projects"
	@echo "  refusal-audit   : Run refusal audit"
	@echo "  refusal-corpus  : Build refusal corpus"
	@echo "  refusal-glossary: Build refusal glossary"
	@echo "  notebooklm-dump : Generate NotebookLM dump"
	@echo "  feed-index      : Feed tantivy index chunks"
	@echo "  feed-arrows     : Feed enrichment results via ask (arrows)"
	@echo "  feed-deepscan   : Feed deep scan results via ask"
	@echo "  feed-diagonalize: Feed diagonalization results via ask"
	@echo "  feed-refusal    : Feed refusal audit results via ask"
	@echo "  stage2-enrich   : Run Stage 2 enrichment pipeline steps"
	@echo "  stage3-diagonalize: Run Stage 3 diagonalization"
	@echo "  stage4-deepanalysis: Run Stage 4 deep analysis"
	@echo "  stage5-termgraph: Run Stage 5 term graph"
	@echo "  stage6-refusal  : Run Stage 6 refusal audit"
	@echo "  stage7-notebooklm: Run Stage 7 NotebookLM dump"
	@echo "  stage8-feed     : Run Stage 8 feed results back to Aristotle"
	@echo "  full-pipeline   : Run complete pipeline from task file"
	@echo "  help            : Show this help"
