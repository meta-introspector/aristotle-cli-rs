---
name: "dasl-input-collector"
description: "Collects and deduplicates CBOR test inputs from various sources for dasl-testing."
---

# DASL Input Collector

This skill collects and deduplicates CBOR test inputs from various sources for `dasl-testing`.

## Usage

To collect all inputs, run the `collect_all.py` script:
```bash
/skill:dasl-input-collector collect_all
```
This will output a JSON array of all collected and deduplicated test inputs.

You can also specify which input sets to collect:
```bash
/skill:dasl-input-collector collect_all --inputs fixtures,crashes
```

## Input Sources

The following input sources are supported:

-   **fixtures**: from `dasl-testing/fixtures/cbor/*.json`
-   **raw**: from `dasl/fuzzing/corpus/raw`
-   **adversarial**: from `dasl/fuzzing/corpus/adversarial_corpus`
-   **crashes**: from `dasl-testing/harnesses/*/crashes`
-   **timing**: from `dasl/INPUT/attacks`
-   **cbor_cpp**: from `dasl/fuzzing/corpus/cbor_cpp`
-   **lattice**: from `dasl-testing/INPUT/lattice/fixtures/lattice.json`

Each input source has a corresponding script in the `scripts/` directory.
The `collect_all.py` script runs the appropriate collectors and handles deduplication.
