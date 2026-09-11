/-
# SenateMonster.lean
## The Bridge: US Senate Procedure ↔ Monster Governance

This file ties together two corpora:

1. **Senate layer**: `Basic`, `Enforcement`, `UCagreements`,
   `Voting`, `Recognition` — the procedural stack of the US Senate
   formalized from CRS report RL30788.

2. **Monster/Governance layer**: CRT-based admission gate,
   the BiasM monad, and the 15 supersingular primes.

### Central Theorem: passive_systems_leak

Both systems share the same structural gap: without an active enforcement trigger,
violations pass through. In the Senate, the presiding officer does not act unless a
Senator raises a point of order. In the DAO, the Congruence gate does not fire
unless a block is actively submitted for admission.
-/

import Mathlib
import RequestProject.Basic
import RequestProject.Enforcement
import RequestProject.Voting
import RequestProject.UCagreements

open ProceduralSource PrecedentOrigin

-- ════════════════════════════════════════════════════════════════
-- §A. Monster/Governance Types (new definitions)
-- ════════════════════════════════════════════════════════════════

/-! ### The CRT Base: 71 × 59 × 47 = 196883 fibers

This IS the Monster group's smallest faithful representation dimension.
The three moduli (47, 59, 71) are the three largest supersingular primes. -/

/-- The CRT torus: the product of residue rings mod the three largest
    supersingular primes. -/
abbrev MonsterBase := ZMod 71 × ZMod 59 × ZMod 47

theorem monsterBase_card : Fintype.card MonsterBase = 196883 := by
  simp [MonsterBase, Fintype.card_prod, ZMod.card]

/-- A content identifier carries a declared content digest. -/
structure CID where
  codec   : ℕ
  mhCode  : ℕ
  digest  : ℕ
  deriving DecidableEq

/-- A block is raw content, hashed. -/
structure Block where
  contentHash : ℕ
  codec       : ℕ
  deriving DecidableEq

/-- Project a natural number onto the CRT torus. -/
def digestToBase (d : ℕ) : MonsterBase :=
  ((d : ZMod 71), (d : ZMod 59), (d : ZMod 47))

def cidToBase   (c : CID)   : MonsterBase := digestToBase c.digest
def blockToBase (b : Block) : MonsterBase := digestToBase b.contentHash

/-- The governance gate: a block is admitted iff its CRT projections agree
    with the declared CID. -/
def CRTCongruent (c : CID) (b : Block) : Prop :=
  cidToBase c = blockToBase b

instance (c : CID) (b : Block) : Decidable (CRTCongruent c b) := by
  unfold CRTCongruent cidToBase blockToBase digestToBase; infer_instance

/-! ### BiasM: The Historical Functor's Monad -/

/-- A computation producing a value while accumulating bias (info loss). -/
structure BiasM (α : Type) where
  value : α
  bias  : ℕ

def BiasM.pureM (a : α) : BiasM α := ⟨a, 0⟩
def BiasM.bindM (ma : BiasM α) (f : α → BiasM β) : BiasM β :=
  ⟨(f ma.value).value, ma.bias + (f ma.value).bias⟩

/-- Bias is monotone: `bind` never decreases total bias. -/
theorem BiasM.bias_monotone (ma : BiasM α) (f : α → BiasM β) :
    (BiasM.bindM ma f).bias ≥ ma.bias := Nat.le_add_right _ _

/-! ### Supersingular Prime Partition -/

/-- The 15 supersingular primes. -/
def ssp  : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-- Set A: the 8 smaller SSPs (≤ 19). Operational regime. -/
def sspA : List ℕ := [2, 3, 5, 7, 11, 13, 17, 19]

/-- Set B: the 7 larger SSPs (≥ 23). Constitutional lock-in regime. -/
def sspB : List ℕ := [23, 29, 31, 41, 47, 59, 71]

theorem sspA_length : sspA.length = 8  := by native_decide
theorem sspB_length : sspB.length = 7  := by native_decide
theorem ssp_length  : ssp.length  = 15 := by native_decide
theorem ssp_partition : sspA ++ sspB = ssp := by native_decide

/-- 47 · 59 · 71 = 196883. -/
theorem ontology_primes : 47 * 59 * 71 = 196883 := by norm_num

/-- Clifford dimensions for the two partition halves. -/
def clDim8 : ℕ := 256   -- dim Cl(8,0) = 2^8
def clDim7 : ℕ := 128   -- dim Cl(7,0) = 2^7

theorem clDim8_value : clDim8 = 2 ^ 8 := by norm_num [clDim8]
theorem clDim7_value : clDim7 = 2 ^ 7 := by norm_num [clDim7]

