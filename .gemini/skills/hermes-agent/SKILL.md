---
name: "hermes-agent"
description: "Configure and use Hermes Agent CLI, including setup, configuration, and common operations."
---

# Hermes Agent Configuration and Usage

## Trigger
When the user asks about configuring, setting up, using, or troubleshooting Hermes Agent itself—including its CLI, configuration, models, providers, tools, skills, or general usage.

## Workflow
1. **Start interactive chat**
   ```bash
   hermes
   ```

2. **Run the interactive setup wizard** (recommended for first-time configuration)
   ```bash
   hermes setup
   ```
   This guides you through selecting models, providers, toolsets, and other basic settings.

3. **View current effective configuration**
   ```bash
   hermes config
   ```
   Shows merged configuration from defaults, `~/.hermes/config.yaml`, environment variables, and any overrides.

4. **Get a specific configuration value**
   ```bash
   hermes config get <key>
   ```
   Example: `hermes config get model`

5. **Set a configuration value** (persists to `~/.hermes/config.yaml`)
   ```bash
   hermes config set <key> <value>
   ```
   Examples:
   - `hermes config set model anthropic/claude-sonnet-4`
   - `hermes config set provider openrouter`
   - `hermes config set toolsets terminal,file,web`

6. **Unset a configuration value** (reset to default)
   ```bash
   hermes config unset <key>
   ```

7. **Edit the configuration file directly**
   ```bash
   hermes config edit
   ```
   Opens `~/.hermes/config.yaml` in your `$EDITOR`. Changes take effect for new sessions after saving.

8. **Override settings per invocation** (temporary)
   - Model: `hermes -m <model>`
   - Provider: `hermes -p <provider>`
   - Toolsets: `hermes -t <toolset1>,<toolset2>`
   - One-shot mode: `hermes -z \"prompt\" -m <model> -p <provider>`

9. **Verify configuration and dependencies**
   ```bash
   hermes doctor
   ```
   Checks for issues with configuration, credentials, and dependencies.

10. **Manage sessions** (optional)
    - List sessions: `hermes sessions list`
    - Resume most recent: `hermes -c`
    - Resume by name: `hermes -c \"session name\"`
    - Resume by ID: `hermes --resume <session_id>`

## Configuration Keys
- `model`: Default model identifier (e.g., `anthropic/claude-sonnet-4`, `openrouter/meta/llama-3-70b-instruct`)
- `provider`: Default inference provider (e.g., `openrouter`, `anthropic`)
- `toolsets`: Comma-separated list of toolsets to enable by default (e.g., `terminal,file,web,skills`)
- `history_size`: Number of past sessions to keep in the UI
- `log_level`: Logging verbosity (`debug`, `info`, `warn`, `error`)

## Environment Variables
- `HERMES_INFERENCE_MODEL` → overrides `model`
- `HERMES_INFERENCE_PROVIDER` → overrides `provider`
- `HERMES_TOOLSETS` → overrides `toolsets` (comma-separated)

## Common Pitfalls
- Changes to `~/.hermes/config.yaml` only affect new sessions; existing sessions continue with the configuration they started with.
- If you set `toolsets` via environment variable or CLI flag, it may override the config file value unexpectedly.
- Some commands (like `hermes model` or `hermes fallback`) provide interactive pickers; they also update the underlying config.

## References
 - Removing false mathematical claims: Replace fake metrics with honest measurements and reference formal verifications (e.g., Lean 4 work).
 - See `references/hermes-help.txt` for full `hermes --help` output.
 - See `references/user-preference.md` for user communication preferences.
 - See `references/nora-auth-workflow.md` for Nora authentication workflow details.
 - See `references/extension-boundary.md` for extension boundary rules.
 - See `references/rust-nix-build-troubleshooting.md` for Rust/Nix build troubleshooting techniques.
 - Official documentation: https://hermes-agent.nousresearch.com/docs

## Related Skills
- None currently; this skill covers general Hermes Agent usage and configuration.

## Session Notes
- Reviewing outstanding changes is a common task when using Hermes Agent to understand project modifications.
- This session focused on Nora authentication workflows and DASL/IPLD-Core testing infrastructure analysis.

