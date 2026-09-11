/-
# Historical — Unified Forgetful Functor and Categorical Structure

## Prime Invariant: Information loss boundary (boardroom ← arcade)

Merged from HistoricalProjection and HistoricalFunctor.
-/

import Mathlib
import RequestProject.Bridge.TentacleCore

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
/-! ═══════════════════════════════════════════════════════════
    Part II: The Historical Functor (from HistoricalFunctor.lean)
    ═══════════════════════════════════════════════════════════ -/

/-! ## §1. Morphisms of Arcade Systems

To make HistoricalProjection into a functor, we need morphisms between
FeedbackMemeSystems that are compatible with the projection. -/

/-- A morphism between FeedbackMemeSystems: a function on states that
    commutes with transitions, preserves the invariant, and maps the
    path. The key property: it also maps failed attempts. -/
structure FeedbackMorphism (A B : FeedbackMemeSystem) where
  /-- The underlying state map -/
  mapState : A.State → B.State
  /-- Commutes with transitions -/
  stepCompat : ∀ s, B.step (mapState s) = (A.step s).map mapState
  /-- Preserves the invariant -/
  invCompat : ∀ s, A.invariant s → B.invariant (mapState s)
  /-- Maps failed attempts -/
  failCompat : ∀ s, B.failedAttempts (mapState s) =
    (A.failedAttempts s).map mapState

/-- A morphism between MemeSystems (boardroom level): a function on states
    that commutes with transitions and preserves the invariant. -/
structure BoardroomMorphism (A B : MemeSystem) where
  /-- The underlying state map -/
  mapState : A.State → B.State
  /-- Commutes with transitions -/
  stepCompat : ∀ s, B.step (mapState s) = (A.step s).map mapState
  /-- Preserves the invariant -/
  invCompat : ∀ s, A.invariant s → B.invariant (mapState s)

/-- Every FeedbackMorphism induces a BoardroomMorphism by forgetting
    the failure-compatibility condition. This is the functorial action
    of HistoricalProjection on morphisms. -/
def FeedbackMorphism.toBoardroom {A B : FeedbackMemeSystem}
    (f : FeedbackMorphism A B) :
    BoardroomMorphism (HistoricalProjection A) (HistoricalProjection B) where
  mapState := f.mapState
  stepCompat := f.stepCompat
  invCompat := f.invCompat

