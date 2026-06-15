---
name: d8-2a-crane-libbpf
description: >-
  Build eBPF programs with libbpf-rs + crane in Nix — pure reproducible builds
  from scratch, no pre-built binaries. Use when building C BPF programs with
  Rust userspace via libbpf-rs, or adapting the libbpf-rs-starter-template to
  a new project with a local Nix flake.
---

# D8-2A: crane + libbpf-rs eBPF Build Pattern

Full Nix build of a C BPF program + Rust userspace using crane (no pre-built bins).

## Project layout

```
d8_2a/
├── flake.nix                  # crane build, all git+file:// inputs
├── Cargo.toml                 # [workspace] to isolate from parent
├── Cargo.lock
├── build.rs                   # libbpf-cargo SkeletonBuilder
├── src/
│   ├── main.rs                # userspace: PerfBufferBuilder loop
│   └── bpf/
│       ├── d8_2a.bpf.c        # SEC("perf_event") scanning all GP regs
│       ├── d8_2a.h            # shared struct event
│       └── vmlinux.h          # copied locally (not via submodule path)
└── libbpf-rs-starter-template/ # git submodule (reference only)
```

## Key flake patterns

```nix
# 1. Include .c/.h files that cleanCargoSource strips
src = pkgs.lib.cleanSourceWith {
  src = ./.;
  filter = path: type:
    (craneLib.filterCargoSources path type) ||
    (builtins.match ".*\\.(c|h)$" path != null);
};

# 2. Disable ALL hardening — nix flags like -fzero-call-used-regs
#    break the BPF backend
hardeningDisable = [ "all" ];

# 3. Use UNWRAPPED clang — cc-wrapper doesn't support --target bpf
BPF_CLANG = "${pkgs.llvmPackages.clang-unwrapped}/bin/clang";
LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
```

## All flake inputs use local mirrors

```nix
nixpkgs.url    = "git+file:///mnt/data1/git/github.com/NixOS/nixpkgs.git?ref=master";
crane.url      = "git+file:///mnt/data1/git/github.com/ipetkov/crane.git";
flake-utils.url = "git+file:///mnt/data1/git/github.com/numtide/flake-utils";
```

Mirror crane: `git clone --mirror https://github.com/ipetkov/crane.git ~/git/github.com/ipetkov/crane.git`

## Build

```bash
cd aya-nix/d8_2a
nix build          # produces result/bin/d8_2a
```

## Run (requires root for BPF_PROG_LOAD)

```bash
sudo ./result/bin/d8_2a
# HIT pid=1234 tid=1234 ip=0x7f... reg=rax val=0x00002ad800000000
```

## Common pitfalls

- `vmlinux.h` must be local to `src/bpf/` — relative paths to submodules break in sandbox
- `cleanCargoSource` strips `.c`/`.h` — must add custom filter
- Nix-wrapped clang fails with `--target bpf` — use `clang-unwrapped`
- Hardening flags (`-fzero-call-used-regs`, `-fstack-protector`) not supported by BPF backend
- Use direct `ctx->regs.ax` etc. not `PT_REGS_*` macros (architecture portability issues)

## Source

`/mnt/data1/nix/vendor/rust/cargo2nix/submodules/cargo-clean/tools/cargo-vendormod/aya-nix/d8_2a/`

## Vendormod Crane Usage

cargo-vendormod uses crane for its own flake.nix build (see `flake.nix` in
the vendormod root). The eBPF build pattern here is the most complex crane
usage in the DASL ecosystem; simpler vendormod builds follow the same pattern
but without the BPF-specific hardening workarounds.

See [[cargo-vendormod]] for the vendormod build and [[nix-build]]
for the general crane vendoring procedure.
