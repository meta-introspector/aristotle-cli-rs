---
name: "ipld-memory"
description: "IPLD CAR shared memory backend for agent memory. Store, retrieve, and manage memory blocks via content-addressed CAR pages."
---

# IPLD Memory

> Agent memory backed by IPLD CAR shared memory.
> Each memory block is a CAR page, content-addressed by SHA-256 CID.
> Zero-copy mmap access via Unix socket IPC.

## When to Use

- Agent needs persistent memory that survives process restarts
- Memory blocks need content-addressed deduplication
- Zero-copy access is needed (fuzzers, large context windows)
- Multiple agents share the same memory server

## Architecture

```text
  @ipld_car_shmem (Unix abstract socket)
           │
   ┌───────┼───────┐
   │       │       │
   ▼       ▼       ▼
Agent A  Agent B  Agent C
   │       │       │
   └───────┼───────┘
           │
   ┌───────▼────────┐
   │  CarStore      │
   │  pages.bin     │  ← mmap ring buffer (36GB sparse)
   │  blocks.json   │  ← path → CID index
   │  index.car     │  ← CID → offset index
   └────────────────┘
```

## Commands

```bash
# Start the server (background)
ipld-car-shmem-server &

# Store a memory block
echo "My memory content" | letta-ipld-memory put system/persona "Agent persona"

# Retrieve a memory block
letta-ipld-memory get system/persona

# List all blocks
letta-ipld-memory list

# String replacement
letta-ipld-memory str-replace system/persona "old text" "new text"

# Insert at line
letta-ipld-memory insert system/persona 5 "inserted line"

# Delete a block
letta-ipld-memory delete system/persona

# Rename a block
letta-ipld-memory rename old/path new/path

# Check existence
letta-ipld-memory exists system/persona && echo "exists"
```

## Environment

| Variable | Default | Description |
|----------|---------|-------------|
| `LETTA_MEMORY_BACKEND` | `git` | Set to `ipld` to use IPLD backend |
| `IPLD_CAR_CACHE_PATH` | `/mnt/data1/dasl-cache` | Cache directory for pages.bin |
| `IPLD_CAR_CAPACITY` | `38654705664` | Ring buffer size (36GB) |

## Wire Protocol

LibAFL-compatible: 4-byte BE length prefix + postcard-serialized request.
Responses carry optional file descriptor via `sendmsg`/`recvmsg`.

| Request | Description |
|---------|-------------|
| `PutBlock(path, desc, read_only, content)` | Store memory block, get CID |
| `GetBlock(path)` | Retrieve block by path |
| `ListBlocks` | List all blocks (JSON) |
| `DeleteBlock(path)` | Delete block by path |
| `UpdateBlockDescription(path, desc)` | Update block description |

## Comparison with Git-backed Memory

| Feature | Git-backed | IPLD-backed |
|---------|-----------|-------------|
| Storage | Files on disk | CAR pages in mmap ring buffer |
| Indexing | Git tree + filesystem | CID index + path index |
| Sync | git push/pull to remote | No remote needed (local mmap) |
| Content addressing | SHA-1 (git) | SHA-256 (CID) |
| Zero-copy | No | Yes (mmap + fd passing) |
| History | Full git history | No history (ring buffer overwrites) |
| Concurrency | File locks | Unix socket serialization |

## Nix Integration

```nix
# flake.nix
inputs.ipld-car-ipc-shmem-linux.url = "git+file:///home/mdupont/dasl/ipld-car-ipc-shmem-linux";

# In package PATH:
letta-ipld-memory  # CLI bridge
ipld-car-shmem-server  # Server daemon
ipld-car-shmem-client  # Raw CAR client
```

## Related

- [[skills/cron]] — Schedule periodic memory compaction
- [[skills/context-doctor]] — Repair degraded memory blocks
- [[skills/harness-config]] — Configure `LETTA_MEMORY_BACKEND=ipld`
