---
name: ebpf-perf-event-diagnose
description: >-
  Diagnose and fix the EINVAL error during bpf_map_create in the d8_2a_loader
  eBPF monitoring program. Use when debugging eBPF perf_event issues, checking
  kernel BPF support, or deploying the 0xD8 0x2A register-level monitoring.
---

# Diagnose eBPF perf_event EINVAL Error

**Priority:** HIGH
**Area:** eBPF
**Status:** Pending
**Source:** plan.org

## Problem

The d8_2a_loader userspace binary fails with EINVAL during `bpf_map_create`.
The eBPF .so (3.7KB) compiles successfully but the map creation step fails.

## Infrastructure Already Built

- eBPF program: `aya-nix/d8_2a/` (3.7KB .so)
- Userspace loader: `d8_2a_loader` (1.6MB)
- Nix flake with cargo2nix + bpf-linker
- Systemd service template
- dot-agent skill deployed

## Diagnosis Steps

1. Check kernel version and BPF support:
```bash
uname -r                              # Need >= 5.8 for ringbuf
cat /proc/sys/kernel/perf_event_paranoid  # Should be <= 1 for non-root
bpftool feature list                  # Check available BPF features
```

2. Check map type compatibility:
```bash
# The .so may use BPF_MAP_TYPE_RINGBUF which requires kernel >= 5.8
# Or BPF_MAP_TYPE_PERF_EVENT_ARRAY which needs perf_event_paranoid <= 1
bpftool map dump pinned /sys/fs/bpf/d8_2a 2>/dev/null
```

3. Run with verbose error:
```bash
cd ~/dasl/aya-nix
RUST_LOG=debug ./target/release/d8_2a_loader
```

4. Try alternative map type:
- If ringbuf fails, fall back to perf_event_array
- If perf_event fails, try hash map with userspace polling

## Fix Options

| Option | Change | Kernel Req |
|--------|--------|------------|
| A: Lower perf_event_paranoid | sysctl or CAP_SYS_ADMIN | Any |
| B: Switch to BPF_MAP_TYPE_ARRAY | Remove perf_event dependency | >= 4.15 |
| C: Use ringbuf instead of perf_event | Newer API | >= 5.8 |
| D: Run as root with systemd | Service has CAP_SYS_ADMIN | Any |

## Depends On

Nothing — this is a leaf task.

## Blocks

- run-22-language-drivers (need eBPF monitoring for driver execution tracing)
