---
name: "cargo-vendormod-whitespace-access"
description: "Strip, normalize, and sanitize untrusted text, file contents, command output, filenames, user-supplied input, and logs before writing them to disk or passing them downstream."
---

# Cargo-Vendormod Whitespace Access

## Sanitize Untrusted Input

```bash
python3 scripts/sanitize_git_refs.py --input refs.txt --output clean.txt
cargo run --bin repo-scan -- sanitize
```

## Normalize File Contents

```rust
use cargo_vendormod::sanitize::normalize_content;
```

## Validate Before Write

```rust
checked_write(dest, content)
```

## Prevent Control-Char / NUL Injection

- Reject `0x00` bytes
- Strip ANSI escapes
- Trim trailing whitespace