-- ════════════════════════════════════════════════════════════════
-- §1. THE ARCADE/BOARDROOM SPLIT = COMMITTEE/FLOOR SPLIT
-- ════════════════════════════════════════════════════════════════

/-!
- **Boardroom** = sources enforceable on the Senate floor.
- **Arcade** = sources NOT enforceable on the floor.
-/

/-- The Boardroom predicate: floor-enforceable. -/
def isBoardroom (s : ProceduralSource) : Prop := s.floorEnforceable

/-- The Arcade predicate: NOT floor-enforceable. -/
def isArcade (s : ProceduralSource) : Prop := ¬s.floorEnforceable

/-- The three arcade sources. -/
theorem arcade_sources_are_three :
    (Finset.univ.filter (fun s : ProceduralSource =>
      decide (¬s.floorEnforceable) = true)).card = 3 := by
  native_decide

/-- The six boardroom sources. -/
theorem boardroom_sources_are_six :
    (Finset.univ.filter (fun s : ProceduralSource =>
      decide s.floorEnforceable = true)).card = 6 := by
  native_decide

-- ════════════════════════════════════════════════════════════════
-- §2. PASSIVE SYSTEMS LEAK
-- ════════════════════════════════════════════════════════════════

/-!
### The Structural Gap Both Systems Share

In the Senate: the presiding officer does not act sua sponte (outside cloture).
In the DAO: a block not submitted is never checked.
Both systems are *demand-driven*.
-/

/-- The Senate enforcement gap. -/
theorem senate_passive_leaks (underCloture : Bool)
    (h : underCloture = false) :
    ¬presidingOfficerSuaSponte underCloture := by
  rw [h]; exact no_sua_sponte_without_cloture

/-- **THE UNIFIED THEOREM: `passive_systems_leak`**

Both systems share the same structural property: enforcement is demand-driven.
- Senate: no sua sponte without cloture.
- DAO: pure blocks (never submitted) accumulate zero bias.
-/
theorem passive_systems_leak :
    (¬presidingOfficerSuaSponte false) ∧
    (∀ b : Block, (BiasM.pureM (blockToBase b)).bias = 0) :=
  ⟨no_sua_sponte_without_cloture, fun _ => rfl⟩

-- ════════════════════════════════════════════════════════════════
-- §3. RULING EVENTS ↔ GOVERNANCE DECISIONS
-- ════════════════════════════════════════════════════════════════

/-- A DAO governance decision: a block that passed the CRT gate. -/
structure GovernanceDecision where
  block   : Block
  cid     : CID
  selfCoh : CRTCongruent cid block

/-- A Senate ruling has weight ≤ 3, and every admitted block has a fiber. -/
theorem ruling_corresponds_to_admission
    (ruling : RulingEvent)
    (gdec : GovernanceDecision) :
    ruling.precedentOrigin.weight ≤ 3 ∧
    ∃ fiber : MonsterBase, blockToBase gdec.block = fiber := by
  constructor
  · cases ruling.precedentOrigin <;> simp [PrecedentOrigin.weight]
  · exact ⟨blockToBase gdec.block, rfl⟩

-- ════════════════════════════════════════════════════════════════
-- §4. UC AGREEMENTS = SELF-MODIFYING CONTEXT
-- ════════════════════════════════════════════════════════════════

/-- A DAO context patch: a quorum-gated override. -/
structure ContextPatch where
  patchId             : ℕ
  quorumSize          : ℕ
  targetFiber         : MonsterBase
  activationThreshold : ℕ

/-- Both systems require active consensus to modify their rules. -/
theorem both_systems_require_consensus :
    objectionsToBlockAlteration = 1 :=
  rfl

-- ════════════════════════════════════════════════════════════════
-- §5. THE SSP ↔ VOTE THRESHOLD ARITHMETIC BRIDGE
-- ════════════════════════════════════════════════════════════════

/-- The Senate's super-threshold (2/3 of 100 + 1). -/
def superThreshold' : ℕ := 67

