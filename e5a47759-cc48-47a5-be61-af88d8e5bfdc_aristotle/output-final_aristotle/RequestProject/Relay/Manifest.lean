import Lean
import RequestProject.Relay.ProofCarrying
import RequestProject.Relay.Seed
import RequestProject.Relay.Shapes
import RequestProject.Relay.Bootstrap
import RequestProject.Relay.Projects
import RequestProject.Relay.Recover
import RequestProject.Kernel.Vectors
import RequestProject.Kernel.Wasm
import RequestProject.Kernel.Prove
import RequestProject.Kernel.Independence
import RequestProject.Solfunmeme.Meme.Quine
import RequestProject.Economy

/-!
# The index, emitted from Lean

Everything this repository claims to have proved is listed here once, and the
list is generated rather than maintained: for every headline theorem the
`audit_table` command below resolves the name **in the environment**, so a
theorem that is renamed or deleted stops the build rather than silently staying
in the index, and records the module it lives in and the axioms it actually
depends on, as the kernel reports them.

`manifestJson` renders the whole thing — theorems, the twenty-two stages, and
the proof-engine conformance vectors — as one JSON document.
`lake exe relay-index` writes it to `www/manifest.json`, which every page under
`www/` reads.  Nothing downstream keeps its own copy of these facts.

Three self-checks are proved here about the index itself: the identifiers are
distinct (`entries_ids_nodup`), every "rests on" edge points at an entry that
exists (`entries_deps_closed`), and every entry names a theorem that was
audited (`entries_audited`).

## What the `evidence` field means

Every entry in *this* file is `kernel-checked`: the Lean kernel checked the
proof, from the axioms listed.  The measurements — that `node` and `gcc` and
`sqlite3` really do behave like the model, how long a step takes, how much
cargo fits — are not theorems, and they enter the manifest from the other side,
added by `tools/build_index.py` from the files the scripts write, tagged
`measured`.  Keeping the boundary in the data rather than in a paragraph is the
point of the exercise.
-/

namespace RequestProject.Relay.Manifest

open Lean Elab Command in
/-- `audit_table tbl N₁ N₂ …` defines `tbl : List (String × String × List String)`,
one row per constant: its fully-qualified name, the module it lives in, and the
axioms it depends on — all read out of the environment at elaboration time. -/
elab "audit_table " tgt:ident ns:ident* : command => do
  let mut elems : Array (TSyntax `term) := #[]
  for n in ns do
    let cname ← liftCoreM <| realizeGlobalConstNoOverloadWithInfo n
    let ax ← liftCoreM <| collectAxioms cname
    let env ← getEnv
    let mod : String := match env.getModuleIdxFor? cname with
      | some idx => (env.header.moduleNames[idx.toNat]!).toString
      | none => "RequestProject.Relay.Manifest"
    let axSyn : Array (TSyntax `term) := ax.map fun a => ⟨Syntax.mkStrLit a.toString⟩
    let nameLit : TSyntax `term := ⟨Syntax.mkStrLit cname.toString⟩
    let modLit : TSyntax `term := ⟨Syntax.mkStrLit mod⟩
    elems := elems.push (← `(($nameLit, $modLit, [$axSyn,*])))
  elabCommand (← `(def $tgt : List (String × String × List String) := [$elems,*]))

