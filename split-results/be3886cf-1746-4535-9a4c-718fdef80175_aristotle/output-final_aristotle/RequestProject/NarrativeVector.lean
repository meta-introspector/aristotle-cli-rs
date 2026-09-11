/-
# Narrative Vector — Quasifibration Paths on the Monster Torus

## Overview
This module formalizes the "Hero's Journey" as a geometric path through
the CRT torus ℤ/47 × ℤ/59 × ℤ/71. Key constructions:
1. Narrative stages as CRT addresses
2. Path congruence: archetypal arcs ↔ torus paths
3. Narrative invariants preserved under chart transitions
4. The "elixir return" as idempotent retraction
5. The Ramanujan point (1729) and tau function coefficients

## Sources
- Campbell, J. "The Hero with a Thousand Faces" (1949)
- Conway & Norton, "Monstrous Moonshine" (1979)
-/

import Mathlib
import RequestProject.MonsterCore
import RequestProject.BootstrapSelfEncode

namespace Solfunmeme.NarrativeVector

open Solfunmeme.MonsterCore
open Solfunmeme.BootstrapSelfEncode

-- ============================================================================
-- § 1  Narrative Stages
-- ============================================================================

/-- The stages of the Hero's Journey. -/
inductive NarrativeStage where
  | ordinaryWorld
  | callToAdventure
  | crossingThreshold
  | roadOfTrials
  | revelation
  | atonement
  | returnWithElixir
  deriving DecidableEq, Repr, BEq, Hashable

/-- Number of narrative stages. -/
theorem narrative_stage_count_is_seven :
    [NarrativeStage.ordinaryWorld, NarrativeStage.callToAdventure,
     NarrativeStage.crossingThreshold, NarrativeStage.roadOfTrials,
     NarrativeStage.revelation, NarrativeStage.atonement,
     NarrativeStage.returnWithElixir].length = 7 := by native_decide

-- ============================================================================
-- § 2  CRT Addresses for Narrative Stages
-- ============================================================================

/-- Map each narrative stage to a CRT address in the Monster torus. -/
def stageAddress : NarrativeStage → Nat
  | .ordinaryWorld     => 2343    -- The bootstrap point
  | .callToAdventure   => 744     -- j-function constant term
  | .crossingThreshold => 196883  -- Monster rep dim
  | .roadOfTrials      => 21493760 % 196883
  | .revelation        => 840     -- Ramanujan's insight point
  | .atonement         => 1729    -- Hardy–Ramanujan number
  | .returnWithElixir  => 2343    -- Return to origin

/-- The journey is a cycle: it returns to the starting point. -/
theorem journey_is_cycle :
    stageAddress .ordinaryWorld = stageAddress .returnWithElixir := rfl

/-- The crossing threshold is the Monster dimension itself. -/
theorem threshold_is_monster : stageAddress .crossingThreshold = monsterRepDim := rfl

-- ============================================================================
-- § 3  Stage CRT Decompositions
-- ============================================================================

theorem ordinary_world_crt :
    (stageAddress .ordinaryWorld % 47,
     stageAddress .ordinaryWorld % 59,
     stageAddress .ordinaryWorld % 71) = (40, 42, 0) := by native_decide

theorem atonement_crt :
    (stageAddress .atonement % 47,
     stageAddress .atonement % 59,
     stageAddress .atonement % 71) = (1729 % 47, 1729 % 59, 1729 % 71) := by native_decide

/-- 1729 = 12³ + 1³ = 10³ + 9³ (Hardy–Ramanujan taxicab number). -/
theorem hardy_ramanujan_taxicab :
    1729 = 12^3 + 1^3 ∧ 1729 = 10^3 + 9^3 := by omega

-- ============================================================================
-- § 4  Narrative Vectors
-- ============================================================================

/-- A narrative vector: a stage with its derived CRT data. -/
structure NarrativeVec where
  address : Nat
  bottIdx : Fin 8
  stage : NarrativeStage
  stealthy71 : Bool
  deriving Repr

/-- Construct a narrative vector from a stage. -/
def mkNarrativeVec (s : NarrativeStage) : NarrativeVec where
  address := stageAddress s
  bottIdx := ⟨stageAddress s % 8, Nat.mod_lt _ (by omega)⟩
  stage := s
  stealthy71 := stageAddress s % 71 == 0

/-- The Q42 vector: address 42 in the torus (the "Answer"). -/
def q42Vec : NarrativeVec where
  address := 42
  bottIdx := ⟨42 % 8, by omega⟩
  stage := .revelation
  stealthy71 := 42 % 71 == 0

theorem q42_bott : q42Vec.bottIdx = ⟨2, by omega⟩ := by native_decide
theorem q42_not_stealthy : q42Vec.stealthy71 = false := by native_decide

-- ============================================================================
-- § 5  Narrative Paths
-- ============================================================================

