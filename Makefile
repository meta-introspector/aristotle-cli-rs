.PHONY: all test clean help poll poll-results rust-build rust-run

# Default target
all: test

# Build and test all Lean4 projects
test:
	@echo "Building all Lean4 projects via shell script..."
	@./build_all.sh

# Pull updates and build
poll:
	@echo "Pulling updates and building all projects..."
	@./poll.sh

# Fetch new results from Aristotle and test them
poll-results:
	@echo "Fetching new results from Aristotle and testing them..."
	@./poll-results.sh

# Show build results
results:
	@echo "Build results:"
	@cat ./result.txt 2>/dev/null || echo "No results found. Run 'make test' or 'make poll' first."

# Clean up result file
clean:
	@rm -f result.txt
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
	@echo "  rust-build      : Build the Rust project"
	@echo "  rust-run        : Run the Rust project"
	@echo "  rust-repl       : Start Rust REPL"
	@echo "  rust-test       : Run Rust tests"
	@echo "  rust-fmt        : Format Rust code"
	@echo "  rust-clippy     : Run clippy linter"
	@echo "  help            : Show this help"