-- `auditTable`: name, module and axiom dependencies of every headline theorem,
-- read from the environment at elaboration time.
audit_table auditTable
  RequestProject.Relay.Relay.host_prog
  RequestProject.Relay.Relay.host_self
  RequestProject.Relay.Relay.run_prog
  RequestProject.Relay.Relay.runN_size
  RequestProject.Relay.Relay.rebuildAll_prog
  RequestProject.Relay.stages_readSize
  RequestProject.Relay.stages_rebuild_all
  RequestProject.Relay.Shape.parse_render
  RequestProject.Relay.Shape.commute
  RequestProject.Relay.Shapes.round_trip
  RequestProject.Relay.Shapes.interchange
  RequestProject.Relay.stages_wf
  RequestProject.Relay.stages_size
  RequestProject.Relay.program_host
  RequestProject.Relay.program_self
  RequestProject.Relay.program_step
  RequestProject.Relay.relay_cycle
  RequestProject.Relay.program_carries_sources
  RequestProject.Relay.Relay.commitment_prog
  RequestProject.Relay.Relay.commitment_eq
  RequestProject.Relay.Relay.respond_eq
  RequestProject.Relay.Relay.openPayload_prog
  RequestProject.Relay.payload_eq_of_respond
  RequestProject.Relay.Relay.readCargo_prog
  RequestProject.Relay.Relay.cargo_survives_cycle
  RequestProject.Relay.Relay.cargo_unbounded
  RequestProject.Relay.stages_carry_cargo
  RequestProject.Relay.stages_cargo_cycle
  RequestProject.Relay.stages_cargo_unbounded
  RequestProject.Relay.rebuild_eq_host
  RequestProject.Relay.Relay.recover_prog
  RequestProject.Relay.Relay.bootstrap_fixed_point
  RequestProject.Relay.Relay.boot_cycle
  RequestProject.Relay.Relay.loaded_self_hosting
  RequestProject.Relay.Relay.cycle_cost_le
  RequestProject.Relay.seed_quine
  RequestProject.Relay.seed_cycle
  RequestProject.Relay.seed_fixed_point
  RequestProject.Relay.seed_bytes
  RequestProject.Kernel.Provable.tautology
  RequestProject.Kernel.check_provable
  RequestProject.Kernel.check_tautology
  RequestProject.Kernel.not_proves_fls
  RequestProject.Kernel.check_subst
  RequestProject.Kernel.mutate_tautology
  RequestProject.Kernel.Script.dec_enc
  RequestProject.Kernel.Script.enc_codeable
  RequestProject.Kernel.vectors_check
  RequestProject.Kernel.vectors_tautology
  RequestProject.Kernel.Provable.of_tautology
  RequestProject.Kernel.provable_iff_tautology
  RequestProject.Kernel.check_complete
  RequestProject.Kernel.proves_iff_tautology
  RequestProject.Kernel.isTautology_iff
  RequestProject.Kernel.engine_dichotomy
  RequestProject.Kernel.prove_sound
  RequestProject.Kernel.prove_complete
  RequestProject.Kernel.prove_isSome_iff_tautology
  RequestProject.Kernel.dne_not_provableKS
  RequestProject.Kernel.axDne_independent
  RequestProject.Relay.Relay.proof_carried
  RequestProject.Relay.Relay.proof_recoverable
  RequestProject.Relay.Relay.proof_survives_cycle
  RequestProject.Relay.stages_transport_proof
  RequestProject.Relay.stages_transport_found_proof
  RequestProject.Relay.readCargo_eq_of_respond
  Meme.Quine.quineMemes_files_nodup
  Meme.Quine.quineMemes_cover
  Meme.Quine.memes_share_commitment
  Meme.Quine.mint_all_quines
  Meme.Quine.mint_unlocks_memeLord
  Meme.Quine.mintClaim_verify
  SFM.Token.Book.genesis_issued
  CfDeploy.WasmKernel.deployKernel_wf
  Bootstrap.Pantograph.exec_ouroboros
  LifeTrac.filletThroat_pos
  Hesper.Gif.valOf_bitsOf
  CCLua.toLua_exec
  RequestProject.Economy.Dim.area_mul_yield
  RequestProject.Economy.Interval.mul_mem
  RequestProject.Economy.IQty.harvest_mem
  RequestProject.Economy.Interval.helly_of_pairwise
  RequestProject.Economy.glueAt_glued_iff
  RequestProject.Economy.glueAt_inconsistent_witness
  RequestProject.Economy.glueAt_mono
  RequestProject.Economy.exists_globalSection
  RequestProject.Economy.Period.chain_pairwise_disjoint
  RequestProject.Economy.Period.chain_days_sum
  RequestProject.Economy.RegionRegistry.contains_antisymm
  RequestProject.Economy.IntervalAccount.intervalBalanced_of_exact
  RequestProject.Economy.IntervalAccount.balancedWithin_derived
  RequestProject.Economy.IntervalAccount.derivedTolerance_le_declared_precision
  RequestProject.Economy.Obs.median_mem_range
  RequestProject.Economy.Obs.median_eq_of_weight_majority
  RequestProject.Economy.Obs.mean_influence_unbounded
  RequestProject.Economy.Obs.settle_sound
  RequestProject.Economy.reward_independent_of_value
  RequestProject.Economy.same_bytes_of_same_hash
  RequestProject.Economy.Quorum.card_inter_gt_faultBound
  RequestProject.Economy.naive_threshold_fails
  RequestProject.Economy.certificate_agreement
  RequestProject.Economy.accountability
  RequestProject.Economy.accepts_sound
  RequestProject.Economy.Wheat.satellite_estimate_is_interval_valid
  RequestProject.Economy.Wheat.periods_are_aligned
  RequestProject.Economy.Wheat.observations_have_provenance
  RequestProject.Economy.Wheat.local_sections_are_compatible
  RequestProject.Economy.Wheat.trade_flows_are_accounted
  RequestProject.Economy.Wheat.account_balance_is_verified
  RequestProject.Economy.Wheat.quorum_certificate_is_valid
  RequestProject.Economy.Wheat.baseline_is_accepted
  RequestProject.Economy.Wheat.inflated_reconstruction_is_rejected
  RequestProject.Economy.Wheat.disputed_has_no_global_section
  RequestProject.Economy.Wheat.unlisted_site_fails_provenance
  RequestProject.Economy.Wheat.uncovered_cell_fails_coverage
  RequestProject.Economy.Wheat.settled_yield_is_robust

/-! ## The index -/

/-- One headline result. -/
structure Entry where
  /-- Stable identifier, used by the pages and by the "rests on" edges. -/
  id : String
  /-- Fully-qualified Lean name; must appear in `auditTable`. -/
  name : String
  /-- What it says, in one line of English. -/
  summary : String
  /-- Which part of the development it belongs to. -/
  layer : String
  /-- Which merged development it belongs to. -/
  development : String
  /-- The relay stage it is attached to, if any. -/
  stage : Option Nat
  /-- The identifiers of the results it rests on. -/
  deps : List String
  deriving Repr, Inhabited

