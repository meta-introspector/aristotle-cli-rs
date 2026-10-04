# GitHub Actions ACLs — gokujo deploy

Principle: each job gets the least credential that lets it run, and
secrets are scoped per job, never workflow-global.

## Secrets (repo-level, set with `gh secret set`)

| Secret | Scope | Used by job | Notes |
|---|---|---|---|
| `CLOUDFLARE_API_TOKEN` | Workers Scripts:Edit, single account | `cloudflare-publish` only | Create at dash.cloudflare.com → My Profile → API Tokens → "Edit Cloudflare Workers" template, restricted to the one account |
| `CLOUDFLARE_ACCOUNT_ID` | not secret, but kept as secret for env hygiene | `cloudflare-publish` only | `3d7608549b2fb58c0ce446bc3c5892ed` |

## GITHUB_TOKEN permissions

Workflow-level: `contents: read` (minimum for every job).
Only `publish-artifacts` escalates with a job-level `contents: write`
for the release upload. Compile jobs cannot push or create releases
even if a script is compromised.

## Environment protection (optional, recommended)

Create a `production` environment and assign `cloudflare-publish` to
it, so deploys require a reviewer or run only on protected branches:

```bash
gh api repos/meta-introspector/aristotle-cli-rs/environments/production -X PUT
```

## Job-level credential flow

```
mathlib-oleans   → no secrets (public clone + cache)
compile-split    → no secrets (lean + LEAN_PATH cache)
publish-artifacts→ GITHUB_TOKEN (contents: write, release only)
cloudflare-publish → CLOUDFLARE_API_TOKEN + CLOUDFLARE_ACCOUNT_ID (this job only)
```

The Cloudflare token never appears in a compile job's environment, so a
compromised dependency in the compile path cannot reach the edge.