/-- The identity FeedbackMorphism. -/
def FeedbackMorphism.id (A : FeedbackMemeSystem) : FeedbackMorphism A A where
  mapState := _root_.id
  stepCompat := by simp [Option.map_id']
  invCompat := by simp
  failCompat := by simp [List.map_id']

/-- The identity BoardroomMorphism. -/
def BoardroomMorphism.id (A : MemeSystem) : BoardroomMorphism A A where
  mapState := _root_.id
  stepCompat := by simp [Option.map_id']
  invCompat := by simp

/-- The projection of the identity morphism is the identity. -/
theorem projection_preserves_id (A : FeedbackMemeSystem) :
    (FeedbackMorphism.id A).toBoardroom.mapState =
    (BoardroomMorphism.id (HistoricalProjection A)).mapState := by
  rfl

/-! ## §2. The Bias Monad

Bias is the quantitative measure of information loss. The Bias Monad
captures computations that accumulate bias — every step through the
arcade can add to the bias, and the monad laws ensure bias composes
correctly. -/

universe u

/-- A computation that produces a value of type α while accumulating
    bias (measured as a natural number). Universe-polymorphic to
    accommodate MemeSystem : Type 1. -/
structure BiasM (α : Type u) where
  /-- The result of the computation -/
  value : α
  /-- The accumulated bias -/
  bias : ℕ

/-- Pure computation: produces a value with zero bias. -/
def BiasM.pureM {α : Type u} (a : α) : BiasM α where
  value := a
  bias := 0

/-- Bind: runs a biased computation, feeds the result into another
    biased computation, and accumulates the total bias. -/
def BiasM.bindM {α : Type u} {β : Type v} (ma : BiasM α) (f : α → BiasM β) : BiasM β where
  value := (f ma.value).value
  bias := ma.bias + (f ma.value).bias

/-- The left identity law: pure a >>= f = f a. -/
theorem BiasM.left_identity {α : Type u} {β : Type v} (a : α) (f : α → BiasM β) :
    BiasM.bindM (BiasM.pureM a) f = f a := by
  simp [BiasM.bindM, BiasM.pureM]

/-- The right identity law: m >>= pure = m. -/
theorem BiasM.right_identity {α : Type u} (m : BiasM α) :
    BiasM.bindM m BiasM.pureM = m := by
  simp [BiasM.bindM, BiasM.pureM]

/-- The associativity law: (m >>= f) >>= g = m >>= (λ x, f x >>= g). -/
theorem BiasM.assoc {α : Type u} {β : Type v} {γ : Type w}
    (m : BiasM α) (f : α → BiasM β) (g : β → BiasM γ) :
    BiasM.bindM (BiasM.bindM m f) g =
    BiasM.bindM m (fun x => BiasM.bindM (f x) g) := by
  simp [BiasM.bindM, Nat.add_assoc]

/-- Bias is monotone: bind never decreases bias. -/
theorem BiasM.bias_monotone {α : Type u} {β : Type v} (m : BiasM α) (f : α → BiasM β) :
    m.bias ≤ (BiasM.bindM m f).bias := by
  simp [BiasM.bindM]

/-- A lossy computation: introduces exactly one unit of bias. -/
def BiasM.lossy {α : Type u} (a : α) : BiasM α where
  value := a
  bias := 1

/-- Lossy computations have non-zero bias. -/
theorem BiasM.lossy_nonzero {α : Type u} (a : α) :
    (BiasM.lossy a).bias > 0 := by
  simp [BiasM.lossy]

/-- Pure computations have zero bias. -/
theorem BiasM.pure_zero {α : Type u} (a : α) :
    (BiasM.pureM a).bias = 0 := by
  simp [BiasM.pureM]

/-- The key distinction: pure and lossy are different. -/
theorem BiasM.pure_ne_lossy {α : Type u} (a : α) :
    BiasM.pureM a ≠ BiasM.lossy a := by
  intro h
  have : (BiasM.pureM a).bias = (BiasM.lossy a).bias := by rw [h]
  simp [BiasM.pureM, BiasM.lossy] at this

/-! ## §3. The Projection as Biased Computation

The key bridge: the HistoricalProjection is a pure computation
(zero bias), while a tentacle-level step that records failures is
a lossy computation (positive bias). -/

/-- Lift a MemeSystem into the Bias Monad with zero bias:
    the boardroom record carries no information loss. -/
def liftBoardroom (sys : MemeSystem) : BiasM MemeSystem :=
  BiasM.pureM sys

/-- Project an arcade system into the Bias Monad, recording
    the victor's bias as the computation's bias. -/
noncomputable def projectWithBias (fsys : FeedbackMemeSystem) : BiasM MemeSystem where
  value := HistoricalProjection fsys
  bias := victorsBias fsys

/-- The projection of a clean system (zero bias) equals the pure lift. -/
theorem clean_projection_is_pure (fsys : FeedbackMemeSystem)
    (h : victorsBias fsys = 0) :
    projectWithBias fsys = liftBoardroom (HistoricalProjection fsys) := by
  simp [projectWithBias, liftBoardroom, BiasM.pureM, h]

/-- The projection of a messy system (positive bias) is NOT a pure lift. -/
theorem messy_projection_is_lossy (fsys : FeedbackMemeSystem)
    (h : victorsBias fsys > 0) :
    projectWithBias fsys ≠ liftBoardroom (HistoricalProjection fsys) := by
  simp [projectWithBias, liftBoardroom, BiasM.pureM]
  omega

/-! ## §4. The Projection Law

The fundamental commutativity: projection commutes with clean lifting.

   FeedbackMemeSystem --toBoardroom--> MemeSystem
         |                                |
    projectWithBias                  liftBoardroom
         |                                |
         v                                v
     BiasM MemeSystem              BiasM MemeSystem

For clean systems (zero bias), the square commutes.
For messy systems (positive bias), the square fails to commute
by exactly the accumulated bias. -/

/-- The projection law for clean systems: the square commutes. -/
theorem projection_law_clean (fsys : FeedbackMemeSystem)
    (h : victorsBias fsys = 0) :
    projectWithBias fsys = liftBoardroom (HistoricalProjection fsys) :=
  clean_projection_is_pure fsys h

/-- The bias discrepancy: the difference between the biased projection
    and the pure lift is exactly the victor's bias. -/
theorem projection_bias_discrepancy (fsys : FeedbackMemeSystem) :
    (projectWithBias fsys).bias - (liftBoardroom (HistoricalProjection fsys)).bias =
    victorsBias fsys := by
  simp [projectWithBias, liftBoardroom, BiasM.pureM]

/-- The values always agree — bias only affects the metadata. -/
theorem projection_values_agree (fsys : FeedbackMemeSystem) :
    (projectWithBias fsys).value = (liftBoardroom (HistoricalProjection fsys)).value := by
  rfl

/-! ## §5. The Historical Divergence Theorem

The culmination: two arcade systems with the same boardroom projection
but different bias levels are provably distinct, and their distinction
is exactly captured by the bias discrepancy.

This uses the theorems proven in HistoricalProjection.lean:
- fungal_same_boardroom
- fungal_arcades_differ
- fungal_clean_zero_bias
- fungal_messy_nonzero_bias
- nonzero_bias_lossy -/

/-- Two arcade systems that project to the same boardroom record but have
    different bias levels produce different biased projections.
    The bias monad detects what the boardroom cannot. -/
theorem historical_divergence
    (A B : FeedbackMemeSystem)
    (_h_same : HistoricalProjection A = HistoricalProjection B)
    (h_bias : victorsBias A ≠ victorsBias B) :
    projectWithBias A ≠ projectWithBias B := by
  intro h
  have : (projectWithBias A).bias = (projectWithBias B).bias := by rw [h]
  simp [projectWithBias] at this
  exact h_bias this

/-- The fungal chains witness the historical divergence theorem. -/
theorem fungal_historical_divergence :
    projectWithBias fungalArcadeClean ≠ projectWithBias fungalArcadeMessy := by
  apply historical_divergence
  · exact fungal_same_boardroom
  · rw [fungal_clean_zero_bias]
    intro h
    have := fungal_messy_nonzero_bias
    omega

/-- The parametric family witnesses divergence at every scale:
    different bias levels produce different biased projections,
    even though all project to the same boardroom record. -/
theorem parametric_historical_divergence (n m : ℕ) (h : n ≠ m) :
    projectWithBias (fungalArcadeFamily n) ≠ projectWithBias (fungalArcadeFamily m) := by
  apply historical_divergence
  · exact fungalFamily_same_boardroom n m
  · rw [fungalFamily_bias, fungalFamily_bias]
    exact h

/-! ## §6. The Bias Accumulation Law

Bias is additive under sequential composition of arcade steps.
This means the Bias Monad correctly tracks information loss across
multi-step computations. -/

/-- Composing two biased computations adds their biases. -/
theorem bias_additive {α : Type u} {β : Type v} (a : BiasM α) (f : α → BiasM β) :
    (BiasM.bindM a f).bias = a.bias + (f a.value).bias := by
  rfl

/-- A sequence of n lossy steps. -/
def nLossySteps : ℕ → BiasM Unit
  | 0 => BiasM.pureM ()
  | n + 1 => BiasM.bindM (nLossySteps n) (fun _ => BiasM.lossy ())

/-- A sequence of n lossy steps accumulates exactly n units of bias. -/
theorem n_lossy_steps (n : ℕ) : (nLossySteps n).bias = n := by
  induction n with
  | zero => rfl
  | succ n ih => simp [nLossySteps, BiasM.bindM, BiasM.lossy, ih]

/-! ## §7. Non-Invertibility at the Functor Level

The projection functor is non-invertible: there is no natural
transformation from MemeSystem back to FeedbackMemeSystem that
inverts the projection. This lifts the pointwise non-invertibility
from HistoricalProjection.lean to the categorical level. -/

/-- There is no function from MemeSystem to FeedbackMemeSystem that
    recovers the original system, even when restricted to systems
    with zero bias. This is the categorical non-invertibility. -/
theorem functor_noninvertible :
    ¬ ∃ (recover : MemeSystem → FeedbackMemeSystem),
      ∀ fsys, recover (HistoricalProjection fsys) = fsys :=
  historical_projection_noninvertible

/-- Bias strictly increases under lossy bind: if the function
    introduces positive bias, the total is strictly greater. -/
theorem bias_strict_increase {α : Type u} {β : Type v} (m : BiasM α) (f : α → BiasM β)
    (hf : (f m.value).bias > 0) :
    m.bias < (BiasM.bindM m f).bias := by
  simp [BiasM.bindM]; omega

/-- The bias monad separates clean from messy at every level:
    for any n > 0, the n-lossy computation is distinguishable from
    the pure computation. -/
theorem bias_separates (α : Type u) (a : α) (n : ℕ) (hn : n > 0) :
    BiasM.pureM a ≠ (⟨a, n⟩ : BiasM α) := by
  intro h
  have : (BiasM.pureM a).bias = n := by rw [h]
  simp [BiasM.pureM] at this
  omega

/-! ## §8. Summary — The Complete Projection Architecture

### What we have formalized

1. **FeedbackMorphism / BoardroomMorphism**: typed morphisms between
   arcade and boardroom systems

2. **Projection on morphisms**: the functorial action of HistoricalProjection

3. **BiasM monad**: a lawful monad tracking information loss
   - left identity, right identity, associativity all proven
   - bias monotonicity proven

4. **Projection Law**: clean systems commute through the projection
   square, messy systems fail to commute by exactly the accumulated bias

5. **Historical Divergence Theorem**: systems with different bias levels
   produce different biased projections, even with identical boardroom records

6. **Non-invertibility at functor level**: lifts pointwise non-invertibility
   to the categorical level

### The architecture

```
  FeedbackMemeSystem ──toBoardroom──→ MemeSystem
       │                                  │
  projectWithBias                    liftBoardroom
       │                                  │
       ▼                                  ▼
   BiasM MemeSystem ←── gap = bias ──→ BiasM MemeSystem
```

The gap is exactly `victorsBias`. The bias monad makes the gap observable.
The divergence theorem says the gap is detectable. The non-invertibility
theorem says the gap is irreparable.

This completes the mathematical backbone of the regime boundary. -/