/-- Every headline result of the repository. -/
def entries : List Entry :=
  [ ⟨"host-prog", "RequestProject.Relay.Relay.host_prog",
      "Any program of a well-formed relay reprints the program of any stage.",
      "core", "RequestProject.Relay", none, []⟩,
    ⟨"host-self", "RequestProject.Relay.Relay.host_self",
      "Every program of the relay prints itself: each stage is a quine.",
      "core", "RequestProject.Relay", none, ["host-prog"]⟩,
    ⟨"run-prog", "RequestProject.Relay.Relay.run_prog",
      "Running a stage prints the program of the next stage.",
      "core", "RequestProject.Relay", none, ["host-prog"]⟩,
    ⟨"runN-size", "RequestProject.Relay.Relay.runN_size",
      "As many runs as there are stages return the program you started from.",
      "core", "RequestProject.Relay", none, ["run-prog"]⟩,
    ⟨"rebuild-all", "RequestProject.Relay.Relay.rebuildAll_prog",
      "The whole ring from one program: its payload says how many stages there are, and hosting each of them returns every program of the relay, in order.",
      "core", "RequestProject.Relay", none, ["host-prog"]⟩,
    ⟨"stages-read-size", "RequestProject.Relay.stages_readSize",
      "A reader holding any one of the twenty-two programs learns from it alone that the ring has twenty-two stages.",
      "programs", "RequestProject.Relay", none, ["rebuild-all", "stages-wf"]⟩,
    ⟨"stages-rebuild-all", "RequestProject.Relay.stages_rebuild_all",
      "Hand a reader one program, in any of the twenty-two languages, and they can rebuild the other twenty-one — with no description of the relay to go on.",
      "programs", "RequestProject.Relay", none, ["rebuild-all", "stages-wf", "stages-read-size"]⟩,
    ⟨"shape-parse-render", "RequestProject.Relay.Shape.parse_render",
      "Every clean notation for the payload round-trips: written and read back, the digits are unchanged.",
      "shapes", "RequestProject.Relay", none, []⟩,
    ⟨"shape-commute", "RequestProject.Relay.Shape.commute",
      "A payload moves from any notation to any other unchanged.",
      "shapes", "RequestProject.Relay", none, ["shape-parse-render"]⟩,
    ⟨"shapes-round-trip", "RequestProject.Relay.Shapes.round_trip",
      "Each of the six concrete notations — array of chunks, adjacent string literals, table rows, XML text nodes, S-expression, CSV — round-trips.",
      "shapes", "RequestProject.Relay", none, ["shape-parse-render"]⟩,
    ⟨"shapes-interchange", "RequestProject.Relay.Shapes.interchange",
      "All six concrete notations read back identically: the same payload in six clothes.",
      "shapes", "RequestProject.Relay", none, ["shape-commute", "shapes-round-trip"]⟩,
    ⟨"stages-wf", "RequestProject.Relay.stages_wf",
      "The twenty-two real programs form a well-formed relay; checked by the kernel, not by native evaluation.",
      "programs", "RequestProject.Relay", none, []⟩,
    ⟨"stages-size", "RequestProject.Relay.stages_size",
      "The relay has twenty-two stages.",
      "programs", "RequestProject.Relay", none, ["stages-wf"]⟩,
    ⟨"program-host", "RequestProject.Relay.program_host",
      "Every one of the twenty-two programs prints the program of any stage.",
      "programs", "RequestProject.Relay", none, ["host-prog", "stages-wf"]⟩,
    ⟨"program-self", "RequestProject.Relay.program_self",
      "Every one of the twenty-two programs prints itself.",
      "programs", "RequestProject.Relay", none, ["host-self", "stages-wf"]⟩,
    ⟨"program-step", "RequestProject.Relay.program_step",
      "Each of the twenty-two programs prints the next one.",
      "programs", "RequestProject.Relay", none, ["run-prog", "stages-wf"]⟩,
    ⟨"relay-cycle", "RequestProject.Relay.relay_cycle",
      "Twenty-two runs bring the text back to the program it started from: the ring closes.",
      "programs", "RequestProject.Relay", none, ["runN-size", "stages-wf"]⟩,
    ⟨"program-carries-sources", "RequestProject.Relay.program_carries_sources",
      "Every program's payload decodes to the source blocks of all twenty-two programs.",
      "programs", "RequestProject.Relay", none, ["stages-wf"]⟩,
    ⟨"commitment-prog", "RequestProject.Relay.Relay.commitment_prog",
      "Every program commits to the digest of the relay's payload.",
      "commitment", "RequestProject.Relay", none, ["host-prog"]⟩,
    ⟨"commitment-eq", "RequestProject.Relay.Relay.commitment_eq",
      "Any two stages commit to the same value: one payload, many notations.",
      "commitment", "RequestProject.Relay", none, ["commitment-prog"]⟩,
    ⟨"respond-eq", "RequestProject.Relay.Relay.respond_eq",
      "Every stage answers every 'what is your k-th digit?' challenge identically.",
      "commitment", "RequestProject.Relay", none, ["open-payload"]⟩,
    ⟨"open-payload", "RequestProject.Relay.Relay.openPayload_prog",
      "The payload can be extracted in full from the text of any program.",
      "commitment", "RequestProject.Relay", none, ["host-prog"]⟩,
    ⟨"payload-eq-of-respond", "RequestProject.Relay.payload_eq_of_respond",
      "Two texts that answer every challenge alike carry the very same payload.",
      "commitment", "RequestProject.Relay", none, ["open-payload"]⟩,
    ⟨"cargo-read", "RequestProject.Relay.Relay.readCargo_prog",
      "Cargo loaded into the relay can be read back whole out of any program.",
      "cargo", "RequestProject.Relay", none, ["host-prog", "open-payload"]⟩,
    ⟨"cargo-cycle", "RequestProject.Relay.Relay.cargo_survives_cycle",
      "The cargo survives a full trip around the ring.",
      "cargo", "RequestProject.Relay", none, ["cargo-read", "runN-size"]⟩,
    ⟨"cargo-unbounded", "RequestProject.Relay.Relay.cargo_unbounded",
      "For every size there is a cargo of that size the relay carries: the model puts no limit on it.",
      "cargo", "RequestProject.Relay", none, ["cargo-read"]⟩,
    ⟨"stages-carry-cargo", "RequestProject.Relay.stages_carry_cargo",
      "The twenty-two real programs carry the cargo, each in its own notation.",
      "cargo", "RequestProject.Relay", none, ["cargo-read", "stages-wf"]⟩,
    ⟨"stages-cargo-cycle", "RequestProject.Relay.stages_cargo_cycle",
      "Loaded with cargo, the twenty-two-stage ring still closes.",
      "cargo", "RequestProject.Relay", none, ["cargo-cycle", "stages-wf"]⟩,
    ⟨"stages-cargo-unbounded", "RequestProject.Relay.stages_cargo_unbounded",
      "No bound in the model on what the twenty-two programs will carry.",
      "cargo", "RequestProject.Relay", none, ["cargo-unbounded", "stages-wf"]⟩,
    ⟨"rebuild-eq-host", "RequestProject.Relay.rebuild_eq_host",
      "Recovering a builder from a program's own text and applying it to that text's payload is exactly what running the program does.",
      "bootstrap", "RequestProject.Relay", none, []⟩,
    ⟨"recover-prog", "RequestProject.Relay.Relay.recover_prog",
      "The builder of any stage can be recovered from the text of any program.",
      "bootstrap", "RequestProject.Relay", none, ["open-payload"]⟩,
    ⟨"bootstrap-fixed-point", "RequestProject.Relay.Relay.bootstrap_fixed_point",
      "A program is the fixed point of the builder it carries.",
      "bootstrap", "RequestProject.Relay", none, ["rebuild-eq-host", "recover-prog", "host-self"]⟩,
    ⟨"boot-cycle", "RequestProject.Relay.Relay.boot_cycle",
      "The chain of recovered builders returns to its start.",
      "bootstrap", "RequestProject.Relay", none, ["bootstrap-fixed-point", "runN-size"]⟩,
    ⟨"loaded-self-hosting", "RequestProject.Relay.Relay.loaded_self_hosting",
      "A loaded program carries the harness that builds it and is the fixed point of that harness.",
      "bootstrap", "RequestProject.Relay", none, ["bootstrap-fixed-point", "cargo-read"]⟩,
    ⟨"cycle-cost", "RequestProject.Relay.Relay.cycle_cost_le",
      "If every step is inside its budget, so is the whole cycle.",
      "bootstrap", "RequestProject.Relay", none, []⟩,
    ⟨"seed-quine", "RequestProject.Relay.seed_quine",
      "The seed — a relay of length one — reads its own payload and prints itself.",
      "seed", "RequestProject.Relay", none, ["host-self"]⟩,
    ⟨"seed-cycle", "RequestProject.Relay.seed_cycle",
      "The seed's cycle closes in one step.",
      "seed", "RequestProject.Relay", none, ["runN-size", "seed-quine"]⟩,
    ⟨"seed-fixed-point", "RequestProject.Relay.seed_fixed_point",
      "The seed is the fixed point of the builder it carries.",
      "seed", "RequestProject.Relay", none, ["bootstrap-fixed-point", "seed-quine"]⟩,
    ⟨"seed-bytes", "RequestProject.Relay.seed_bytes",
      "The seed is 826 bytes long.",
      "seed", "RequestProject.Relay", none, ["seed-quine"]⟩,
    ⟨"engine-soundness", "RequestProject.Kernel.Provable.tautology",
      "Everything the proof engine's calculus derives is true under every valuation.",
      "engine", "RequestProject.Kernel", none, []⟩,
    ⟨"engine-check-provable", "RequestProject.Kernel.check_provable",
      "Every script the checker accepts is a derivation in the calculus.",
      "engine", "RequestProject.Kernel", none, []⟩,
    ⟨"engine-check-tautology", "RequestProject.Kernel.check_tautology",
      "Whatever the engine accepts, from wherever it came, proves a tautology.",
      "engine", "RequestProject.Kernel", none, ["engine-soundness", "engine-check-provable"]⟩,
    ⟨"engine-consistent", "RequestProject.Kernel.not_proves_fls",
      "The engine never accepts a proof of falsity.",
      "engine", "RequestProject.Kernel", none, ["engine-check-provable"]⟩,
    ⟨"engine-subst", "RequestProject.Kernel.check_subst",
      "Substituting formulas for variables throughout an accepted script yields an accepted script proving the substituted formula.",
      "engine", "RequestProject.Kernel", none, ["engine-check-provable"]⟩,
    ⟨"engine-mutator-safe", "RequestProject.Kernel.mutate_tautology",
      "A mutator cannot be unsound: any mutated script the engine accepts proves a tautology.",
      "engine", "RequestProject.Kernel", none, ["engine-check-tautology"]⟩,
    ⟨"engine-wire-roundtrip", "RequestProject.Kernel.Script.dec_enc",
      "A proof written out in the wire format and read back is the proof you started with.",
      "engine", "RequestProject.Kernel", none, []⟩,
    ⟨"engine-wire-carriable", "RequestProject.Kernel.Script.enc_codeable",
      "The wire format stays inside printable ASCII, so the relay's payload can encode it.",
      "engine", "RequestProject.Kernel", none, ["engine-wire-roundtrip"]⟩,
    ⟨"engine-vectors", "RequestProject.Kernel.vectors_check",
      "Each conformance vector gets the recorded verdict from the engine; a port must agree.",
      "engine", "RequestProject.Kernel", none, ["engine-check-tautology", "engine-wire-roundtrip"]⟩,
    ⟨"engine-vectors-true", "RequestProject.Kernel.vectors_tautology",
      "Every vector that is accepted proves a tautology.",
      "engine", "RequestProject.Kernel", none, ["engine-vectors"]⟩,
    ⟨"engine-completeness", "RequestProject.Kernel.Provable.of_tautology",
      "Every formula true under every valuation is derivable in the engine's calculus: the calculus is complete, not merely sound.",
      "engine", "RequestProject.Kernel", none, []⟩,
    ⟨"engine-adequacy", "RequestProject.Kernel.provable_iff_tautology",
      "Derivability and truth coincide: the Hilbert system the engine implements is exactly classical propositional logic.",
      "engine", "RequestProject.Kernel", none, ["engine-soundness", "engine-completeness"]⟩,
    ⟨"engine-script-complete", "RequestProject.Kernel.check_complete",
      "Every tautology has a flat script the checker accepts: the wire format loses nothing.",
      "engine", "RequestProject.Kernel", none, ["engine-completeness", "engine-check-provable"]⟩,
    ⟨"engine-proves-iff", "RequestProject.Kernel.proves_iff_tautology",
      "A formula is proved by some script exactly when it is true under every valuation.",
      "engine", "RequestProject.Kernel", none, ["engine-check-tautology", "engine-script-complete"]⟩,
    ⟨"engine-decides", "RequestProject.Kernel.isTautology_iff",
      "The engine's finite check over the assignments of a formula's own variables agrees with truth under every valuation.",
      "engine", "RequestProject.Kernel", none, []⟩,
    ⟨"engine-dichotomy", "RequestProject.Kernel.engine_dichotomy",
      "Every formula either has a proof script or has a falsifying valuation, and the engine computes which: there is no third case.",
      "engine", "RequestProject.Kernel", none, ["engine-decides", "engine-proves-iff"]⟩,
    ⟨"engine-prover-sound", "RequestProject.Kernel.prove_sound",
      "The prover's output is a script the checker accepts as a proof of the formula it was asked about.",
      "engine", "RequestProject.Kernel", none, ["engine-check-provable"]⟩,
    ⟨"engine-prover-complete", "RequestProject.Kernel.prove_complete",
      "The prover — Kalmár's construction, run as a program — returns a script for every tautology.",
      "engine", "RequestProject.Kernel", none, ["engine-prover-sound", "engine-decides"]⟩,
    ⟨"engine-prover-iff", "RequestProject.Kernel.prove_isSome_iff_tautology",
      "The prover hands back a script exactly for the tautologies, and that script passes the same check a browser runs.",
      "engine", "RequestProject.Kernel", none, ["engine-prover-complete", "engine-check-tautology"]⟩,
    ⟨"engine-dne-underivable", "RequestProject.Kernel.dne_not_provableKS",
      "Double negation elimination cannot be derived from K and S: a three-valued Heyting model validates those two schemes and refutes it.",
      "engine", "RequestProject.Kernel", none, []⟩,
    ⟨"engine-axiom-needed", "RequestProject.Kernel.axDne_independent",
      "The engine's classical axiom earns its place in the trusted base: Peirce's law is a tautology the calculus proves and the K/S fragment cannot.",
      "engine", "RequestProject.Kernel", none,
      ["engine-dne-underivable", "engine-completeness"]⟩,
    ⟨"proof-carried", "RequestProject.Relay.Relay.proof_carried",
      "A serialised proof script loaded as cargo can be read out of any program of the relay.",
      "proof-carrying", "RequestProject.Relay", none, ["cargo-read", "engine-wire-carriable"]⟩,
    ⟨"proof-recoverable", "RequestProject.Relay.Relay.proof_recoverable",
      "The script read out of any program decodes to the script that was loaded.",
      "proof-carrying", "RequestProject.Relay", none, ["proof-carried", "engine-wire-roundtrip"]⟩,
    ⟨"proof-cycle", "RequestProject.Relay.Relay.proof_survives_cycle",
      "The proof goes all the way around the ring and comes back intact.",
      "proof-carrying", "RequestProject.Relay", none, ["proof-recoverable", "cargo-cycle"]⟩,
    ⟨"stages-transport-proof", "RequestProject.Relay.stages_transport_proof",
      "A single program in any one of twenty-two languages is a complete, checkable proof: what the engine accepted before the journey it accepts after it, and what it proves is true.",
      "proof-carrying", "RequestProject.Relay", none,
      ["proof-recoverable", "engine-check-tautology", "stages-wf"]⟩,
    ⟨"stages-transport-found-proof", "RequestProject.Relay.stages_transport_found_proof",
      "The engine finds the proof and the relay carries it: for any tautology the prover returns a script, and that very script comes back out of each of the twenty-two programs.",
      "proof-carrying", "RequestProject.Relay", none,
      ["engine-prover-complete", "proof-recoverable", "stages-wf"]⟩,
    ⟨"commitment-names-cargo", "RequestProject.Relay.readCargo_eq_of_respond",
      "Two programs that answer every challenge alike carry the same cargo: the published digest names this bundle and no other.",
      "proof-carrying", "RequestProject.Relay", none, ["payload-eq-of-respond", "cargo-read"]⟩,
    ⟨"memes-distinct", "Meme.Quine.quineMemes_files_nodup",
      "The twenty-two quines are twenty-two distinct memes.",
      "memes", "RequestProject.Solfunmeme", some 0, ["stages-size"]⟩,
    ⟨"memes-cover", "Meme.Quine.quineMemes_cover",
      "Between them the memes name all six merged developments.",
      "memes", "RequestProject.Solfunmeme", some 0, ["memes-distinct"]⟩,
    ⟨"memes-share-commitment", "Meme.Quine.memes_share_commitment",
      "Every meme commits to the same payload: one bundle, twenty-two faces.",
      "memes", "RequestProject.Solfunmeme", some 0, ["commitment-eq"]⟩,
    ⟨"memes-mint-all", "Meme.Quine.mint_all_quines",
      "Minting the whole collection is a legal play-through of the SOLFUNMEME engine: forty-four inputs, twenty-two memes.",
      "memes", "RequestProject.Solfunmeme", some 0, ["memes-distinct"]⟩,
    ⟨"memes-badge", "Meme.Quine.mint_unlocks_memeLord",
      "Minting the collection unlocks the memeLord badge.",
      "memes", "RequestProject.Solfunmeme", some 0, ["memes-mint-all"]⟩,
    ⟨"memes-claim-verifies", "Meme.Quine.mintClaim_verify",
      "The published play-through verifies by replay, commitment included.",
      "memes", "RequestProject.Solfunmeme", some 0, ["memes-mint-all"]⟩,
    ⟨"dev-solfunmeme", "SFM.Token.Book.genesis_issued",
      "Solfunmeme: the token ledger issues exactly the genesis supply.",
      "development", "RequestProject.Solfunmeme", some 0, []⟩,
    ⟨"dev-edge", "CfDeploy.WasmKernel.deployKernel_wf",
      "Edge: the deployment kernel it emits is well formed.",
      "development", "RequestProject.Edge", some 1, []⟩,
    ⟨"dev-nix", "Bootstrap.Pantograph.exec_ouroboros",
      "Nix: the pantograph copies itself.",
      "development", "RequestProject.Nix", some 7, []⟩,
    ⟨"dev-gvcs", "LifeTrac.filletThroat_pos",
      "Gvcs: the weld's fillet throat is positive.",
      "development", "RequestProject.Gvcs", some 2, []⟩,
    ⟨"dev-motion", "Hesper.Gif.valOf_bitsOf",
      "Motion: the GIF bit codec round-trips.",
      "development", "RequestProject.Motion", some 3, []⟩,
    ⟨"dev-craft", "CCLua.toLua_exec",
      "Craft: the ComputerCraft Lua compiler preserves execution.",
      "development", "RequestProject.Craft", some 4, []⟩,
    ⟨"econ-dim-area-yield", "RequestProject.Economy.Dim.area_mul_yield",
      "Dimensions are exponent vectors, so acreage times yield is a mass — the product has a type to live in.",
      "economy-theory", "RequestProject.Economy", none, []⟩,
    ⟨"econ-interval-mul", "RequestProject.Economy.Interval.mul_mem",
      "Interval multiplication encloses: any product of values from two intervals lies in the product interval.",
      "economy-theory", "RequestProject.Economy", none, []⟩,
    ⟨"econ-harvest", "RequestProject.Economy.IQty.harvest_mem",
      "Acreage times yield propagates soundly through the uncertainty: the harvest interval contains every admissible product.",
      "economy-theory", "RequestProject.Economy", none, ["econ-dim-area-yield", "econ-interval-mul"]⟩,
    ⟨"econ-helly", "RequestProject.Economy.Interval.helly_of_pairwise",
      "Pairwise compatible interval reports have a common value: Helly in one dimension, proved constructively.",
      "economy-theory", "RequestProject.Economy", none, []⟩,
    ⟨"econ-glue-iff", "RequestProject.Economy.glueAt_glued_iff",
      "The glued interval is exactly the set of values every local report allows — nothing averaged, nothing invented.",
      "economy-theory", "RequestProject.Economy", none, ["econ-helly"]⟩,
    ⟨"econ-glue-conflict", "RequestProject.Economy.glueAt_inconsistent_witness",
      "A failed gluing carries its evidence: two of the local intervals are separated, and a third party can recheck the pair.",
      "economy-theory", "RequestProject.Economy", none, ["econ-helly"]⟩,
    ⟨"econ-glue-mono", "RequestProject.Economy.glueAt_mono",
      "Adding evidence never widens the accepted set.",
      "economy-theory", "RequestProject.Economy", none, ["econ-glue-iff"]⟩,
    ⟨"econ-global-section", "RequestProject.Economy.exists_globalSection",
      "Compatibility at every cell yields a global section, built coordinatewise rather than assumed.",
      "economy-theory", "RequestProject.Economy", none, ["econ-helly"]⟩,
    ⟨"econ-period-disjoint", "RequestProject.Economy.Period.chain_pairwise_disjoint",
      "A consecutive decomposition of a period is pairwise disjoint: aggregation cannot count a day twice.",
      "economy-theory", "RequestProject.Economy", none, []⟩,
    ⟨"econ-period-sum", "RequestProject.Economy.Period.chain_days_sum",
      "The lengths of a consecutive decomposition sum to its span.",
      "economy-theory", "RequestProject.Economy", none, ["econ-period-disjoint"]⟩,
    ⟨"econ-region-order", "RequestProject.Economy.RegionRegistry.contains_antisymm",
      "Region containment from a versioned registry is a genuine partial order, not an equivalence on issuing authority.",
      "economy-theory", "RequestProject.Economy", none, []⟩,
    ⟨"econ-interval-balance", "RequestProject.Economy.IntervalAccount.intervalBalanced_of_exact",
      "If any selection of point values from the declared intervals balances exactly, zero lies in the residual interval.",
      "economy-theory", "RequestProject.Economy", none, []⟩,
    ⟨"econ-derived-tolerance", "RequestProject.Economy.IntervalAccount.balancedWithin_derived",
      "The accounting tolerance is derived from declared precision, not chosen: every selected point account balances within it.",
      "economy-theory", "RequestProject.Economy", none, ["econ-interval-balance"]⟩,
    ⟨"econ-tolerance-bound", "RequestProject.Economy.IntervalAccount.derivedTolerance_le_declared_precision",
      "That tolerance never exceeds the total declared width of the account lines.",
      "economy-theory", "RequestProject.Economy", none, ["econ-derived-tolerance"]⟩,
    ⟨"econ-median-range", "RequestProject.Economy.Obs.median_mem_range",
      "Every weighted median stays inside the honest range while the adversarial weight is under half the total.",
      "economy-theory", "RequestProject.Economy", none, []⟩,
    ⟨"econ-median-majority", "RequestProject.Economy.Obs.median_eq_of_weight_majority",
      "A strict weight majority reporting one value forces that value.",
      "economy-theory", "RequestProject.Economy", none, ["econ-median-range"]⟩,
    ⟨"econ-mean-fragile", "RequestProject.Economy.Obs.mean_influence_unbounded",
      "One positive-weight report moves the weighted mean to any target — why the mean is not the settlement operator.",
      "economy-theory", "RequestProject.Economy", none, []⟩,
    ⟨"econ-settle-sound", "RequestProject.Economy.Obs.settle_sound",
      "A settled value really is a weighted median and really met the thresholds; otherwise the contractual fallback applies.",
      "economy-theory", "RequestProject.Economy", none, ["econ-median-range"]⟩,
    ⟨"econ-payment-neutral", "RequestProject.Economy.reward_independent_of_value",
      "Payment for a field sample depends on protocol compliance and timeliness, not on what was reported.",
      "economy-theory", "RequestProject.Economy", none, []⟩,
    ⟨"econ-hash-integrity", "RequestProject.Economy.same_bytes_of_same_hash",
      "A hash gives content integrity under collision-freedom — and, stated as such, nothing else.",
      "economy-theory", "RequestProject.Economy", none, []⟩,
    ⟨"econ-quorum-intersect", "RequestProject.Economy.Quorum.card_inter_gt_faultBound",
      "Two quorums of a committee share more members than it tolerates faults.",
      "economy-theory", "RequestProject.Economy", none, []⟩,
    ⟨"econ-quorum-naive-fails", "RequestProject.Economy.naive_threshold_fails",
      "The usual 2f+1 threshold is unsound once n exceeds 3f+1: seven members, one fault, two disjoint quorums.",
      "economy-theory", "RequestProject.Economy", none, ["econ-quorum-intersect"]⟩,
    ⟨"econ-agreement", "RequestProject.Economy.certificate_agreement",
      "One committee cannot certify two different states, given at most f faults and no honest equivocation.",
      "economy-theory", "RequestProject.Economy", none, ["econ-quorum-intersect"]⟩,
    ⟨"econ-accountability", "RequestProject.Economy.accountability",
      "Conflicting certificates name at least f+1 nodes that demonstrably signed both states.",
      "economy-theory", "RequestProject.Economy", none, ["econ-quorum-intersect"]⟩,
    ⟨"econ-accepts-sound", "RequestProject.Economy.accepts_sound",
      "The decidable acceptance check means what it says: passing it yields a proof of every acceptance predicate.",
      "economy-theory", "RequestProject.Economy", none,
      ["econ-interval-balance", "econ-global-section"]⟩,
    ⟨"econ-wheat-satellite", "RequestProject.Economy.Wheat.satellite_estimate_is_interval_valid",
      "Wheat slice: the satellite acreage times the calibrated yield encloses every admissible production value.",
      "economy-wheat", "RequestProject.Economy", none, ["econ-harvest"]⟩,
    ⟨"econ-wheat-periods", "RequestProject.Economy.Wheat.periods_are_aligned",
      "Wheat slice: the four quarters are disjoint and sum to the 365 days of the year.",
      "economy-wheat", "RequestProject.Economy", none, ["econ-period-sum"]⟩,
    ⟨"econ-wheat-provenance", "RequestProject.Economy.Wheat.observations_have_provenance",
      "Wheat slice: every local report is traceable to an artifact in the dossier.",
      "economy-wheat", "RequestProject.Economy", none, []⟩,
    ⟨"econ-wheat-compatible", "RequestProject.Economy.Wheat.local_sections_are_compatible",
      "Wheat slice: on every cell the five baseline sites pairwise overlap.",
      "economy-wheat", "RequestProject.Economy", none, ["econ-helly"]⟩,
    ⟨"econ-wheat-trade", "RequestProject.Economy.Wheat.trade_flows_are_accounted",
      "Wheat slice: the two independent trade sources glue to their intersection, and the published export figure lies in it.",
      "economy-wheat", "RequestProject.Economy", none, ["econ-glue-iff", "econ-wheat-compatible"]⟩,
    ⟨"econ-wheat-balance", "RequestProject.Economy.Wheat.account_balance_is_verified",
      "Wheat slice: the identity holds exactly, zero is a possible residual, and the derived tolerance covers the point account.",
      "economy-wheat", "RequestProject.Economy", none, ["econ-derived-tolerance"]⟩,
    ⟨"econ-wheat-quorum", "RequestProject.Economy.Wheat.quorum_certificate_is_valid",
      "Wheat slice: the committee's quorums intersect, the certificate binds the published state, and no two certificates disagree.",
      "economy-wheat", "RequestProject.Economy", none, ["econ-quorum-intersect", "econ-agreement"]⟩,
    ⟨"econ-wheat-accepted", "RequestProject.Economy.Wheat.baseline_is_accepted",
      "Wheat slice: the reconcilable scenario is accepted, and the decidable check agrees with the proof.",
      "economy-wheat", "RequestProject.Economy", none,
      ["econ-accepts-sound", "econ-wheat-balance", "econ-wheat-trade", "econ-wheat-provenance"]⟩,
    ⟨"econ-wheat-rejected", "RequestProject.Economy.Wheat.inflated_reconstruction_is_rejected",
      "Wheat slice: overstating production by 300 000 t is rejected — the acceptance predicates are not vacuous.",
      "economy-wheat", "RequestProject.Economy", none, ["econ-wheat-accepted"]⟩,
    ⟨"econ-wheat-no-section", "RequestProject.Economy.Wheat.disputed_has_no_global_section",
      "Wheat slice, the negative result: with the disputed sixth source there is no reconstruction at all, and the conflict witness proves it.",
      "economy-wheat", "RequestProject.Economy", none, ["econ-glue-conflict"]⟩,
    ⟨"econ-wheat-settlement", "RequestProject.Economy.Wheat.settled_yield_is_robust",
      "Wheat slice: three of ten samples report more than four times the honest yield, and every weighted median still lands in the honest band.",
      "economy-wheat", "RequestProject.Economy", none, ["econ-median-range"]⟩,
    ⟨"econ-wheat-provenance-guard", "RequestProject.Economy.Wheat.unlisted_site_fails_provenance",
      "Wheat slice: a report from a site with no artifact in the dossier fails the provenance field — that field is not vacuous.",
      "economy-wheat", "RequestProject.Economy", none, ["econ-wheat-accepted"]⟩,
    ⟨"econ-wheat-coverage-guard", "RequestProject.Economy.Wheat.uncovered_cell_fails_coverage",
      "Wheat slice: a claimed cell that no report constrains fails the coverage field — that field is not vacuous either.",
      "economy-wheat", "RequestProject.Economy", none, ["econ-wheat-accepted"]⟩ ]

