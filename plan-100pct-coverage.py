#!/usr/bin/env python3
"""
DASL 100% Coverage Plan — concrete steps to close all 5 spec audit gaps.

Sources available but not yet in the fuzz corpus:
  1. FractranCRTMerger splitter: 2,019 files (FRACTRAN step/pure declarations)
  2. Full splitter overlays: 18,031 files (only 350 sampled)
  3. dasl-project lean.txt: 92 references, 10 on disk (Hecke, FRACTRAN, DASL core)
  4. 160 old Aristotle projects in aristotles_results/
  5. Parquet proofs: native_parquet_lean, prove_parquet_ocaml_monster

Gaps to close:
  DASL-3.1: State transitions MUST be deterministic (0 matches)
  REQ-2:   Automated test generation via FRACTRAN evolution (0 matches)
  BM-2:    Error dedup across runs via content addressing (0 matches)
  BM-4:    Build node DAG-CBOR data model (0 matches)
  ARI-2:   Consolidated DASL merge (0 matches)
"""
import os, json

SPLIT_KERNEL = "/mnt/data1/time-2026/05-may/07/arist/split-results-kernel"
OLD_ARISTOTLE = "/mnt/data1/time-2026/05-may/07/arist/aristotles_results"

plan = {
    "current_coverage": "85.3% (29/34)",
    "target": "100% (34/34)",
    "gaps": [
        {
            "gap": "DASL-3.1",
            "description": "State transitions MUST be deterministic",
            "keywords": ["step", "deterministic", "pure", "preserves", "idempotent"],
            "current_matches": 0,
            "fix_source": "FractranCRTMerger splitter overlay",
            "fix_count": "2,019 declarations available",
            "expected_matches": "stepN, step_deterministic, pure_run, preserves_base, idempotent_*",
            "action": "Sample FractranCRTMerger/Split/ for files containing 'step', 'pure', 'idempotent', 'preserves'",
            "priority": 1,
        },
        {
            "gap": "REQ-2",
            "description": "Automated test generation via FRACTRAN evolution",
            "keywords": ["Fractran", "step", "run", "evolve", "generate", "program"],
            "current_matches": 0,
            "fix_source": "FractranCRTMerger + Fractran.lean (f7d43246 project) + Parquet proofs",
            "fix_count": "2,019 + 155 + 120 = 2,294 declarations available",
            "expected_matches": "Fractran, runFractran, step, program, evolve, generate",
            "action": "Sample FractranCRTMerger + Fractran.lean + parquet proofs for FRACTRAN keywords",
            "priority": 1,
        },
        {
            "gap": "BM-2",
            "description": "Error dedup across runs via content addressing",
            "keywords": ["dedup", "error", "fingerprint", "seen", "occurrence", "fix"],
            "current_matches": 0,
            "fix_source": "UnifiedIPLDMemory splitter (4,049 files) + ContentAddressing (684 files)",
            "fix_count": "4,733 declarations available",
            "expected_matches": "fingerprint, error, dedup, occurrence, seen, fix",
            "action": "Sample UnifiedIPLDMemory/Split/ + ContentAddressing/Split/ for error/fingerprint keywords",
            "priority": 2,
        },
        {
            "gap": "BM-4",
            "description": "Build node DAG-CBOR data model",
            "keywords": ["build", "dagcbor", "model", "command", "duration", "exit"],
            "current_matches": 0,
            "fix_source": "IPLDMonsterSchema (878) + UnifiedIPLDMemory (4,049) + CDDL spec",
            "fix_count": "4,927 declarations available",
            "expected_matches": "dagcbor, block, model, build, command, exit",
            "action": "Sample IPLDMonsterSchema/Split/ + UnifiedIPLDMemory/Split/ for DAG-CBOR block keywords",
            "priority": 2,
        },
        {
            "gap": "ARI-2",
            "description": "Consolidated DASL merge (842 files, 133 declarations)",
            "keywords": ["consolidate", "merge", "reconstruct", "module", "splitter"],
            "current_matches": 0,
            "fix_source": "All 13 splitter overlays (18,031 files) + 160 old Aristotle projects",
            "fix_count": "18,031 + 160 projects available",
            "expected_matches": "merge, consolidate, reconstruct, module, splitter",
            "action": "Sample all splitter overlays + scan old Aristotle projects for merge/splitter keywords",
            "priority": 3,
        },
    ],
    "sources_to_index": [
        {
            "source": "FractranCRTMerger/Split/",
            "path": os.path.join(SPLIT_KERNEL, "FractranCRTMerger", "Split"),
            "count": 2019,
            "gaps_closed": ["DASL-3.1", "REQ-2"],
        },
        {
            "source": "UnifiedIPLDMemory/Split/",
            "path": os.path.join(SPLIT_KERNEL, "UnifiedIPLDMemory", "Split"),
            "count": 4049,
            "gaps_closed": ["BM-2", "BM-4"],
        },
        {
            "source": "ContentAddressing/Split/",
            "path": os.path.join(SPLIT_KERNEL, "ContentAddressing", "Split"),
            "count": 684,
            "gaps_closed": ["BM-2"],
        },
        {
            "source": "IPLDMonsterSchema/Split/",
            "path": os.path.join(SPLIT_KERNEL, "IPLDMonsterSchema", "Split"),
            "count": 878,
            "gaps_closed": ["BM-4"],
        },
        {
            "source": "All 13 overlays (full)",
            "path": SPLIT_KERNEL,
            "count": 18031,
            "gaps_closed": ["ARI-2"],
        },
        {
            "source": "160 old Aristotle projects",
            "path": OLD_ARISTOTLE,
            "count": 160,
            "gaps_closed": ["ARI-2", "DASL-3.1", "REQ-2"],
        },
    ],
    "estimated_timeline": {
        "phase_1_sample": "Sample FractranCRTMerger + UnifiedIPLDMemory → close DASL-3.1, REQ-2, BM-2, BM-4 (1 hour)",
        "phase_2_full_overlays": "Run staticsplitjson on all 13 overlays → close ARI-2 (2 hours)",
        "phase_3_old_projects": "Scan 160 old Aristotle projects → backfill all gaps (4 hours)",
        "phase_4_rerun_audit": "Rerun dasl-spec-audit-v2.py → verify 100% (30 min)",
        "total": "~8 hours to 100% coverage",
    },
}

print(json.dumps(plan, indent=2))
