# Aristotle Manager

A tool for polling Aristotle results and managing Lean4 project compilation. This project provides both shell scripts and a Rust-based command-line interface for automating the process of:

- Polling the Aristotle API for new project results
- Managing Lean4 project compilation
- Tracking build status and results

## Features

- **Poll for new projects**: Download and process new results from Aristotle
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
cargo run -- configure set --api-key YOUR_KEY

# Show configuration
cargo run -- configure show

# Poll for new projects
cargo run -- poll

# Poll and build projects
cargo run -- poll-and-build

# Build all projects
cargo run -- build

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

### Endpoints Used

- `GET /api/v3/project` - List projects
- `GET /api/v3/result/{id}` - Download project result

### Authentication

Set your API key using:

```bash
# Via environment variable
export ARISTOTLE_API_KEY=your_key_here

# Or via the CLI
cargo run -- configure set --api-key your_key_here
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
