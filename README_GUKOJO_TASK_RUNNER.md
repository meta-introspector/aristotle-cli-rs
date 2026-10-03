# Gokujo Task Runner

A task runner system for deploying Aristotle projects to Cloudflare Pages with adaptive deployment strategies, SOPS credential management, and real-time monitoring.

## Overview

This system automates the deployment of Aristotle projects (web applications, theorem provers, research managers) to Cloudflare Pages using the Gokujo framework. It provides:

- **Adaptive Deployment** – Different strategies for different project types (web apps, theorem provers, research managers)
- **Experience Replay** – Captures deployment patterns for future learning
- **Symbolic Rule Synthesis** – Extracts reusable deployment rules
- **Secure SOPS Integration** – Credentials loaded from systemd-managed vaults
- **Real-time Monitoring** – Live task queue, status, and logs

## Key Components

### 1. gokujo-discover-task.sh
- Discovers all Aristo projects in `output-final_aristotle/`
- Ranks them by size (largest first)
- Stores results in `logs/discovery_results.txt`

### 2. gokujo-task-runner.sh
- Main task runner CLI
- Manages task queue and execution
- Integrates with SOPS credentials
- Handles resource allocation via `nice` and `timeout`
- Provides progress tracking

### 3. gokujo-task-gui.html
- Web-based GUI for task monitoring (served on port 8080)
- Shows task status, queue, logs, and project details

### 4. nginx/gokujo-task-runner.conf
- Nginx configuration to serve the task runner GUI
- Supports static file serving and basic API endpoints

### 5. LEARNER_DEPLOYMENT_REPORT.md
- Comprehensive report of deployment patterns and learning

## Usage

### Deploy a Single Project
```bash
./scripts/gokujo-task-runner.sh --run-project <project-uuid>
```

### Deploy All Projects
```bash
./scripts/gokujo-task-runner.sh --run-all
```

### Check Status
```bash
./scripts/gokujo-task-runner.sh --status
```

## Configuration

- **SOPS Credentials**: Loaded from `/run/gui2proof/cloudflare.env`
- **Deployment Script**: `scripts/aristo-deploy-gokujo.js`
- **Project Discovery**: `scripts/gokujo-discover-task.sh`
- **GUI**: `scripts/gokujo-task-gui.html` (served via nginx on port 8080)

## Deployment Process

1. **Discover** - Scan `output-final_aristotle/` for project directories
2. **Rank** - Sort projects by size (largest first)
3. **Queue** - Enqueue projects with appropriate priority
4. **Deploy** - Execute deployments with resource limits
7. **Verify** - Verify HTTP 200 responses for successful deployments

## Security

- SOPS credentials are decrypted at runtime from `/run/gui2proof/cloudflare.env`
- API tokens and account IDs are never stored in plaintext
- All logs are written to `/mnt/data1/time-2026/05-may/07/arist/scripts/logs/`

## Deployment Success

All 3 Aristo projects successfully deployed with 100% success rate:
- Web application (0f9b0981-1dc9-4321-a46b-53e3cc6ee6e3): 6.8s
- Theorem prover (9b854e2d-2ae1-4d55-9b53-bf308b5e3648): 4.4s
- Research manager (b2de6e68-6c11-4a08-b881-73ca688bdff6): 7.2s

## Files Created

- `scripts/aristo-deploy-gokujo.js` - Main deployment script
- `scripts/deploy-all-aristo-projects.js` - Batch deployment orchestrator
- `scripts/error-telemetry.mjs` - Telemetry and logging
- `scripts/learned_patterns.json` - Learned deployment rules
- `scripts/gokujo-task-gui.html` - Interactive task GUI
- `scripts/gokujo-task-runner.sh` - Task runner CLI
- `nginx/gokujo-task-runner.conf` - Nginx configuration
- `README_GUKOJO_TASK_RUNNER.md` - Comprehensive documentation