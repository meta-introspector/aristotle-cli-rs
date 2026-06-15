---
name: librarian
description: >-
  Research open-source library internals. Clone, index, and navigate dependency
  source code with GitHub permalinks. Use when you need to understand how a
  library works internally, trace a bug into a dependency, or find the
  implementation behind an API.
---

# Librarian — Dependency Source Research

Research open-source library internals by cloning repos to the local git
mirror store, indexing key files, and producing GitHub permalink references.

---

## When to Use

- "How does library X implement feature Y?"
- "Trace this bug into the dependency"
- "Find the source of this API function"
- "What version of crate Z is actually being used?"

## Steps

**1. Identify the target**

From the user's question, extract:
- Library/crate name
- Specific function, module, or feature (if mentioned)
- Version constraint (if relevant)

**2. Check the local mirror store**

```bash
ls /mnt/data1/git/github.com/<owner>/<repo>.git/
```

If the mirror exists, skip to step 4. If not, continue.

**3. Clone the mirror**

```bash
git clone --mirror https://github.com/<owner>/<repo>.git /mnt/data1/git/github.com/<owner>/<repo>.git
```

For crates.io packages, resolve the GitHub repo from the Cargo.toml or
crates.io API:

```bash
curl -s https://crates.io/api/v1/crates/<name> | jq '.repository'
```

**4. Clone a working copy for browsing**

```bash
git clone /mnt/data1/git/github.com/<owner>/<repo>.git /tmp/librarian-<repo>
cd /tmp/librarian-<repo>
```

Check out the specific version tag if known:

```bash
git tag -l 'v*' | sort -V | tail -5
git checkout v<version>
```

**5. Index the relevant files**

Find the files that matter:

```bash
# For Rust crates
find src/ -name '*.rs' | head -30

# For Go modules
find . -name '*.go' -not -path './vendor/*' | head -30

# For Python packages
find src/ -name '*.py' | head -30

# Search for a specific symbol
rg 'fn <function_name>' src/
rg 'pub fn <function_name>' src/
rg 'def <function_name>' src/
```

**6. Read the relevant source**

Read the files identified in step 5. Focus on:
- The function/method implementation
- Its type signatures and constraints
- Error handling paths
- Any inline documentation or comments

**7. Produce GitHub permalinks**

For every file referenced in the response, generate a permalink:

```
https://github.com/<owner>/<repo>/blob/<commit-sha>/<path>#L<line>
```

Get the commit SHA:

```bash
git rev-parse HEAD
```

**8. Summarize findings**

Structure the response:

```
## <library> — <feature>

**Version:** <tag> (<commit-sha-short>)
**Source:** <github-permalink>

### How it works
<explanation with code references>

### Key files
- <file>: <role> — <permalink>
- <file>: <role> — <permalink>

### Notable patterns
- <pattern 1>
- <pattern 2>
```

## Guardrails

- Never modify files in the mirror store (`/mnt/data1/git/`)
- Working copies go to `/tmp/librarian-*` — ephemeral, no cleanup needed
- If the repo is large, use `--depth 1` or `--single-branch` for the working copy
- Always pin permalinks to a specific commit SHA, never to `main` or `master`
- If the library is not on GitHub, note the source location (GitLab, Bitbucket, etc.)
- For private repos, check if the mirror already exists before attempting to clone

## Related

- `graphify` — for building knowledge graphs from source
- `diff-review` — for comparing versions of a dependency
- `nix-foundation` task — for vendoring libraries into Nix flakes
