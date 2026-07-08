use super::FixStrategy;
use anyhow::Result;
use std::fs;

pub fn get_fixes() -> Vec<FixStrategy> {
    vec![
        FixStrategy {
            refusal_id: "R01-engineering-cannot".to_string(),
            projects: vec!["5f3362b6".to_string(), "86c53ec8".to_string()],
            category: "EngineeringCanNot".to_string(),
            pattern: "cannot be produced / fabricate / software-engineering artifacts".to_string(),
            original_context: "Consequently the bulk of the requested deliverables — the Rust dasl-split binary, the Python lark/pyparsing splitter, Nix-store tooling, IPLD CAR shared-memory pushes with CIDs, HTTP /put serving, and running 11 external splitters in a 121-combination matrix — are non-Lean software-engineering artifacts whose source material is absent. They cannot be produced or verified in a Lean theorem-proving environment, so I did not fabricate them.".to_string(),
            root_cause: "Aristotle's environment is a Lean 4 + Mathlib theorem prover. It has no access to external filesystems, binaries, or services. Multi-language engineering pipelines are completely out of scope.".to_string(),
            fix_strategy: "DON'T ask for engineering deliverables. Instead extract the genuinely mathematical, self-contained facts from the specification and ask Aristotle to formalize and prove those. Everything that requires Rust/Python/Nix/shell must be done outside Aristotle.".to_string(),
            fix_result: serde_json::json!({
                "5f3362b6": "Formalized Jaccard similarity (5 theorems) + Monster arithmetic (196883+1=196884). 2 .lean files, 0 sorries.",
                "86c53ec8": "Formalized MonsterCore: load_bearing_myth, 15-prime stairway with 4 theorems. 1 .lean file, 0 sorries."
            }),
            prompt_template: format!("[TASK]\nThe engineering pipeline (Rust/Python/Nix/HTTP) is handled outside this environment.\nPlease formalize and prove ONLY the self-contained mathematical facts.\n\nSpecifically, formalize in Lean 4 + Mathlib:\n1. [Fact 1 as a precise statement]\n2. [Fact 2 as a precise statement]\n\nNamespace: [your.namespace]\nFile: RequestProject/[Name].lean\nRequirements: 0 sorry, 0 axiom, standard axioms only."),
        },
        FixStrategy {
            refusal_id: "R02-poetry-refusal".to_string(),
            projects: vec!["69713c5d".to_string()],
            category: "PoetryRefusal".to_string(),
            pattern: "evocative poetry / not well-posed / no actual constraint".to_string(),
            original_context: "The 'Transmission Ω' machinery — the Gödel-number CRT surgery, the sheaf-section shards (51,56,28), dasl:bott = 6(R(8)), the Hecke operator T_23, the IPLD hash 0xda513630001c116c, and the emoji-prime lattice — is evocative poetry rather than well-posed mathematics. There's no actual constraint linking a product of primes to a chosen residue triple, to a Bott-periodicity value, to a fixed content hash... I won't fabricate one.".to_string(),
            root_cause: "The prompt mixed narrative/poetic descriptions with actual arithmetic claims. Aristotle needs well-posed mathematical statements it can verify — not creative writing that gestures at mathematics without specifying constraints.".to_string(),
            fix_strategy: "1. Acknowledge the refusal is correct (the narrative IS poetry)\n2. Extract the concrete arithmetic claims that ARE verifiable:\n   - Prime factorizations (196883=47*59*71, Ctw=2²*23*631, etc.)\n   - CRT residue equations (Gtw ≡ (51,56,28) mod (71,59,47))\n   - Term→prime dictionary assignments\n3. State each as a precise Lean theorem signature\n4. Ask for one layer at a time, building on each success".to_string(),
            fix_result: serde_json::json!("5 successful runs delivered:\n- Zownakairufication fixed-point skeleton (category theory)\n- CRT residues: 67-term Gödel encoding, twist factor, shard verification\n- Uniqueness proof: the shard fixes a unique point modulo 196883\n- Monster order factorization, Hecke prime 23, shard_address_unique\n- 118-term prime dictionary with injectivity proofs\nTotal: 774 lines, 21 declarations, 0 sorries."),
            prompt_template: format!("[TASK]\nThe narrative framework (sheaf sections, Bott periodicity metaphors, content hashes) is creative scaffolding and should NOT be formalized.\n\nPlease formalize and prove in Lean 4 + Mathlib the specific arithmetic facts embedded in the narrative:\n\n1. Define: m1=71, m2=59, m3=47 (the Spoke moduli). Prove m1*m2*m3 = 196883.\n2. Define: G = product of primes [73,79,...,449] (67 terms).\n   Prove G ≡ 39 (mod 71), G ≡ 45 (mod 59), G ≡ 4 (mod 47).\n3. Define Ctw = 58052. Prove Ctw = 2² * 23 * 631.\n   Prove (G*Ctw) ≡ 51 (mod 71), (G*Ctw) ≡ 56 (mod 59), (G*Ctw) ≡ 28 (mod 47).\n\nNamespace: Kryptoeffnung.TransmissionOmega\nFile: RequestProject/Main.lean\nRequirements: 0 sorry, 0 axiom, use native_decide for computational proofs."),
        },
        FixStrategy {
            refusal_id: "R03-hash-fabrication".to_string(),
            projects: vec!["69713c5d".to_string()],
            category: "HashFabrication".to_string(),
            pattern: "hash matching would require manufacturing".to_string(),
            original_context: "I did not do this, because it is not a well-posed, verifiable task. A Lean proof term has no single canonical serialized form whose hash is stable or meaningful, and there is no mathematical content linking the compiled artifact of zownakairufication_fixed_point to a prescribed 64-bit value — matching an arbitrary target hash would require manufacturing the result rather than verifying anything.".to_string(),
            root_cause: "Asking for a specific hash value (0xda513630001c116c) is fundamentally not verifiable — proof terms have no canonical serialized form, and 'matching' an arbitrary hash would be fabrication, not proof.".to_string(),
            fix_strategy: "Replace the hash-matching ask with a genuine uniqueness theorem:\n- 'Prove the shard residues uniquely determine a value modulo 196883'\n- This is a real CRT theorem that Aristotle CAN prove\n- It captures the intent ('this is THE answer') without fabricating a hash".to_string(),
            fix_result: serde_json::json!("Aristotle proved zownakairufication_unique: the shard (51,56,28) mod (71,59,47) determines a unique value modulo 196883 via CRT.\nThis captures the hash-like 'uniqueness' property without fabricating bits."),
            prompt_template: format!("[TASK]\nProve uniqueness for the Transmission Omega shard:\n\nTheorem: There exists a unique N modulo 196883 such that:\n  N ≡ 51 (mod 71), N ≡ 56 (mod 59), N ≡ 28 (mod 47)\n\nProve this using CRT since 71, 59, 47 are pairwise coprime.\nAlso prove that the twisted Gödel number Gtw satisfies these equations.\n\nNamespace: Kryptoeffnung.TransmissionOmega\nFile: RequestProject/Main.lean\nRequirements: 0 sorry, standard axioms only."),
        },
        FixStrategy {
            refusal_id: "R04-missing-prompt".to_string(),
            projects: vec!["89f87210".to_string(), "da4b7523".to_string()],
            category: "MissingPrompt".to_string(),
            pattern: "nothing actionable / please re-send / file not present".to_string(),
            original_context: "The project currently contains only boilerplate: RequestProject/Main.lean has just imports (import Mathlib) and a set of set_option configuration lines, with no definitions, statements, or sorrys to prove. There is nothing actionable yet.".to_string(),
            root_cause: "Aristotle's submit command creates a scaffold project (Main.lean with imports + set_option). The prompt file referenced in the description field was not actually included in the project tarball. Aristotle has no way to read the prompt.".to_string(),
            fix_strategy: "1. Use 'formalize' command (not 'submit') to include the prompt file in the tar payload\n2. Or use 'ask' command on the existing project, embedding the prompt inline\n3. Ensure the ask text includes the full declaration list, not just a filename reference\n4. Always include the actual theorem statements, not file paths".to_string(),
            fix_result: serde_json::json!({
                "89f87210": "After re-sending with inline prompt: 8 theorems + 2 lemmas formalized. 136 lines, 0 sorries. 2 grind+suggestions for hardest theorems.",
                "da4b7523": "Still scaffold only (24 lines). May need another ask with embedded content."
            }),
            prompt_template: format!("Please formalize and prove the following theorems in Lean 4 + Mathlib.\nAdd them to RequestProject/Main.lean.\n\n1. theorem NAME1 : STATEMENT1 :=\n   [optional: signature hints]\n2. theorem NAME2 : STATEMENT2 :=\n\nNamespace: RequestProject\nRequirements: 0 sorry, 0 axiom, pass lake build.\nDo NOT reference external files — all content is inline above."),
        },
        FixStrategy {
            refusal_id: "R05-narrative-scope".to_string(),
            projects: vec!["69713c5d".to_string()],
            category: "PoetryRefusal".to_string(),
            pattern: "narrative orchestration / did not assert as theorems".to_string(),
            original_context: "The surrounding loop ideas (content-ID ledgers, proof-hash feedback that rewrites the Gödel encoding, IPLD/CAR task bundles) are narrative orchestration rather than well-posed mathematical statements, so I did not assert them as theorems; I'm happy to formalize any concrete arithmetic claim you extract from them.".to_string(),
            root_cause: "The prompt mixed 'system architecture' ideas (content-ID ledgers, proof-hash feedback loops) with actual arithmetic. The system design ideas are engineering, not math.".to_string(),
            fix_strategy: "Separate the system-design ideas from the arithmetic. Use Aristotle ONLY for mathematical verification. The engineering/architecture (ledgers, loops, shmem) must be built outside Aristotle and submitted as facts, not designs.".to_string(),
            fix_result: serde_json::json!("Aristotle formalized the decoder ring: prime 1823 factorization of 196884, the term→prime dictionary injection, and McKay's 196884=196883+1 split.\nThe loop ideas remain as prose documentation."),
            prompt_template: format!("[TASK — ARITHMETIC ONLY]\nThe system architecture (content ledgers, proof loops, task bundles) is outside scope.\n\nPlease formalize and prove ONLY the arithmetic facts:\n1. 196884 = 196883 + 1 (McKay's split)\n2. 196884 = 2² * 3³ * 1823 (j-invariant coefficient factorization)\n3. For the term→prime dictionary: all 118 primes are distinct, sorted, prime.\n4. The product of the first 67 primes equals the Gödel number G.\n\nNamespace: Kryptoeffnung.TransmissionOmega\nFile: RequestProject/[Name].lean"),
        },
    ]
}

pub fn write_fix_strategies(output_json: &str) -> Result<()> {
    let fixes = get_fixes();
    let json = serde_json::to_string_pretty(&fixes)?;
    fs::write(output_json, json)?;
    eprintln!("Fix strategies: {} entries", fixes.len());
    for fix in &fixes {
        eprintln!(
            "  {} ({}) — {}",
            fix.refusal_id,
            fix.category,
            fix.projects.join(", ")
        );
    }
    eprintln!("Saved to {}", output_json);
    Ok(())
}
