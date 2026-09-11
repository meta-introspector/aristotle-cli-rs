/-
# HistoricalProjection — The Victors' Forgetful Functor

## The epistemic sieve formalized

A forgetful functor in mathematics means: two distinct objects become
indistinguishable after projection. The non-invertibility theorem says:
the boardroom image cannot determine which arcade history produced it.

This is a rigorous statement with many readings:
- "History is written by the victors"
- Memory consolidation in brains
- Lossy compression
- Statistical mechanics (microstates → macrostate)
- Compiler optimization
- Quotient constructions in mathematics

This module makes the information loss **explicit and typed** through:

1. `BoundaryLoss` — a witness carrying what was forgotten
2. `HistoricalProjection` — the honest name for `toBoardroom`
3. `same_boardroom_different_arcades` — the key theorem:
   multiple distinct histories can produce the same official record
4. `HistoricalProjectionWithLoss` — the lifted projection that carries
   the loss witness alongside the sanitized record
5. `boundary_loss_irreversible` — the boardroom cannot recover what was lost

### GRR Analogy

The structure here is analogous to Grothendieck–Riemann–Roch:
pushforward changes information, but characteristic classes compensate.
`BoundaryLoss` plays the role of the correction term — it records
*how much* the projection distorted the original.

### Import discipline

This module imports TentacleCore (which imports HyphaCore).
It extends the regime boundary with loss-tracking machinery.
-/

import Mathlib
import RequestProject.TentacleCore

set_option maxHeartbeats 800000

open ZMod Finset HeroMonster FixedPoint MonsterMycology

/-! ## §1. BoundaryLoss — The Missing-Information Witness

The data that is provably lost when crossing the regime boundary.
This is the kernel witness of the forgetful functor. -/

/-- A record of information lost when projecting from arcade to boardroom.
    This is the typed shadow of what the victors chose not to remember. -/
structure BoundaryLoss where
  /-- The feedback signals that were discarded (failed attempts) -/
  missedAttempts : List FeedbackSignal
  /-- Number of branches explored but not recorded -/
  discardedBranches : ℕ
  /-- Quantitative measure of information lost (e.g. total wasted work) -/
  informationDrop : ℕ
  deriving Repr

/-- The trivial loss: nothing was forgotten (no failed attempts). -/
def BoundaryLoss.trivial : BoundaryLoss where
  missedAttempts := []
  discardedBranches := 0
  informationDrop := 0

/-- Whether the loss is trivial (nothing was actually forgotten). -/
def BoundaryLoss.isTrivial (loss : BoundaryLoss) : Bool :=
  loss.missedAttempts.isEmpty && loss.discardedBranches == 0 && loss.informationDrop == 0

/-- Non-trivial loss: something was genuinely forgotten. -/
def BoundaryLoss.isNonTrivial (loss : BoundaryLoss) : Prop :=
  loss.missedAttempts ≠ [] ∨ loss.discardedBranches > 0 ∨ loss.informationDrop > 0

/-! ## §2. HistoricalProjection — The Honest Name

`toBoardroom` is the forgetful functor. `HistoricalProjection` is its
interpretation: the directional, non-invertible, ideological projection
from full arcade experience to sanitized boardroom record. -/

/-- The Historical Projection: the forgetful functor from arcade to boardroom.
    This is `toBoardroom` with its true name exposed.

    It is:
    - **Directional**: arcade → boardroom, never the reverse
    - **Non-invertible**: by `regime_boundary_strict`
    - **Ideological**: the boardroom receives a projection, not a truth -/
abbrev HistoricalProjection := FeedbackMemeSystem.toBoardroom

/-! ## §3. HistoricalProjectionWithLoss — The Lifted Projection

The honest version of history: carries both the projection AND
a witness of what died crossing the boundary. -/

/-- The result of an honest historical projection: the sanitized boardroom
    record together with a typed witness of what was lost. -/
structure HistoricalProjectionResult where
  /-- The boardroom record (what survives the projection) -/
  boardroom : MemeSystem
  /-- The loss witness (what died crossing the boundary) -/
  loss : BoundaryLoss

/-- The lifted projection: produces both the boardroom record and a
    typed witness of what was forgotten.

    Unlike `toBoardroom` which silently erases data, this function
    makes the erasure observable. -/
