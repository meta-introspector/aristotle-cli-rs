.PHONY: all test clean help poll poll-results

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

# Help
help:
	@echo "Available targets:"
	@echo "  all       : Default target, same as test"
	@echo "  test      : Build and test all Lean4 projects"
	@echo "  poll      : Pull updates and build all projects"
	@echo "  poll-results: Fetch new results from Aristotle and test them"
	@echo "  results   : Show build results from last test/poll"
	@echo "  clean     : Remove result file"
	@echo "  help      : Show this help"