# Lean-Worker Gokujo Pipeline Documentation

## Overview

This document documents the steps for the **lean-worker gokujo** pipeline used to integrate, verify, and publish Lean projects through the Aristotle system.

## Part 1: Lean Build & Verification Pipeline

### 1. Core Lean Build
**Steps:**
```bash
# Initialize shared cache
cd /project/path
export LEAN_SHARED_CACHE_ROOT=/mnt/data1/lake-cache

# Build core Lean project
lake build RequestProject.YourProject

# Expected result: 8032 jobs compiled (Mathlib + your project)
```

**Key Points:**
- Uses shared mathlib cache at `/mnt/data1/lake-cache`
- Requires Lean 4.28.0 (specified in `lean-toolchain`)
- Build process: Mathlib → Your project validation
- Failure points: missing Lean files, cache issues, build timeout

### 2. Instance Kernel-Checking
**Steps:**
```bash
# Run kernel-checker for specific instances
cd /project/path
set -euo pipefail
bash hodge-vm/tools/build_instances.sh 1800 Contact46006 M3Coupled
```

**Key Points:**
- Kernel-checker scans all instances in project
- Each shard runs independently
- 576 shards for M3Coupled: ~33h on single machine
- Need to monitor instance build status
- Build logs: `/project/path/hodge-vm/tests/instance-logs/`

### 3. Differential Testing
**Steps:**
```bash
# Run all test suites
cd /project/path
node hodge-vm/tests/test_vm.js
node hodge-vm/tests/test_claims.js
bash hodge-vm/tools/axiom_audit.sh
```

**Key Points:**
- Verify: WASM VM, JS VM, Lean oracle, Python checker
- Test golden vectors for all instances
- Check axiom audit for clean axiom set
- All engines must agree (0 disagreements)

### 4. Archive & Save Status
**Steps:**
```bash
# Save project status
cd /project/path
./target/release/aristotle-manager archive save --project your-id

# Save build logs
./target/release/aristotle-manager archive logs --project your-id
```

**Key Points:**
- Use `aristotle_manager` archive system
- Save project status and build logs
- Critical for audit trail and debugging

## Part 2: Aristotle Integration Pipeline

### 1. Project Structure Setup
**Required files/directories:**
```
/RequestProject/YourProject/
  ├── *.lean           # Lean source files
  ├── lakefile.toml   # Lake project configuration
  ├── lean-toolchain   # Lean version
  ├── README.md        # Project documentation
  └── ARISTOTLE_SUMMARY.md

/www/                 # Static web interface
  ├── index.html       # Main project page
  ├── web/             # Web applications
  └── api/             # API endpoints

/README.md            # Project documentation
```

### 2. Aristotle Deployment
**Steps:**
```bash
# Deploy to nginx/static web
cd /project/path
./target/release/aristotle-manager deploy --format html

# Verify nginx deployment
curl https://aristotle.harmonic.fun/aristo/your-project/
```

**Key Points:**
- Uses existing `aristotle-manager` deploy command
- Generates static site (HTML pages)
- Uploads to nginx static root

### 3. Systemd Service Integration
**Systemd template:**
```ini
[Unit]
Description=Aristotle Project {project-id}
After=network.target

[Service]
Type=simple
User=mdupont
Group=mdupont
WorkingDirectory=/project/path/{project-id}
Environment=HOME=/home/mdupont
Environment=PATH=/home/mdupont/.elan/bin:/home/mdupont/.nix-profile/bin:/usr/local/bin:/usr/bin:/bin
ExecStart=/project/path/target/release/aristotle-manager serve --port 9876 --forward
Restart=on-failure
RestartSec=5s
KillSignal=SIGINT
TimeoutStopSec=15s
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full
ProtectHome=read-only

[Install]
WantedBy=multi-user.target
```

**Key Points:**
- Uses same template as Hodge VM
- Service name: `aristotle-manager-{project-id}.service`
- Forward port: 9876 (API endpoints)
- Runs as user `mdupont` with security constraints

## Part 3: Testing & Validation Pipeline

### 1. Go-Test Suite
**Steps:**
```bash
# Run Go tests
cd /project/path
make test
```

**Key Points:**
- Tests cover deployment scripts
- Validates static site generation
- Checks systemd service files
- Runs integration tests

### 2. Lint & Formatting
**Steps:**
```bash
# Lint check
cd /project/path
cargo clippy --all-targets -- -D warnings

# Format check
cd /project/path
rustfmt --check src/
```

### 3. Integration Testing
**Steps:**
```bash
# Test deployment flow
cd /project/path
./target/release/aristotle-manager test

# Test verification
cd /project/path
./target/release/aristotle-manager verify --project your-id
```

## Part 4: Cloudflare Pipeline

### 1. Cloudflare Pages Deployment
**Steps:**
```bash
# Deploy with Cloudflare credentials
cd /project/path
./scripts/deploy-cloudflare.sh deploy

# Deploy Hodge VM example
cd /mnt/data1/time-2026/05-may/07/arist
./scripts/deploy-hodge-cloudflare.sh deploy
```

**Key Points:**
- Requires valid Cloudflare credentials
- Uses Wrangler CLI (v4.62.0)
- Deploys static sites to Cloudflare Pages
- Must have `../create_static_site.py` script ready