/-! ## Self-checks on the index -/

-- The index is a long list; the kernel computations below need more than the
-- default recursion and elaboration budgets.
set_option maxRecDepth 8000
set_option maxHeartbeats 1000000

/-- The identifiers are distinct. -/
theorem entries_ids_nodup : (entries.map (·.id)).Nodup := by decide

/-- Every entry names a theorem that was audited — and `audit_table` only
accepts names that exist in the environment. -/
theorem entries_audited : ∀ e ∈ entries, (auditTable.lookup e.name).isSome := by decide

/-- Every "rests on" edge points at an entry of the index. -/
theorem entries_deps_closed : ∀ e ∈ entries, ∀ d ∈ e.deps, d ∈ entries.map (·.id) := by decide

/-- Every stage an entry is attached to is a stage of the relay. -/
theorem entries_stage_bounded : ∀ e ∈ entries, ∀ s ∈ e.stage, s < 22 := by decide

/-! ## Rendering -/

open RequestProject.Kernel (jsonStr joinComma vectorsJson)

/-- The axioms of an entry, as recorded by the audit. -/
def axiomsOf (e : Entry) : List String :=
  match auditTable.lookup e.name with
  | some (_, ax) => ax
  | none => []

/-- The module an entry lives in, as recorded by the audit. -/
def moduleOf (e : Entry) : String :=
  match auditTable.lookup e.name with
  | some (m, _) => m
  | none => ""