noncomputable def HistoricalProjectionWithLoss
    (fsys : FeedbackMemeSystem) : HistoricalProjectionResult where
  boardroom := HistoricalProjection fsys
  loss := {
    missedAttempts := (fsys.path.flatMap (fun s =>
      (fsys.failedAttempts s).map (fun _ =>
        FeedbackSignal.mk "failed attempt" "substrate rejected" 1))).take 100
    discardedBranches := (fsys.path.map (fun s => (fsys.failedAttempts s).length)).sum
    informationDrop := (fsys.path.map (fun s => (fsys.failedAttempts s).length)).sum
  }

/-! ## §4. The Key Theorem: Same Boardroom, Different Arcades

This is the formal heart of the entire story:

  ∃ A B : FeedbackMemeSystem,
    A ≠ B ∧ HistoricalProjection A = HistoricalProjection B

Multiple distinct histories can produce the same official record.
Everything else — memory, compression, survivorship bias, historical
narratives, reconstruction problems — follows from this. -/

/-
Two FeedbackMemeSystems that differ only in their failed attempts
    project to the same boardroom record. This is the fundamental
    theorem of lossy history: the official record cannot distinguish
    between different patterns of failure.
-/
theorem same_boardroom_different_arcades :
    ∃ A B : FeedbackMemeSystem,
      A ≠ B ∧ HistoricalProjection A = HistoricalProjection B := by
  refine' ⟨ _, _, _, _ ⟩;
  refine' ⟨ Bool, fun b => if b = Bool.true then some Bool.false else none, fun b => b = Bool.true, [ Bool.true ], by decide, by decide, by decide, fun _ => [ Bool.true ], by decide ⟩;
  refine' ⟨ Bool, fun b => if b = Bool.true then some Bool.false else none, fun b => b = Bool.true, [ Bool.true ], by simp +decide, by simp +decide, by simp +decide, fun _ => [ ], by simp +decide ⟩;
  · grind;
  · rfl

/-! ## §5. Non-Recoverability — The Boardroom Cannot Undo the Projection

Given only the boardroom record, it is impossible to determine
which arcade history produced it. This is the formal statement of:
"If something was lost, no agent can reconstruct the original." -/

/-
The regime boundary is strictly information-losing:
    there exist arcade states that the boardroom cannot distinguish.
    This is a direct consequence of `regime_boundary_strict`.
-/
theorem historical_projection_noninvertible :
    ¬ ∃ (recover : MemeSystem → FeedbackMemeSystem),
      ∀ fsys, recover (HistoricalProjection fsys) = fsys := by
  obtain ⟨A, B, h_ne, h_eq⟩ : ∃ A B : FeedbackMemeSystem, A ≠ B ∧ HistoricalProjection A = HistoricalProjection B := same_boardroom_different_arcades;
  grind

/-! ## §6. Victor's Bias — Quantifying the Distortion

How much does the boardroom record deviate from the full arcade history?
This is measured by the total number of discarded failure branches. -/

/-- The victor's bias of an arcade system: the total number of failed
    attempts that were erased by the historical projection. -/
noncomputable def victorsBias (fsys : FeedbackMemeSystem) : ℕ :=
  (fsys.path.map (fun s => (fsys.failedAttempts s).length)).sum

/-
A system with zero bias has no hidden failures.
-/
theorem zero_bias_no_hidden_failures (fsys : FeedbackMemeSystem)
    (h : victorsBias fsys = 0) :
    ∀ s ∈ fsys.path, fsys.failedAttempts s = [] := by
  unfold victorsBias at h;
  rw [ List.sum_eq_zero_iff ] at h;
  intro s hs; specialize h ( List.length ( fsys.failedAttempts s ) ) ( List.mem_map.mpr ⟨ s, hs, rfl ⟩ ) ; aesop;

/-
Non-zero bias implies the projection is genuinely lossy:
    at least one state had failed attempts that were erased.
-/
theorem nonzero_bias_lossy (fsys : FeedbackMemeSystem)
    (h : victorsBias fsys > 0) :
    ∃ s ∈ fsys.path, fsys.failedAttempts s ≠ [] := by
  contrapose! h;
  exact Nat.le_of_eq ( by unfold victorsBias; rw [ List.map_congr_left fun x hx => by rw [ h x hx ] ] ; simp +decide )

/-! ## §7. Concrete Example — The Fungal Historical Projection

Demonstrate the machinery on the fungal chain: construct two distinct
arcade histories that project to the same boardroom record. -/

