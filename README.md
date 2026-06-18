# Aristotle Manager

A tool for polling Aristotle results and managing Lean4 project compilation. This project provides both shell scripts and a Rust-based command-line interface for automating the process of:

- Polling the Aristotle API for new project results
- Submitting Aristotle projects and asking follow-up project-scoped prompts
- Managing Lean4 project compilation
- Tracking build status and results

## Features

- **Poll for new projects**: Download and process new results from Aristotle
- **Interactive Aristotle API workflow**: Submit prompts, list projects, ask follow-up questions, and inspect task events
- **Build management**: Compile all Lean4 projects with proper error handling
- **Parallel downloads**: Support for concurrent project processing
- **Comprehensive logging**: Detailed logs for debugging and monitoring
- **Configuration management**: Easy-to-use config file for settings
- **Rust implementation**: Fast, reliable, and maintainable Rust code

## Directory Structure

```
aristotle-manager/
├── Cargo.toml          # Rust project configuration
├── Makefile            # Make targets for building
├── README.md           # This file
├── shell.nix           # Nix development shell
├── src/
│   └── main.rs         # Rust source code
├── config.sh           # Shell script configuration
├── *.sh                # Shell scripts (legacy)
└── result.txt          # Build results
```

## Quick Start

### Prerequisites

1. **Rust**: Ensure you have Rust installed (via rustup or your package manager)
2. **Nix**: For development environment (optional but recommended)
3. **OpenSSL**: System libraries for HTTPS support

### Building with Nix

```bash
# Enter the Nix development shell
nix-shell

# Build the project
cargo build

# Run the project
cargo run -- --help
```

### Building without Nix

```bash
# Ensure you have the required dependencies
sudo apt-get install pkg-config libssl-dev  # Ubuntu/Debian
# OR
sudo pacman -S pkgconf openssl              # Arch Linux

# Build the project
cargo build

# Run the project
cargo run -- --help
```

## Make Targets

```bash
# Build and test all Lean4 projects (shell scripts)
make test

# Pull updates and build all projects
make poll

# Fetch new results from Aristotle and test them
make poll-results

# Show build results
make results

# Clean up result file
make clean

# Build the Rust project
make rust-build

# Run the Rust project
make rust-run -- <command> [args...]

# Run tests
make rust-test

# Format code
make rust-fmt

# Lint code
make rust-clippy
```

## Rust CLI Commands

```bash
# Show help
cargo run -- --help

# Configure API key
export ARISTOTLE_API_KEY=YOUR_KEY

# Or persist an API key explicitly
cargo run -- configure set -k YOUR_KEY --persist

# Show configuration
cargo run -- configure show

# Check Aristotle server/toolchain version
cargo run -- version

# Submit a prompt, optionally with a Lean project directory
cargo run -- submit "Fill in all sorries" --project-dir ./my-lean-project --wait

# List projects and ask follow-up prompts
cargo run -- list --limit 10
cargo run -- ask <project-id> "Continue, try a different lemma strategy" --wait
cargo run -- show <project-id> --limit 20

# Poll for new projects
cargo run -- poll

# Build all projects
cargo run -- build

# Download one project result
cargo run -- download <project-id> --destination result.tar.gz

# Bulk-download available results
cargo run -- download -j 4 --verbose

# Show results
cargo run -- results

# Clean build artifacts
cargo run -- clean
```

## Shell Scripts (Legacy)

The shell scripts in this project (`poll.sh`, `poll-results.sh`, `build_all.sh`) are being migrated to Rust. They are still available but will be deprecated once the Rust migration is complete.

### Usage

```bash
# Update all projects and build
./poll.sh

# Build only
./build_all.sh

# Debug script
./debug_aristotle.sh
```

## Configuration

The Rust project uses a configuration file at `~/.config/aristotle-manager/config.toml`. You can configure:

- Base directories
- Number of parallel downloads
- Retry settings
- Notification settings (email, Slack)

### Example Configuration

```toml
base_dir = "/home/mdupont/projects/arist"
results_dir = "/home/mdupont/projects/aristotle_results"
git_base = "/home/mdupont/05/07/arist"
max_parallel_downloads = 4
retry_wait_seconds = 10
max_retries = 3
notification_email = ""
slack_webhook = ""
```

## API Reference

This project uses the Aristotle API at `https://aristotle.harmonic.fun/api/v3`.

Aristotle's interactive workflow is project-scoped. It is not a standalone chat-completions API:

1. Create a project with a prompt, optionally uploading a Lean/project archive.
2. Ask follow-up prompts against that project.
3. Poll tasks/events for progress and output.

The endpoint model matches the current official Python SDK (`aristotlelib` 2.0.0, released 2026-05-14).

### Endpoints Used

- `GET /api/v3/project` - List projects
- `POST /api/v3/project` - Submit a new project prompt
- `GET /api/v3/project/{id}` - Get project metadata
- `POST /api/v3/project/{id}/ask` - Submit a follow-up project-scoped prompt
- `GET /api/v3/project/{id}/tasks` - List project tasks
- `GET /api/v3/task/{id}` - Get task status
- `GET /api/v3/task/{id}/events` - List task events
- `GET /api/v3/project/{id}/result` - Download project result files
- `GET /api/v3/project/{id}/input` - Download uploaded input files when no result exists
- `GET /api/v3/version` - Show Aristotle Lean toolchain metadata

OpenAPI/docs URLs were checked and were not exposed publicly at the time this was documented.

### Authentication

Set your API key using:

```bash
# Via environment variable
export ARISTOTLE_API_KEY=your_key_here

# Or via the CLI for the current process only
cargo run -- configure set -k your_key_here

# Or persist it in ~/.config/aristotle-manager/config.toml
cargo run -- configure set -k your_key_here --persist
```

The CLI resolves API keys in this order: in-memory key, `ARISTOTLE_API_KEY`, persisted config.

### Official Python CLI Reference

The official SDK can be used directly for comparison:

```bash
uvx --from aristotlelib aristotle submit "Prove this theorem..." --wait
uvx --from aristotlelib aristotle list --limit 10
uvx --from aristotlelib aristotle ask <project-id> "Continue, try a different lemma strategy"
uvx --from aristotlelib aristotle show <project-id> --limit 20
```

## Development

### Nix Development Environment

The project includes a `shell.nix` file for Nix-based development. To enter the development shell:

```bash
nix-shell
```

This will load all required dependencies including:
- Rust toolchain
- System libraries (OpenSSL, libgit2, etc.)
- Build tools (cargo, rustfmt, clippy)

### Rust Development

```bash
# Build
cargo build

# Run
cargo run -- <command>

# Test
cargo test

# Format code
cargo fmt

# Lint code
cargo clippy
```

### Continuous Integration

The project is set up for CI/CD with GitHub Actions or other CI systems. The `.github/workflows/` directory contains workflow files for building and testing.

## Project Roadmap

1. ✅ Create Rust project structure
2. ✅ Implement API client
3. ✅ Migrate shell scripts to Rust CLI
4. ✅ Add configuration management
5. ⬜ Add comprehensive error handling
6. ⬜ Implement notification system
7. ⬜ Add monitoring and metrics
8. ⬜ Create proper documentation

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please open an issue or pull request for any questions or suggestions.
