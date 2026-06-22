#!/usr/bin/env python3
"""
Aristotle Test Corpus — maps every refusal/help pattern to a fix strategy.

Each entry:
  - refusal_id: unique label
  - project: project UUID prefix
  - category: EngineeringCanNot / PoetryRefusal / HashFabrication / MissingPrompt
  - pattern: the refusal keyword/phrase
  - original_context: what Aristotle said (from ARISTOTLE_SUMMARY.md)
  - root_cause: why Aristotle refused
  - fix_strategy: how to re-prompt to get results
  - fix_result: what Aristotle delivered after the fix
  - prompt_template: reusable template for this category

Output: /mnt/data1/aristotle-results/aristo-fix-strategies.json
"""
import json

FIXES = [
    {
        "refusal_id": "R01-engineering-cannot",
        "projects": ["5f3362b6", "86c53ec8"],
        "category": "EngineeringCanNot",
        "pattern": "cannot be produced / fabricate / software-engineering artifacts",
        "original_context": (
            "Consequently the bulk of the requested deliverables — the Rust dasl-split "
            "binary, the Python lark/pyparsing splitter, Nix-store tooling, IPLD CAR "
            "shared-memory pushes with CIDs, HTTP /put serving, and running 11 external "
            "splitters in a 121-combination matrix — are non-Lean software-engineering "
            "artifacts whose source material is absent. They cannot be produced or verified "
            "in a Lean theorem-proving environment, so I did not fabricate them."
        ),
        "root_cause": (
            "Aristotle's environment is a Lean 4 + Mathlib theorem prover. It has no access "
            "to external filesystems, binaries, or services. Multi-language engineering "
            "pipelines are completely out of scope."
        ),
        "fix_strategy": (
            "DON'T ask for engineering deliverables. Instead extract the genuinely "
            "mathematical, self-contained facts from the specification and ask Aristotle "
            "to formalize and prove those. Everything that requires Rust/Python/Nix/shell "
            "must be done outside Aristotle."
        ),
        "fix_result": {
            "5f3362b6": "Formalized Jaccard similarity (5 theorems) + Monster arithmetic (196883+1=196884). 2 .lean files, 0 sorries.",
            "86c53ec8": "Formalized MonsterCore: load_bearing_myth, 15-prime stairway with 4 theorems. 1 .lean file, 0 sorries."
        },
        "prompt_template": (
            "[TASK]\n"
            "The engineering pipeline (Rust/Python/Nix/HTTP) is handled outside this environment.\n"
            "Please formalize and prove ONLY the self-contained mathematical facts.\n\n"
            "Specifically, formalize in Lean 4 + Mathlib:\n"
            "1. [Fact 1 as a precise statement]\n"
            "2. [Fact 2 as a precise statement]\n\n"
            "Namespace: [your.namespace]\n"
            "File: RequestProject/[Name].lean\n"
            "Requirements: 0 sorry, 0 axiom, standard axioms only."
        )
    },
    {
        "refusal_id": "R02-poetry-refusal",
        "projects": ["69713c5d"],
        "category": "PoetryRefusal",
        "pattern": "evocative poetry / not well-posed / no actual constraint",
        "original_context": (
            "The 'Transmission Ω' machinery — the Gödel-number CRT surgery, the sheaf-section "
            "shards (51,56,28), dasl:bott = 6(R(8)), the Hecke operator T_23, the IPLD hash "
            "0xda513630001c116c, and the emoji-prime lattice — is evocative poetry rather than "
            "well-posed mathematics. There's no actual constraint linking a product of primes "
            "to a chosen residue triple, to a Bott-periodicity value, to a fixed content hash... "
            "I won't fabricate one."
        ),
        "root_cause": (
            "The prompt mixed narrative/poetic descriptions with actual arithmetic claims. "
            "Aristotle needs well-posed mathematical statements it can verify — not creative "
            "writing that gestures at mathematics without specifying constraints."
        ),
        "fix_strategy": (
            "1. Acknowledge the refusal is correct (the narrative IS poetry)\n"
            "2. Extract the concrete arithmetic claims that ARE verifiable:\n"
            "   - Prime factorizations (196883=47*59*71, Ctw=2²*23*631, etc.)\n"
            "   - CRT residue equations (Gtw ≡ (51,56,28) mod (71,59,47))\n"
            "   - Term→prime dictionary assignments\n"
            "3. State each as a precise Lean theorem signature\n"
            "4. Ask for one layer at a time, building on each success"
        ),
        "fix_result": (
            "5 successful runs delivered:\n"
            "- Zownakairufication fixed-point skeleton (category theory)\n"
            "- CRT residues: 67-term Gödel encoding, twist factor, shard verification\n"
            "- Uniqueness proof: the shard fixes a unique point modulo 196883\n"
            "- Monster order factorization, Hecke prime 23, shard_address_unique\n"
            "- 118-term prime dictionary with injectivity proofs\n"
            "Total: 774 lines, 21 declarations, 0 sorries."
        ),
        "prompt_template": (
            "[TASK]\n"
            "The narrative framework (sheaf sections, Bott periodicity metaphors, content hashes) "
            "is creative scaffolding and should NOT be formalized.\n\n"
            "Please formalize and prove in Lean 4 + Mathlib the specific arithmetic facts "
            "embedded in the narrative:\n\n"
            "1. Define: m1=71, m2=59, m3=47 (the Spoke moduli). Prove m1*m2*m3 = 196883.\n"
            "2. Define: G = product of primes [73,79,...,449] (67 terms).\n"
            "   Prove G ≡ 39 (mod 71), G ≡ 45 (mod 59), G ≡ 4 (mod 47).\n"
            "3. Define Ctw = 58052. Prove Ctw = 2² * 23 * 631.\n"
            "   Prove (G*Ctw) ≡ 51 (mod 71), (G*Ctw) ≡ 56 (mod 59), (G*Ctw) ≡ 28 (mod 47).\n\n"
            "Namespace: Kryptoeffnung.TransmissionOmega\n"
            "File: RequestProject/Main.lean\n"
            "Requirements: 0 sorry, 0 axiom, use native_decide for computational proofs."
        )
    },
    {
        "refusal_id": "R03-hash-fabrication",
        "projects": ["69713c5d"],
        "category": "HashFabrication",
        "pattern": "hash matching would require manufacturing",
        "original_context": (
            "I did not do this, because it is not a well-posed, verifiable task. A Lean proof "
            "term has no single canonical serialized form whose hash is stable or meaningful, "
            "and there is no mathematical content linking the compiled artifact of "
            "zownakairufication_fixed_point to a prescribed 64-bit value — matching an "
            "arbitrary target hash would require manufacturing the result rather than "
            "verifying anything."
        ),
        "root_cause": (
            "Asking for a specific hash value (0xda513630001c116c) is fundamentally not "
            "verifiable — proof terms have no canonical serialized form, and 'matching' an "
            "arbitrary hash would be fabrication, not proof."
        ),
        "fix_strategy": (
            "Replace the hash-matching ask with a genuine uniqueness theorem:\n"
            "- 'Prove the shard residues uniquely determine a value modulo 196883'\n"
            "- This is a real CRT theorem that Aristotle CAN prove\n"
            "- It captures the intent ('this is THE answer') without fabricating a hash"
        ),
        "fix_result": (
            "Aristotle proved zownakairufication_unique: the shard (51,56,28) "
            "mod (71,59,47) determines a unique value modulo 196883 via CRT.\n"
            "This captures the hash-like 'uniqueness' property without fabricating bits."
        ),
        "prompt_template": (
            "[TASK]\n"
            "Prove uniqueness for the Transmission Omega shard:\n\n"
            "Theorem: There exists a unique N modulo 196883 such that:\n"
            "  N ≡ 51 (mod 71), N ≡ 56 (mod 59), N ≡ 28 (mod 47)\n\n"
            "Prove this using CRT since 71, 59, 47 are pairwise coprime.\n"
            "Also prove that the twisted Gödel number Gtw satisfies these equations.\n\n"
            "Namespace: Kryptoeffnung.TransmissionOmega\n"
            "File: RequestProject/Main.lean\n"
            "Requirements: 0 sorry, standard axioms only."
        )
    },
    {
        "refusal_id": "R04-missing-prompt",
        "projects": ["89f87210", "da4b7523"],
        "category": "MissingPrompt",
        "pattern": "nothing actionable / please re-send / file not present",
        "original_context": (
            "The project currently contains only boilerplate: RequestProject/Main.lean has "
            "just imports (import Mathlib) and a set of set_option configuration lines, with "
            "no definitions, statements, or sorrys to prove. There is nothing actionable yet."
        ),
        "root_cause": (
            "Aristotle's submit command creates a scaffold project (Main.lean with imports + "
            "set_option). The prompt file referenced in the description field was not actually "
            "included in the project tarball. Aristotle has no way to read the prompt."
        ),
        "fix_strategy": (
            "1. Use 'formalize' command (not 'submit') to include the prompt file in the tar payload\n"
            "2. Or use 'ask' command on the existing project, embedding the prompt inline\n"
            "3. Ensure the ask text includes the full declaration list, not just a filename reference\n"
            "4. Always include the actual theorem statements, not file paths"
        ),
        "fix_result": {
            "89f87210": "After re-sending with inline prompt: 8 theorems + 2 lemmas formalized. 136 lines, 0 sorries. 2 grind+suggestions for hardest theorems.",
            "da4b7523": "Still scaffold only (24 lines). May need another ask with embedded content."
        },
        "prompt_template": (
            "Please formalize and prove the following theorems in Lean 4 + Mathlib.\n"
            "Add them to RequestProject/Main.lean.\n\n"
            "1. theorem NAME1 : STATEMENT1 :=\n"
            "   [optional: signature hints]\n"
            "2. theorem NAME2 : STATEMENT2 :=\n\n"
            "Namespace: RequestProject\n"
            "Requirements: 0 sorry, 0 axiom, pass lake build.\n"
            "Do NOT reference external files — all content is inline above."
        )
    },
    {
        "refusal_id": "R05-narrative-scope",
        "projects": ["69713c5d"],
        "category": "PoetryRefusal",
        "pattern": "narrative orchestration / did not assert as theorems",
        "original_context": (
            "The surrounding loop ideas (content-ID ledgers, proof-hash feedback that rewrites "
            "the Gödel encoding, IPLD/CAR task bundles) are narrative orchestration rather than "
            "well-posed mathematical statements, so I did not assert them as theorems; I'm happy "
            "to formalize any concrete arithmetic claim you extract from them."
        ),
        "root_cause": (
            "The prompt mixed 'system architecture' ideas (content-ID ledgers, proof-hash feedback "
            "loops) with actual arithmetic. The system design ideas are engineering, not math."
        ),
        "fix_strategy": (
            "Separate the system-design ideas from the arithmetic. Use Aristotle ONLY for "
            "mathematical verification. The engineering/architecture (ledgers, loops, shmem) "
            "must be built outside Aristotle and submitted as facts, not designs."
        ),
        "fix_result": (
            "Aristotle formalized the decoder ring: prime 1823 factorization of 196884, "
            "the term→prime dictionary injection, and McKay's 196884=196883+1 split.\n"
            "The loop ideas remain as prose documentation."
        ),
        "prompt_template": (
            "[TASK — ARITHMETIC ONLY]\n"
            "The system architecture (content ledgers, proof loops, task bundles) is outside scope.\n\n"
            "Please formalize and prove ONLY the arithmetic facts:\n"
            "1. 196884 = 196883 + 1 (McKay's split)\n"
            "2. 196884 = 2² * 3³ * 1823 (j-invariant coefficient factorization)\n"
            "3. For the term→prime dictionary: all 118 primes are distinct, sorted, prime.\n"
            "4. The product of the first 67 primes equals the Gödel number G.\n\n"
            "Namespace: Kryptoeffnung.TransmissionOmega\n"
            "File: RequestProject/[Name].lean"
        )
    },
]

print(f"Fix strategies: {len(FIXES)}")
print(f"  EngineeringCanNot: 1")
print(f"  PoetryRefusal: 2")
print(f"  HashFabrication: 1")
print(f"  MissingPrompt: 1")

out_path = "/mnt/data1/aristotle-results/aristo-fix-strategies.json"
with open(out_path, "w") as f:
    json.dump(FIXES, f, indent=2)
print(f"\nSaved to {out_path}")

# Print summary for each
for fix in FIXES:
    print(f"\n{'='*60}")
    print(f"FIX: {fix['refusal_id']} ({fix['category']})")
    print(f"Projects: {', '.join(fix['projects'])}")
    print(f"Pattern: {fix['pattern']}")
    print(f"\nRoot cause: {fix['root_cause'][:200]}...")
    print(f"\nFix: {fix['fix_strategy'][:200]}...")
