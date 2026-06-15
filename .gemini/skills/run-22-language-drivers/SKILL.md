---
name: run-22-language-drivers
description: >-
  Run the remaining 22 language drivers beyond the proven Rust driver.
  Currently only driver-rust is tested in integration tests. The other 24
  drivers (Python, Go, C, JS, Java, etc.) exist on disk but are never called.
  Use when building multi-language integration tests, spawning drivers via
  pipe protocol, or generating per-language systemd services.
---

# Run Remaining 22 Language Drivers

**Priority:** MEDIUM
**Area:** Testing
**Status:** Pending (blocked by ebpf-perf-event-diagnose)
**Source:** HANDOFF.md

## Problem

Only `driver-rust` is proven in integration tests. The other 24 drivers
exist on disk but are never called. This is the highest-priority gap from
the HANDOFF.md analysis.

## Driver Inventory (25 total)

| # | Language   | Driver Path                              | Status |
|---|------------|------------------------------------------|--------|
| 1 | Rust       | drivers/driver-rust/                     | PROVEN |
| 2 | Python     | drivers/driver-python/                   | Untested |
| 3 | Go         | drivers/driver-go/                       | Untested |
| 4 | C          | drivers/driver-c/                        | Untested |
| 5 | C++        | drivers/driver-cpp/                      | Untested |
| 6 | JavaScript | drivers/driver-js/                       | Untested |
| 7 | Java       | drivers/driver-java/                    | Untested |
| 8 | Ruby       | drivers/driver-ruby/                     | Untested |
| 9 | Perl       | drivers/driver-perl/                     | Untested |
| ... | (16 more) | ...                                      | ... |

## Pipe Protocol

All drivers speak the same protocol:
```
stdin:  <leb128(payload_len)> <cbor(TestRequest)>
stdout: <leb128(payload_len)> <cbor(TestResponse)>
```

TestRequest: `{id, cid_hex, data_hex, codec}`
TestResponse: `{id, ok, error?, decoded_hex?, duration_us}`

## Steps

1. Build round-robin binaries: `make -C harnesses`
2. Create multi-language integration test that spawns each driver
3. Verify each driver responds to pipe protocol correctly
4. Generate per-language systemd services
5. Add eBPF monitoring for driver execution tracing

## Build Commands

```bash
cd ~/dasl/dasl-testing

# Build all harnesses
cd harnesses && make

# Test one driver
echo '{"id":1,"cid_hex":"...","data_hex":"...","codec":"dag-cbor"}' | \
  cbor2 | leb128-encode | \
  ./drivers/driver-python/driver.py
```

## Depends On

- ebpf-perf-event-diagnose (need eBPF monitoring for execution tracing)

## Blocks

Nothing directly, but this is the core testing gap.