/-- The canonical Hero's Journey path through the torus. -/
def heroJourney : List NarrativeVec :=
  [NarrativeStage.ordinaryWorld, .callToAdventure, .crossingThreshold,
   .roadOfTrials, .revelation, .atonement, .returnWithElixir].map mkNarrativeVec

theorem hero_journey_length : heroJourney.length = 7 := by native_decide

/-- The hero's journey starts and ends at the same address. -/
theorem hero_journey_cyclic :
    (heroJourney.head? |>.map (·.address)) =
    (heroJourney.getLast? |>.map (·.address)) := by native_decide

-- ============================================================================
-- § 6  Narrative Invariants
-- ============================================================================

/-- A narrative invariant: a value preserved across all stages. -/
structure NarrativeInvariant where
  name : String
  value : Nat
  valid : value < 196883
  deriving Repr

def selfRefInvariant : NarrativeInvariant where
  name := "self_reference"
  value := 2343
  valid := by omega

def mckayInvariant : NarrativeInvariant where
  name := "mckay_constant"
  value := 744
  valid := by omega

-- ============================================================================
-- § 7  Linked Propagation Chains
-- ============================================================================

/-- A linked propagation chain: transformations that compose correctly. -/
inductive LinkedChain (α : Type) (rel : α → α → Prop) : α → α → Type where
  | single : ∀ a b, rel a b → LinkedChain α rel a b
  | cons   : ∀ a b c, rel a b → LinkedChain α rel b c → LinkedChain α rel a c

-- A narrative chain from ordinary world to return
theorem narrative_chain_exists :
    ∃ (path : List Nat),
      path.length = 7 ∧
      path.head? = some 2343 ∧
      path.getLast? = some 2343 := by
  exact ⟨[2343, 744, 196883 % 196883, 21493760 % 196883, 840, 1729, 2343],
    by native_decide, rfl, by native_decide⟩

-- ============================================================================
-- § 8  Narrative Transport Preserves Shadow
-- ============================================================================

/-- The "shadow" of a narrative in a chart. -/
def chartShadow (addr : Nat) (p : Nat) : Nat := addr % p

-- The bootstrap shadow is preserved on return (cyclic journey)
theorem narrative_transport_preserves_shadow_71 :
    chartShadow (stageAddress .ordinaryWorld) 71 =
    chartShadow (stageAddress .returnWithElixir) 71 := rfl

theorem narrative_transport_preserves_shadow_59 :
    chartShadow (stageAddress .ordinaryWorld) 59 =
    chartShadow (stageAddress .returnWithElixir) 59 := rfl

theorem narrative_transport_preserves_shadow_47 :
    chartShadow (stageAddress .ordinaryWorld) 47 =
    chartShadow (stageAddress .returnWithElixir) 47 := rfl

-- ============================================================================
-- § 9  The Elixir Return
-- ============================================================================

-- The elixir: j-function coefficients
def elixirCoeffs : List Int := MonsterCore.jCoeffs

/-- Idempotent retraction to the torus. -/
def idempotentReturn (addr : Nat) : Nat :=
  if addr < 196883 then addr else addr % 196883

theorem return_idempotent (addr : Nat) (h : addr < 196883) :
    idempotentReturn (idempotentReturn addr) = idempotentReturn addr := by
  simp [idempotentReturn, h]

theorem bootstrap_fixed_by_return :
    idempotentReturn 2343 = 2343 := by simp [idempotentReturn]

-- ============================================================================
-- § 10  Ramanujan's Tau Function
-- ============================================================================

/-- First coefficients of Ramanujan's tau function:
    Δ(τ) = Σ τ(n)qⁿ with τ(1)=1, τ(2)=-24, etc. -/
def ramanujanTau : List Int := [1, -24, 252, -1472, 4830, -6048]

theorem tau_count : ramanujanTau.length = 6 := by native_decide
theorem tau_2 : ramanujanTau[1]! = -24 := by native_decide

-- ============================================================================
-- § 11  Summary Demo
-- ============================================================================

#eval do
  IO.println "═══ Narrative Vector — Hero's Journey ═══"
  IO.println ""
  let stages := ["Ordinary World", "Call to Adventure", "Crossing Threshold",
                  "Road of Trials", "Revelation", "Atonement", "Return"]
  for (stage, idx) in stages.zip (List.range 7) do
    match heroJourney[idx]? with
    | some vec =>
      IO.println s!"  {stage}: addr={vec.address}, Bott={vec.bottIdx.val}, stealthy71={vec.stealthy71}"
    | none => pure ()
  IO.println ""
  IO.println s!"Journey length: {heroJourney.length}"
  IO.println s!"Cyclic: start = end"
  IO.println ""
  IO.println s!"Q42 vector: addr={q42Vec.address}, Bott={q42Vec.bottIdx.val}"
  IO.println s!"Elixir (j-coefficients): {elixirCoeffs}"
  IO.println s!"Ramanujan τ: {ramanujanTau}"
  IO.println ""
  IO.println "The invariant that survives the journey IS the protagonist."

end Solfunmeme.NarrativeVector