### 2. Deployment Validation
**Steps:**
```bash
# Verify Cloudflare deployment
curl https://aristotle.harmonic.fun/aristo/your-project/

# Test API endpoints
curl https://aristotle.harmonic.fun/aristo/api/your-project/status
```

## Part 5: Monitoring & Maintenance

### 1. Log Monitoring
**Steps:**
```bash
# Monitor service logs
systemctl status aristotle-manager-{project-id}
journalctl -u aristotle-manager-{project-id} -f

# Monitor nginx logs
tail -f /var/log/nginx/aristo-access.log
```

### 2. Health Checks
**Steps:**
```bash
# Health check endpoint
curl -f https://aristotle.harmonic.fun/aristo/health

# API health check
curl -f https://aristotle.harmonic.fun/aristo/api/your-project/health
```

## Part 6: Security & PII Review

### 1. PII Audit
**Steps:**
```bash
# Find PII in codebase
grep -r "user@\|email@\|person\|person_name" /project/path/src --include="*.rs" --include="*.py"

# Check for sensitive data
grep -r "password\|secret\|token" /project/path/config/ --include="*.toml" --include="*.yaml"
```

### 2. Security Checklist
**Review items:**
- ✅ No hardcoded passwords/tokens
- ✅ Environment variables configured properly
- ✅ Access controls in place
- ✅ Audit logging enabled
- ✅ Error messages don't leak sensitive info

## Part 7: Code Quality & Coverage

### 1. Coverage Requirements
**Minimum coverage:**
- ✅ Go tests: 100%
- ✅ Rust tests: 80%
- ✅ Integration tests: 70%

### 2. Code Quality Standards
**Check with:**
```bash
# Code formatting
cd /project/path
cargo fmt --check

# Documentation
cd /project/path
cargo doc --open

# Security audit
cd /project/path
audit-rs
```

## Deployment Sequence

For a new project, the deployment pipeline is:

1. **Setup** (Day 1):
   - Create project directory with Lean files
   - Configure `lakefile.toml`, `lean-toolchain`
   - Write `README.md` documentation

2. **Build & Verify** (Day 1-2):
   - Run core Lean build
   - Perform kernel-checking
   - Run differential tests
   - Complete axiom audit

3. **Deploy** (Day 3):
   - Deploy to nginx/static web
   - Create systemd service
   - Test deployment flow

4. **Cloudflare** (Day 4):
   - Replace placeholder credentials
   - Deploy to Cloudflare Pages
   - Final verification

## Troubleshooting

### Common Issues

**Lean build fails:**
```bash
# Check for missing files
lake list
lake check

# Check cache
cd /project/path
export LEAN_SHARED_CACHE_ROOT=/mnt/data1/lake-cache
cargo clean
```

**Instance build timeout:**
```bash
# Reduce shard count for testing
bash hodge-vm/tools/build_instances.sh 60 Contact46006 M3Coupled

# Check instance status
cat hodge-vm/tests/instance-build-status.tsv
```

**Nginx deployment issues:**
```bash
# Check nginx config
nginx -t

# Check service status
systemctl status aristotle-manager
```

**Cloudflare deployment fails:**
```bash
# Check credentials
source /run/gui2proof/cloudflare.env
wrangler whoami
```

## Best Practices

### 1. Lean Code
- Use `//` comments for documentation
- Follow Lean coding conventions
- Use explicit types and namespaces

### 2. Rust Code
- Use `cargo clippy` for linting
- Follow Rust formatting standards
- Use structured error handling

### 3. Deployment
- Use environment variables for configuration
- Keep credentials separate from code
- Test deployment in staging first

### 4. Monitoring
- Enable structured logging
- Set up health checks
- Monitor resource usage

## Success Criteria

A project is considered fully deployed when:

1. ✅ Core Lean build succeeds
2. ✅ All instances kernel-checked (80%+ of total)
3. ✅ Differential tests pass (0 disagreements)
4. ✅ Axiom audit completes cleanly
5. ✅ Static site deployed to nginx
6. ✅ Systemd service running
7. ✅ API endpoints accessible
8. ✅ Cloudflare deployment ready (if credentials available)

## References

- [Hodge VM Documentation](/mnt/data1/time-2026/05-may/07/arist/HODGE_VM_DEPLOYMENT_SUMMARY.md)
- [MLVM Verification](/mnt/data1/time-2026/05-may/07/arist/MLVM_VERIFICATION_SUMMARY.md)
- [Aristotle Manager API](/mnt/data1/time-2026/05-may/07/arist/src/lean_worker.rs)
- [Systemd Service Template](/mnt/data1/time-2026/05-may/07/arist/src/deploy.rs)

---
*Document generated: 2026-10-22*
*For lean-worker gokujo pipeline questions, refer to this documentation.*

## Quick Commands Summary

```bash
# Build and verify
cd /project/path
export LEAN_SHARED_CACHE_ROOT=/mnt/data1/lake-cache
lake build RequestProject.YourProject
bash hodge-vm/tools/build_instances.sh 1800 Contact46006
node hodge-vm/tests/test_vm.js
./target/release/aristotle-manager deploy

# Deploy to systemd
systemctl enable aristotle-manager-{project-id}
systemctl start aristotle-manager-{project-id}

# Cloudflare deployment
./scripts/deploy-cloudflare.sh deploy
```