/-- A fungal arcade system with no failures (clean history). -/
def fungalArcadeClean : FeedbackMemeSystem where
  State := Bool
  step := fun b => some (!b)
  invariant := fun _ => True
  path := [true, false]
  pathNonempty := by simp
  pathValid := by
    intro ⟨i, hi⟩
    simp only [List.length_cons, List.length_nil] at hi
    have : i = 0 := by omega
    subst this; simp
  invHeld := by simp
  failedAttempts := fun _ => []
  failedValid := by simp

/-- A fungal arcade system with failures (messy history).
    Same successful path, but with failed attempts recorded. -/
def fungalArcadeMessy : FeedbackMemeSystem where
  State := Bool
  step := fun b => some (!b)
  invariant := fun _ => True
  path := [true, false]
  pathNonempty := by simp
  pathValid := by
    intro ⟨i, hi⟩
    simp only [List.length_cons, List.length_nil] at hi
    have : i = 0 := by omega
    subst this; simp
  invHeld := by simp
  failedAttempts := fun b => if b then [true] else []
  failedValid := by
    intro s hs t ht
    simp only [List.mem_cons, List.mem_nil_iff, or_false] at hs
    rcases hs with rfl | rfl
    · simp only [ite_true, List.mem_singleton] at ht; simp [ht]
    · simp at ht

/-
The clean and messy histories are genuinely different arcade states.
-/
theorem fungal_arcades_differ : fungalArcadeClean ≠ fungalArcadeMessy := by
  intro h;
  injection h;
  rename_i h; have := congr_fun h true; simp +decide at this;

/-
But they project to the same boardroom record.
-/
theorem fungal_same_boardroom :
    HistoricalProjection fungalArcadeClean =
    HistoricalProjection fungalArcadeMessy := by
  unfold HistoricalProjection; aesop;

/-
The clean history has zero victor's bias.
-/
theorem fungal_clean_zero_bias : victorsBias fungalArcadeClean = 0 := by
  exact rfl

/-
The messy history has non-zero victor's bias.
-/
theorem fungal_messy_nonzero_bias : victorsBias fungalArcadeMessy > 0 := by
  decide +revert

/-! ## §8. The Information-Loss Hierarchy

The theorems proved above form a chain:

    Hidden Attempts
          ↓
    Victor's Bias
          ↓
    Historical Projection
          ↓
    Non-Invertibility
          ↓
    Irrecoverable History

We now close the remaining links. -/

/-
The biconditional: victor's bias is zero iff there are no hidden failures
    anywhere along the path. This is the complete characterization of
    "lossless" projection.
-/
theorem victorsBias_zero_iff (fsys : FeedbackMemeSystem) :
    victorsBias fsys = 0 ↔ ∀ s ∈ fsys.path, fsys.failedAttempts s = [] := by
  constructor;
  · exact?;
  · exact fun h => List.sum_eq_zero fun x hx => by obtain ⟨ s, hs, rfl ⟩ := List.mem_map.mp hx; simp +decide [ h s hs ] ;

/- The original statement below is false: if sys.State = Unit and step = some,
   then failedValid forces failedAttempts to be empty for all states, so there
   is only one FeedbackMemeSystem projecting to sys. The corrected version adds
   the hypothesis that some state on the path has a rejectable candidate. -/
/- theorem every_boardroom_has_hidden_alternative (sys : MemeSystem) :
    ∃ A B : FeedbackMemeSystem,
      A ≠ B ∧
      HistoricalProjection A = sys ∧
      HistoricalProjection B = sys := by
  sorry -/

open Classical in
/-- Corrected version: if some state on the path has a candidate that the step
    function rejects (i.e., the system could have failed there), then there
    exist two distinct arcade histories projecting to the same boardroom record. -/
theorem every_boardroom_has_hidden_alternative
    (sys : MemeSystem)
    (h_rejectable : ∃ s ∈ sys.path, ∃ t : sys.State, sys.step s ≠ some t) :
    ∃ A B : FeedbackMemeSystem,
      A ≠ B ∧
      HistoricalProjection A = sys ∧
      HistoricalProjection B = sys := by
  obtain ⟨s₀, hs₀, t₀, ht₀⟩ := h_rejectable
  refine ⟨
    ⟨sys.State, sys.step, sys.invariant, sys.path, sys.pathNonempty, sys.pathValid,
     sys.invHeld, fun _ => [], by simp⟩,
    ⟨sys.State, sys.step, sys.invariant, sys.path, sys.pathNonempty, sys.pathValid,
     sys.invHeld, fun x => if x = s₀ then [t₀] else [],
     fun s hs t ht => by
       simp only at ht; split at ht
       · simp at ht; subst ht; rename_i h; subst h; exact ht₀
       · simp at ht⟩,
    ?_, rfl, rfl⟩
  intro h
  injection h with h1 h2 h3 h4 h5
  have := congr_fun h5 s₀
  simp at this

