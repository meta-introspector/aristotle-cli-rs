# TASK.md
## Task: Implement Web Deployment UI and Search Functionality

### Overview
Implement a browser-based interface for fetching and deploying Aristotle projects using WebAssembly-compiled binary, and enhance search functionality with shmem export capabilities.

### Key Changes Made
1. Added Web Deployment UI section to README.md with detailed features and architecture
2. Added Search command variants (Search, SearchIndex) to main.rs
3. Added shmem export functions (export_results_to_shmem, export_to_shmem) to search.rs
4. Modified gui2lean4 package dependencies (moved to devDependencies)
5. Updated scripts/make-invite-vaciu.mjs permissions
6. Added search module to cmd/mod.rs
7. Removed deploy module from main.rs
8. Added search functionality with various filtering options

### Deliverables
- Web-based UI for project management and deployment
- Enhanced search functionality with shmem export
- Updated documentation and package configurations
- Maintained backward compatibility where possible

### Dependencies
- Rust WebAssembly compilation
- Nix for development environment
- Cloudflare Pages for deployment
- Playwright for browser automation (in gui2lean4)
- Tantivy for search indexing
- Serde for JSON serialization
- PathBuf for file path handling

### Acceptance Criteria
- Web UI accessible via browser at localhost:8080
- API key management via browser interface
- Project fetching and deployment configuration generation
- Search functionality with filtering by status, files, and input
- Search results exportable to shmem via dasl-planner
- All changes integrated and tested