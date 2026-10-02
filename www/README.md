# Aristotle Web Deployment UI

A browser-based interface for fetching and deploying Aristotle projects using the WebAssembly-compiled `aristotle-manager` binary.

## Features

- **API Key Management**: Set your Aristotle API key in the browser
- **Project Fetching**: Fetch projects from the Aristotle API
- **Cloudflare Pages Deployment**: Generate deployment configs and instructions for deploying to Cloudflare Pages
- **WASM Integration**: Uses compiled WebAssembly module for direct API calls from the browser

## How to Run

### Option 1: Simple HTTP Server

```bash
cd www
node serve.js [port]
```

Then open `http://localhost:8080` in your browser.

### Option 2: Cloudflare Pages

Deploy the contents of the `www/` directory to Cloudflare Pages for a public deployment.

### Option 3: Static Hosting

Serve the files via any static hosting service (nginx, Apache, etc.).

## Architecture

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

## Building

```bash
cd aristotle-wasm
cargo build --target wasm32-unknown-unknown --release
wasm-bindgen target/wasm32-unknown-unknown/release/aristotle_wasm.wasm --out-dir ../www --target web
```

## Files

- `index.html` - Main web UI
- `aristotle_wasm.js` - JavaScript bindings for WASM module
- `aristotle_wasm_bg.wasm` - Compiled WebAssembly binary
- `aristotle_wasm.d.ts` - TypeScript type definitions
- `package.json` - Package metadata
- `serve.js` - Simple HTTP server