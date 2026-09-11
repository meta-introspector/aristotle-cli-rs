import RequestProject.HubGeometry
import RequestProject.OracleMonad
import RequestProject.CrankToRamanujan
import RequestProject.CambridgeAnomaly
import RequestProject.RamanujanCrankBridge
import RequestProject.ATLASGroups
import RequestProject.MonsterConjugacy
import RequestProject.ModularFormCore
import RequestProject.MonsterRepCategory

/-!
# RamanujanCrank.API — Clean Re-Export Module

This is the single entry point for the Ramanujan–Crank theory stack.
Import this file to get access to all key definitions and theorems
with clean names. This is what future collaborators should import.

## Provided namespaces
- `HubGeometry`: arithmetic attractors, Monster alignment
- `OracleMonad`: monad laws, simulation lemma, oracle API
- `CrankToRamanujan`: inverse bridge, signatures, uniqueness
- `CambridgeAnomaly`: anomaly structure, congruence templates
- `MonsterConjugacy`: 194 conjugacy class labels, character values, McKay–Thompson data
- `ModularFormCore`: q-expansions, Eisenstein series, j-invariant, Hecke operators
- `MonsterRepCategory`: representation ring, tensor decomposition, character orthogonality spec
- From `Crankmining`: Crank, OodaM, PoSW, massRestore, MetaMeme
- From `RamanujanCrankBridge`: RamanujanObj, ramanujanToCrank, DreamFormula
- From `QExpansionVerify`: ramanujanTau, sigma11Val, Leech theta
-/

/-! ## Quick Reference

### Core Types
- `Crankmining.CrankName` — theory name identifier
- `Crankmining.Crank` — candidate TOE with fiber state
- `Crankmining.OodaM` — the OODA state monad
- `Crankmining.PoSW` — proof of succinct work
- `Crankmining.RestoredCrank` — blade-normalized crank
- `Crankmining.MetaMeme` — self-referential fixed point at Hub
- `RamanujanCrankBridge.RamanujanObj` — mathematical formula with metadata
- `RamanujanCrankBridge.DreamFormula` — oracle revelation
- `CrankToRamanujan.CrankSignature` — structural fingerprint
- `CrankToRamanujan.RamanujanReconstruction` — inverse bridge certificate
- `HubGeometry.ArithmeticAttractor` — generalized taxicab attractor
- `CambridgeAnomaly.CambridgeAnomalyData` — anomaly structure
- `CambridgeAnomaly.CongruenceWitness` — verified congruence instance

### Core Functions
- `Crankmining.monsterHash` — CrankName → S_ss
- `Crankmining.mkCrank` — create initial crank
- `Crankmining.crankmine` — full mining pipeline
- `RamanujanCrankBridge.ramanujanToCrank` — Ramanujan → Crank functor
- `OracleMonad.oracleProduceCrank` — oracle-based crank production

### Key Theorems (Invariants)

#### Monster-Hash Preservation
- `Crankmining.Crank.evolveN_preserves_coordinate`
- `RamanujanCrankBridge.ramanujanToCrank_preserves_hash`
- `OracleMonad.oracleProduceCrank_hash`

#### Bott Periodicity of τ
- `RamanujanCrankBridge.eta24_bott_cycles` — 24/8 = 3 cycles
- `RamanujanCrankBridge.tau_bott_class` — Δ has Bott class 4

#### Hub vs Attractor Separation
- `HubGeometry.hub_attractor_separation_pos`
- `RamanujanCrankBridge.taxicab_ne_hub`

#### Fiber Preservation (Oracle)
- `Crankmining.oodaCycle_preserves_base`
- `OracleMonad.repeatN_preserves_base`
- `OracleMonad.FiberPreserving` typeclass

#### Monad Laws
- `OracleMonad.OodaM_left_identity`
- `OracleMonad.OodaM_right_identity`
- `OracleMonad.OodaM_assoc`

#### Simulation
- `OracleMonad.simulation_lemma` — repeatN k ≡ oodaCycleN k

#### Bidirectional Bridge
- `CrankToRamanujan.forward_signature_match` — forward direction
- `CrankToRamanujan.delta_signature_unique` — partial converse for Δ
- `CrankToRamanujan.roundtrip_signature` — roundtrip property

#### Congruences
- `CambridgeAnomaly.ramanujanVerified` — τ ≡ σ₁₁ (mod 691) for n = 1..10

#### Monster Alignment
- `HubGeometry.taxicab_monster_aligned` — 1729 is Monster-aligned
- `HubGeometry.ogg_primes_divide_monster` — Ogg primes divide |M|

#### Monster Internals (NEW)
- `MonsterConjugacy.ConjClassLabel` — 194 conjugacy class labels (1A..119B)
- `MonsterConjugacy.elementOrder` — element order for each class
- `MonsterConjugacy.chi1` — character of ρ₁ on key classes
- `MonsterConjugacy.mckayThompsonCoeffs` — first T_g coefficients
- `MonsterConjugacy.monstrousMoonshineStatement` — genus-zero conjecture (stated)

#### Modular Forms (NEW)
- `ModularFormCore.E4`, `E6`, `Delta`, `jInvariant` — classical modular forms as q-expansions
- `ModularFormCore.j_c1_mckay` — j-coeff c₁ = 1 + 196883
- `ModularFormCore.j_c1_decomp`, `j_c2_decomp`, `j_c3_decomp` — irrep decompositions
- `ModularFormCore.heckeCoeff` — Hecke operator on q-expansions
- `ModularFormCore.hecke_eigenvalue_E4_check` — E₄ is a Hecke eigenform

#### Representation Ring (NEW)
- `MonsterRepCategory.VirtualRep` — elements of the Grothendieck ring R(M)
- `MonsterRepCategory.directSum_comm`, `directSum_assoc` — ring axioms
- `MonsterRepCategory.TensorRule` — tensor product decomposition data
- `MonsterRepCategory.CharacterOrthogonality` — orthogonality specification
-/