## Communication Style & Workflow Principles
- **Conciseness First**: Provide direct answers with proven facts (commands, file paths, evidence) over lengthy explanations. When discussing technical details, prioritize clear evidence like source code analysis or crash generation over interpretive measurements that may be misleading due to measurement methodology. Avoid independent action without user confirmation for destructive operations.
+**Technology Stack Preference**: Prefer flake.nix for packaging and Rust for implementation over pure bash scripts. While bash is tolerated for skill orchestration (per lattice.md), actively move away from Python and JS implementations when possible. When working with Hermes Agent configuration, prioritize Nix flake patterns and Rust-based solutions.
- **Fuzzing Workflows**: When working with fuzzing, testing, or benchmarking tasks:
  - Structure workflows around Makefile targets that encapsulate full commands with proper environment and variable support (default targets: `fuzz-car`, `load-test-car`, `benchmark-all`)
  - Use `nix develop --command <tool>` for reproducible environments
  - Follow the discovery-first approach: search for existing implementations before creating new ones (check service file indices like `dasl_service.txt` by extracting paths [handling line number prefixes], filtering for actual files, and checking content for both DAG-CBOR/IPLD mentions and test/driver/harness/fuzz/benchmark indicators)
  - Organize testing tools by purpose (fuzz, benches, coverage) in separate directories
  - Leverage existing Makefile patterns with .PHONY targets, descriptive names, and timestamped outputs
- **Documentation Value**: Appreciate comprehensive, organized reference materials; consider adding session-specific details to skill references when they provide lasting value.
- **Existing Implementation Check**: Before creating new approaches, search for existing implementations (e.g., analyze service file indices like `dasl_service.txt` by extracting paths [handling line number prefixes], filtering for actual files, and checking content for both DAG-CBOR/IPLD mentions and test/driver/harness/fuzz/benchmark indicators) to avoid duplicating effort.
- **Hermes Agent Specific**: When configuring or troubleshooting, provide specific commands (`hermes config set/get`), file paths (`~/.hermes/config.yaml`), and verifiable handles rather than general explanations.
- **Nora Workflow**: When working with Nora artifact registry, remember to:
  - Check auth status in `/mnt/data1/nora/config/nora.toml`
  - Use token-based auth for cargo publishing
  - Verify with `curl -u token:<token> http://127.0.0.1:4000/cargo/index/config.json`
  - Restart service after auth config changes: `sudo systemctl restart nora`
  - Common cargo auth approaches: credential process, environment variables, or git credential helper
- **Submodule Workflow**: When working with git submodules (as demonstrated with n0x-pi):
  - Clone mirror: `git clone --mirror <url> ~/git/<path>.git`
  - Add as submodule: `git submodule add <url> <local-path>`
  - Configure remotes: `git remote add local ~/git/<mirror-path>.git` and `git remote add origin ~/git/<fork-path>.git`
  - Rename upstream: `git remote rename origin upstream`
  - Check status: `git submodule status <path>`
- **Rust/Nix Build Troubleshooting**: When building Rust projects in Nix environments:
  - Check Cargo.toml for workspace dependencies that may need to be added (like `whoami`)
  - Verify protobuf optional field handling by setting `PROTOC_GEN_CONFIGURE_OPTIONS=\"--experimental_allow_proto3_optional\"`
  - Create protoc wrappers when needed: `#!/bin/sh\\nprotoc --experimental_allow_proto3_optional \"$@\"`
  - Check for missing features in dependencies (e.g., rmcp needs `[\"transport-child-process\"]` feature)
  - Examine vendor/src/lib.rs to verify function signatures when encountering method not found errors
  - Use `nix develop --command cargo build` for consistent build environments
  - Check target/release/ for built artifacts when nix build fails
  - Remove unnecessary `.unwrap_or_else()` calls when the underlying function already provides defaults
- **Handling Mathematical Claims in Code**: When encountering questionable mathematical claims or metrics in code:
  - Replace fake or arbitrary assignments with honest, measurable metrics
  - Reference formal verifications or proofs when applicable (e.g., Lean 4 work)
  - Focus on transparent analysis rather than invented classifications
  - Document the reasoning for any metrics or classifications used
