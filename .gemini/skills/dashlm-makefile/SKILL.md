---
name: "dashlm-makefile"
description: "Update cargo-vendormod Makefile with dashlm targets for building, viewing, GPU prep, cleaning, and systemd service management."
---

# dashlm Makefile targets

## Steps

1. Edit `Makefile` (or create `Makefile.dashlm` and include it).
2. Top variables:
   - `DASL_ROOT := $(HOME)/dasl`
   - `GIT_HASH := $(shell cd $(DASL_ROOT) && git rev-parse HEAD)`
   - `INDEX_NAME := dashlm_index_$(GIT_HASH)`
   - `INDEX_SIZE := 1073741824`
   - `PROJECT_ROOT := $(DASL_ROOT)`
   - `VERBOSE_FLAG` (overridable)
3. Targets:
   - `index-build` -> run builder binary.
   - `index-show` -> run viewer.
   - `index-gpu-prep` -> run GPU preparer.
   - `index-clean` -> remove SysV shared segment.
   - `index-service-start/stop/enable/disable/status` -> systemctl wrappers.
4. Each prints header with `@echo`.
5. Add `help` phony target listing dashlm targets.
6. Test: `make index-build`, `make index-show`, `make index-gpu-prep`.

## Source files

- `Makefile` (add targets)