/-- The file an entry lives in, relative to the repository root. -/
def fileOf (e : Entry) : String :=
  (moduleOf e).replace "." "/" ++ ".lean"

/-- One entry as a JSON object. -/
def Entry.toJson (e : Entry) : String :=
  "{\"id\":" ++ jsonStr e.id ++
  ",\"name\":" ++ jsonStr e.name ++
  ",\"says\":" ++ jsonStr e.summary ++
  ",\"module\":" ++ jsonStr (moduleOf e) ++
  ",\"file\":" ++ jsonStr (fileOf e) ++
  ",\"layer\":" ++ jsonStr e.layer ++
  ",\"development\":" ++ jsonStr e.development ++
  ",\"stage\":" ++ (match e.stage with | none => "null" | some s => toString s) ++
  ",\"axioms\":[" ++ joinComma (axiomsOf e |>.map jsonStr) ++ "]" ++
  ",\"deps\":[" ++ joinComma (e.deps.map jsonStr) ++ "]" ++
  ",\"evidence\":\"kernel-checked\"}"

/-! ### The stages -/

/-- The name of the notation a stage writes its payload in. -/
def shapeName (i : Nat) : String :=
  let s := (stages.stage i).shape
  if s = Shapes.array then "array of chunks"
  else if s = Shapes.raw then "one run of digits"
  else if s = Shapes.concatLines then "adjacent string literals"
  else if s = Shapes.rows then "rows of a keyed table"
  else if s = Shapes.xml then "XML text nodes"
  else if s = Shapes.sexp then "S-expression list"
  else if s = Shapes.csv then "comma-separated digits"
  else "the language's own punctuation"

