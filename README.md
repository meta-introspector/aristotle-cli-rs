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

### Deploy a Project

```bash
# Deploy to a local directory (default)
cargo run -- deploy <project-id>

# Deploy to Cloudflare Pages
cargo run -- deploy <project-id> --cloudflare --name <wrangler-project-name>
cargo run -- deploy <project-id> --cloudflare --name <wrangler-project-name> --public
cargo run -- deploy <project-id> --cloudflare --name <wrangler-project-name> --domain example.com
```

#### Cloudflare Pages Deployment

Deploy Lean4 projects to [Cloudflare Pages](https://pages.cloudflare.com) using
`wrangler`. Prerequisites:

1. **Install wrangler**: `npm install -g wrangler` (or use nix: `nix run wrangler`)
2. **Cloudflare API token**: Write a raw token to `~/.cloudflare` or set the
   `CLOUDFLARE_API_TOKEN` environment variable.
3. **Cloudflare Account ID**: Set the `CLOUDFLARE_ACCOUNT_ID` environment variable.
   If not set, a default account ID is used for the built-in token.

The deploy command:

- Creates a Pages project via `wrangler pages project create` (if it does not
  already exist).
- Deploys the project directory via `wrangler pages deploy --project-name <name>
  --commit-dirty=true`.
- If a `site/` subdirectory exists inside the project directory, that directory
  is deployed instead (useful for projects with a nested web root).
- Public pages are the default for Cloudflare Pages; use `--public` to make the
  intent explicit.

#### Custom Domain

`wrangler` v4.x does not support `pages domain add`. When `--domain` is
specified, the command prints manual instructions: visit the Cloudflare
Dashboard for the project and add the custom domain, or call the
`POST /accounts/{account_id}/pages/projects/{project_name}/domains` API.

```bash
cargo run -- deploy <project-id> --cloudflare --name <project-name> --domain example.com
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

## Web Deployment UI

A browser-based interface for fetching and deploying Aristotle projects using the WebAssembly-compiled `aristotle-manager` binary.

### Features

- **API Key Management**: Set your Aristotle API key in the browser
- **Project Fetching**: Fetch projects from the Aristotle API
- **Cloudflare Pages Deployment**: Generate deployment configs and instructions for deploying to Cloudflare Pages
- **WASM Integration**: Uses compiled WebAssembly module for direct API calls from the browser

### Architecture

The WebAssembly module (`aristotle_wasm.wasm`) is compiled from Rust and exposes the following functions to JavaScript:

- `init_panic_hook()` - Initialize error handling
- `set_api_key(key)` - Set the Aristotle API key
- `get_api_key()` - Get the current API key
- `fetch_project_list()` - Fetch project list from Aristotle API
- `fetch_project(project_id)` - Fetch a specific project
- `deploy_project(project_id, project_name, domain)` - Generate deployment instructions
- `generate_deploy_config(project_id, project_name, domain)` - Generate deployment configuration
- `get_deploy_instructions(project_id, project_name, domain)` - Get deployment instructions
- `validate_project_id(project_id)` - Validate a UUID format
- `get_cloudflare_account_id()` - Get the default Cloudflare account ID
- `get_cloudflare_default_domain()` - Get the default Cloudflare Pages domain

### How to Run

#### Option 1: Simple HTTP Server

```bash
cd www
node serve.js [port]
```

Then open `http://localhost:8080` in your browser.

#### Option 2: Cloudflare Pages

Deploy the contents of the `www/` directory to Cloudflare Pages for a public deployment.

#### Option 3: Static Hosting

Serve the files via any static hosting service (nginx, Apache, etc.).

### Building

```bash
cd aristotle-wasm
cargo build --target wasm32-unknown-unknown --release
wasm-bindgen target/wasm32-unknown-unknown/release/aristotle_wasm.wasm --out-dir ../www --target web
```

### Files

- `index.html` - Main web UI
- `aristotle_wasm.js` - JavaScript bindings for WASM module
- `aristotle_wasm_bg.wasm` - Compiled WebAssembly binary
- `aristotle_wasm.d.ts` - TypeScript type definitions
- `package.json` - Package metadata
- `serve.js` - Simple HTTP server

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please open an issue or pull request for any questions or suggestions.
