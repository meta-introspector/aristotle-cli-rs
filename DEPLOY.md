# Deployment Instructions - Orion Merged Workspace

This guide explains how to deploy the merged Aristotle projects to Cloudflare Pages as "orion".

## Prerequisites

1. **aristotle-manager binary**: Build the CLI tool from `src/`:
   ```bash
   cargo build --release
   ```
   The binary is expected at `target/release/aristotle-manager`.

2. **SOPS credentials**: Deployment requires Cloudflare credentials stored in a SOPS-encrypted registry.
   - Registry file: `/mnt/data1/kant/pastebin/.sops/registry.sops.yaml`
   - Age key file: `~/.config/sops/age/keys.txt`
   - Required fields in the registry (already set up, do **not** add keys here):
     - `CLOUDFLARE_ACCOUNT_ID`
     - `CLOUDFLARE_API_TOKEN`

3. **wrangler**: Install the Cloudflare Wrangler CLI for Pages deployment:
   ```bash
   npm install -g wrangler
   ```

## Project Selection

Two Aristotle projects are tracked in the `merged-projects/` workspace:

| Project ID | Label | Status |
|-------------|-------|--------|
| `17da0589-2bfc-44c4-8169-dbdb61676da2` | project-17da0589 | newer, active (current default) |
| `0f9b0981-20e1-40ac-8da1-7ea508d9520c` | project-0f9b0981 | older |

Each project source is symlinked:
- `merged-projects/project-17da0589/sources/lean` -> original download
- `merged-projects/project-0f9b0981/sources/lean` -> original download

## How to Review and Merge

1. **Prepare the merged workspace**:
   ```bash
   ./merged-projects/merge-projects.sh
   ```
   This creates `merged-projects/merged/` with a flat tree and generates
   `merged-projects/MERGED_CONFLICTS.md` flagging duplicate files.

2. **Review differences** in `merged-projects/PROJECT-COMPARISON.md`.

3. **Resolve conflicts** listed in `MERGED_CONFLICTS.md`.

## How to Deploy

Use the deploy script. It fetches credentials from SOPS automatically —
you should **never** paste API tokens directly into commands or files.

```bash
# Deploy the default newer project (17da0589)
./deploy-orion.sh

# Deploy a specific project by ID
./deploy-orion.sh 0f9b0981-20e1-40ac-8da1-7ea508d9520c

# Fetch and deploy the newest completed project from the API
./deploy-orion.sh --latest

# Preview the deployment without pushing (dry-run)
./deploy-orion.sh --dry-run

# Force a fresh bundle download/build
./deploy-orion.sh --build
```

The script performs these steps:
1. Decrypts Cloudflare credentials via `sops`
2. Downloads or reuses the project bundle from the Aristotle API (unless `--build` is passed)
3. Creates the Cloudflare Pages project if it does not exist
4. Deploys via `wrangler pages deploy <path> --project-name orion --commit-dirty=true`

### Dry-run output

`./deploy-orion.sh --dry-run` prints the exact `wrangler` command and
deploy path without executing it. Review this before any production deploy.

## Deployment History

See `DEPLOY_HISTORY.md` for a log of past deployments.

## Security Notes

- SOPS-encrypted credentials are **not** stored in this repo.
- The `age` keys file at `~/.config/sops/age/keys.txt` must exist on the
  machine running the deploy.
- Never commit credentials, tokens, or `.sops.yaml` files to Git.