/-- One stage as a JSON object. -/
def stageJson (i : Nat) : String :=
  "{\"index\":" ++ toString i ++
  ",\"file\":" ++ jsonStr (fileName i) ++
  ",\"language\":" ++ jsonStr (language i) ++
  ",\"project\":" ++ jsonStr (project i) ++
  ",\"command\":" ++ jsonStr (command i) ++
  ",\"shape\":" ++ jsonStr (shapeName i) ++
  ",\"bytes\":" ++ toString (program i).length ++ "}"

/-! ### The WebAssembly commitment kernel -/

/-- The arguments each export of `RequestProject.Kernel.Wasm.commitmentKernel` is
exercised with. -/
def wasmArgs : List (String × List (List Nat)) :=
  [ ("digest_init", [[]]),
    ("digest_step", [[7, 48], [7, 57], [283640, 49], [1000002, 57]]),
    ("is_digit", [[47], [48], [57], [58], [64]]),
    ("dec3", [[0, 6, 4], [1, 0, 0], [9, 9, 9]]),
    ("enc3_hi", [[64], [999], [7]]),
    ("enc3_mid", [[64], [999], [7]]),
    ("enc3_lo", [[64], [999], [7]]) ]

/-- The value an export takes under the Lean semantics of the emitted module. -/
def runWasm (fname : String) (args : List Nat) : Option UInt64 :=
  match RequestProject.Kernel.Wasm.commitmentKernel.funcs.find? (fun f => f.name == fname) with
  | none => none
  | some f => Kant.Wasm.Expr.eval (args.map UInt64.ofNat) f.body

