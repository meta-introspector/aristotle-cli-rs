# SYSTEM.md
## System Integration Details

### Architecture Overview
The system integrates a Rust-based CLI with a browser-based Web UI through WebAssembly compilation. The key components include:

1. **Aristotle Manager (Rust CLI)** - Core command-line tool
2. **Web UI (WASM)** - Browser-based interface
3. **Search Index** - Tantivy-backed search capability
4. **Shmem Export** - Integration with DASL planner
5. **Configuration** - CLI config file and environment variables

### Component Relationships

```
┌─────────────────────────────────────────────────────────────┐
│                    Web Browser                              │
│  ┌─────────────────┐  ┌─────────────────────────────┐  │
│  │   index.html    │  │ aristotle_wasm.js (JS)        │  │
│  └──────┬──────────┘  └───────┬─────────────────────┘  │
│          │                       │                     │
│          │  WASM Module        │                     │
│          ▼                       ▼                     │
│  ┌─────────────────┐  ┌─────────────────────────────┐  │
│  │   WASM (Rust)   │  │ JavaScript API Calls        │  │
│  └──────┬──────────┘  └───────┬─────────────────────┘  │
│          │                       │                     │
└──────────▼────────────────────▼─────────────────────────┘
                │
                ▼
         ┌─────────────────────┐
         │       Rust CLI      │
         │   cargo run -- ... │
         └───────┬─────────────┘
                 │
                 ▼
        ┌─────────────────────┐
        │   Tantivy Index     │
        │ ~/.config/aristotle │
        │  manager/search-index│
        └─────────────────────┘
```

### Data Flow
1. User sets API key via Web UI → stored in WASM module
2. Web UI fetches projects via API → displays list
3. User initiates search → tantivy index queried
4. Results exported to shmem → available to dasl-planner
5. Deployment configs generated → pushed to Cloudflare Pages

### Configuration Management
- Primary config: `~/.config/aristotle-manager/config.toml`
- Environment variables: `ARISTOTLE_API_KEY`, `CLOUDFLARE_API_TOKEN`, etc.
- CLI config: `configure set --api-key YOUR_KEY`

### Dependencies
- **Rust crates**: clap, serde, serde_json, anyhow, tantivy
- **Nix packages**: openssl, pkg-config, libgit2
- **Web dependencies**: playwright (gui2lean4), wasm-bindgen
- **External**: wrangler for Cloudflare deployment, curl for API calls

### Build Pipeline
```
1. Source Code → Cargo.toml → cargo build
2. Rust → wasm32-unknown-unknown → wasm-bindgen → www/
3. www/ → Cloudflare Pages or static hosting
4. Search Index → ./search-index → shmem export
```

### Integration Points
- `scripts/make-invite-vaciu.mjs` - Vaciu integration
- `deploy-lean-worker.sh` - Lean worker deployment
- `deploy-cf.sh` - Cloudflare deployment
- `split-scripts` - Split project scripts (submodule)
- `gui2lean4/` → Playwright automation