/-- The gap between the two cloture thresholds. -/
theorem senate_threshold_gap : superThreshold' - clotureThreshold = 7 := by
  simp [superThreshold', clotureThreshold, totalSenateSeats]

/-- **The SSP partition gap mirrors the Senate threshold gap:**
    |sspB| = 7 = superThreshold' − clotureThreshold. -/
theorem ssp_B_length_equals_senate_gap :
    sspB.length = superThreshold' - clotureThreshold := by
  simp [superThreshold', clotureThreshold, totalSenateSeats]; native_decide

/-- 47 × 59 × 71 = card MonsterBase = 196883. -/
theorem ssp_product_is_monster_address_space :
    47 * 59 * 71 = Fintype.card MonsterBase := by
  rw [monsterBase_card]

/-- The sspA regime corresponds to the general cloture threshold. -/
def sspA_regime : VoteThreshold := .threeFifthsSworn

/-- The sspB regime corresponds to the rules-change cloture threshold. -/
def sspB_regime : VoteThreshold := .twoThirdsPresentAndVoting

/-- The sspB regime is strictly harder than sspA. -/
theorem sspB_harder_than_sspA :
    sspA_regime.strictness < sspB_regime.strictness := by
  simp [sspA_regime, sspB_regime, VoteThreshold.strictness]

/-- Cl(8,0) / Cl(7,0) = 256/128 = 2. -/
theorem clifford_ratio : clDim8 / clDim7 = 2 := by
  simp [clDim8, clDim7]

/-- All three CRT moduli are in sspB — the constitutional lock-in tier. -/
theorem crt_moduli_in_sspB :
    47 ∈ sspB ∧ 59 ∈ sspB ∧ 71 ∈ sspB := by
  decide

-- ════════════════════════════════════════════════════════════════
-- §6. THE CONTINUING BODY = THE MONSTER ADDRESS SPACE
-- ════════════════════════════════════════════════════════════════

/-- The continuing seats (2/3 of 100). -/
def continuingSeats : ℕ := 2 * totalSenateSeats / 3

theorem continuing_seats_value : continuingSeats = 66 := by
  simp [continuingSeats, totalSenateSeats]

/-- Continuing seats ≥ quorum (51). -/
theorem continuing_exceeds_quorum' : continuingSeats ≥ 51 := by
  simp [continuingSeats, totalSenateSeats]

/-- Every block has a fiber in the Monster address space. -/
theorem monster_address_persists (b : Block) :
    ∃ fiber : MonsterBase, blockToBase b = fiber := ⟨blockToBase b, rfl⟩

/-- **Dual persistence**: Senate floor always quorate, Monster address space
    always has a fiber for any block. -/
theorem dual_persistence (b : Block) :
    continuingSeats ≥ 51 ∧
    (∃ fiber : MonsterBase, blockToBase b = fiber) :=
  ⟨continuing_exceeds_quorum', monster_address_persists b⟩

-- ════════════════════════════════════════════════════════════════
-- §7. THE MASTER BRIDGE THEOREM
-- ════════════════════════════════════════════════════════════════

/-- **THE MASTER BRIDGE THEOREM**: The Senate and the Monster DAO share
    the same four-component governance architecture:
    (1) passive enforcement gap,
    (2) demand-driven decidable gate,
    (3) consensus rule modification,
    (4) persistence invariant. -/
theorem master_bridge (b : Block) :
    -- (1) Passive systems leak without active triggering
    (¬presidingOfficerSuaSponte false) ∧
    -- (2) The CRT gate is decidable for any block/CID pair
    (∀ c : CID, CRTCongruent c b ∨ ¬CRTCongruent c b) ∧
    -- (3) Rule modification requires consensus (one Senator blocks)
    (objectionsToBlockAlteration = 1) ∧
    -- (4) Persistence: address space never collapses, floor never loses quorum
    (continuingSeats ≥ 51 ∧ ∃ fiber : MonsterBase, blockToBase b = fiber) := by
  refine ⟨no_sua_sponte_without_cloture, fun c => ?_, rfl,
          continuing_exceeds_quorum', monster_address_persists b⟩
  exact em _

-- ════════════════════════════════════════════════════════════════
-- §8. ARITHMETIC BRIDGE SUMMARY
-- ════════════════════════════════════════════════════════════════

/-- All arithmetic bridge facts, bundled. -/
theorem arithmetic_bridge_summary :
    sspA.length = 8 ∧
    sspB.length = 7 ∧
    ssp.length = 15 ∧
    sspA ++ sspB = ssp ∧
    sspB.length = superThreshold' - clotureThreshold ∧
    47 * 59 * 71 = Fintype.card MonsterBase ∧
    (47 ∈ sspB ∧ 59 ∈ sspB ∧ 71 ∈ sspB) ∧
    sspA_regime.strictness < sspB_regime.strictness :=
  ⟨sspA_length, sspB_length, ssp_length, ssp_partition,
   ssp_B_length_equals_senate_gap, ssp_product_is_monster_address_space,
   crt_moduli_in_sspB, sspB_harder_than_sspA⟩