/-- The wasm kernel and its golden vectors, as JSON: what a WebAssembly engine
must reproduce. -/
def wasmJson : String :=
  let vecs := wasmArgs.flatMap fun (fname, argss) =>
    argss.map fun args =>
      "{\"f\":" ++ jsonStr fname ++ ",\"args\":[" ++
        joinComma (args.map fun a => toString a) ++ "],\"expected\":" ++
        toString ((runWasm fname args).getD 0).toNat ++ "}"
  "{\"module\":\"kernel-commitment.wasm\"," ++
  "\"emittedBy\":\"RequestProject.Kernel.Wasm.kernelBytes (the verified encoder of Kant.Wasm.Encode)\"," ++
  "\"wellFormed\":\"RequestProject.Kernel.Wasm.commitmentKernel_wf\"," ++
  "\"bytes\":" ++ toString RequestProject.Kernel.Wasm.kernelBytes.size ++ "," ++
  "\"exports\":[" ++
    joinComma (RequestProject.Kernel.Wasm.commitmentKernel.funcs.map fun f =>
      "{\"name\":" ++ jsonStr f.name ++ ",\"arity\":" ++ toString f.arity ++ "}") ++ "]," ++
  "\"vectors\":[" ++ joinComma vecs ++ "]}"

/-- The whole index: theorems, stages, and the engine's conformance vectors. -/
def manifestJson : String :=
  "{\"generatedBy\":\"lake exe relay-index\"," ++
  "\"note\":\"Generated from the Lean sources. Every theorem listed here was resolved in the environment at build time; its axioms are what the kernel reports.\"," ++
  "\"stageCount\":" ++ toString stages.size ++ "," ++
  "\"seedBytes\":" ++ toString (seed.prog 0).length ++ "," ++
  "\"payloadDigits\":" ++ toString stages.digits.length ++ "," ++
  "\"theorems\":[" ++ joinComma (entries.map Entry.toJson) ++ "]," ++
  "\"stages\":[" ++ joinComma ((List.range stages.size).map stageJson) ++ "]," ++
  "\"engine\":" ++ vectorsJson ++ "," ++
  "\"wasm\":" ++ wasmJson ++ "}"

end RequestProject.Relay.Manifest