/-- A parametric family of arcade systems indexed by the number of
    hidden failures. All project to the same boardroom record, but
    each has a different victor's bias.

    This demonstrates that the projection collapses an entire
    *continuum* of arcade histories, not just two. -/
def fungalArcadeFamily (n : ℕ) : FeedbackMemeSystem where
  State := Bool
  step := fun b => some (!b)
  invariant := fun _ => True
  path := [true, false]
  pathNonempty := by simp
  pathValid := by
    intro ⟨i, hi⟩
    simp only [List.length_cons, List.length_nil] at hi
    have : i = 0 := by omega
    subst this; simp
  invHeld := by simp
  failedAttempts := fun b => if b then List.replicate n true else []
  failedValid := by
    intro s hs t ht
    simp only [List.mem_cons, List.mem_nil_iff, or_false] at hs
    rcases hs with rfl | rfl
    · simp only [ite_true] at ht
      rw [List.mem_replicate] at ht
      simp [ht.2]
    · simp at ht

/-
Every member of the parametric family projects to the same
    boardroom record. The projection cannot see the hidden failures.
-/
theorem fungalFamily_same_boardroom (n m : ℕ) :
    HistoricalProjection (fungalArcadeFamily n) =
    HistoricalProjection (fungalArcadeFamily m) := by
  exact?

/-
The victor's bias of the n-th family member is exactly n.
    More hidden failures = higher bias.
-/
theorem fungalFamily_bias (n : ℕ) :
    victorsBias (fungalArcadeFamily n) = n := by
  unfold victorsBias; simp +decide [ fungalArcadeFamily ] ;

/-
Different family members with different bias are genuinely distinct
    arcade histories. The projection collapses all of them.
-/
theorem fungalFamily_distinct (n m : ℕ) (h : n ≠ m) :
    fungalArcadeFamily n ≠ fungalArcadeFamily m := by
  contrapose! h;
  injection h;
  rename_i h; have := congr_fun h true; aesop;

/-
The full information-loss chain: non-zero bias implies there exist
    at least two distinct arcade histories with the same boardroom
    projection, one of which is the current system.
-/
theorem bias_witnesses_lossiness (fsys : FeedbackMemeSystem)
    (h : victorsBias fsys > 0) :
    ∃ other : FeedbackMemeSystem,
      other ≠ fsys ∧
      HistoricalProjection other = HistoricalProjection fsys := by
  obtain ⟨s, hs⟩ : ∃ s ∈ fsys.path, fsys.failedAttempts s ≠ [] := by
    exact?;
  refine' ⟨ ⟨ fsys.State, fsys.step, fsys.invariant, fsys.path, fsys.pathNonempty, fsys.pathValid, fsys.invHeld, fun _ => [], _ ⟩, _, _ ⟩ <;> simp_all +decide [ HistoricalProjection ];
  · grind;
  · cases fsys ; aesop

/-! ## §9. Summary — The Epistemic Sieve

### What we have formalized

1. **BoundaryLoss**: a typed witness of forgotten information
2. **HistoricalProjection**: the honest name for the forgetful functor
3. **same_boardroom_different_arcades**: multiple distinct histories
   can produce the same official record
4. **historical_projection_noninvertible**: the projection cannot be undone
5. **victorsBias**: a computable measure of how much was erased
6. **Concrete examples**: clean vs messy fungal histories that produce
   identical boardroom records

### The deeper point

By making the forgetful functors explicit and non-invertible, we have
stopped pretending that agency is symmetric or that "truth" flows equally
in both directions. Every successful loop is built on irreversible
information privilege.

The `BoundaryLoss` witness turns the propaganda mechanism into an
observable object. The boardroom can acknowledge that something was
erased without knowing what. This is the mathematical formalization of:

> "We know something was forgotten, but we cannot know what."

This is regime realism. -/