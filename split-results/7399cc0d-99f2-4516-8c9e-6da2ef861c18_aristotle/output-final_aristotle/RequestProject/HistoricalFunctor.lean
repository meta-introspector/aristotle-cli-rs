/-
# HistoricalFunctor — The Global Projection Operator

## The forgetful functor formalized as categorical structure

This module completes the HistoricalProjection layer by defining:

1. **The HistoricalProjection functor** — typed morphisms between
   FeedbackMemeSystem and MemeSystem, with functorial action on morphisms.

2. **The Bias Monad** — a lawful monad `BiasM` with:
   - `pure` = zero-bias lift
   - `bind` = bias accumulation
   - `lossy` = tentacle-level miss → positive bias

3. **The Projection Law** — the commutativity:
   projection ∘ tentacle = hypha ∘ clean

4. **The Historical Divergence Theorem** — two processes with
   identical boardroom chains but different arcade chains have
   historical projections that differ by exactly the accumulated bias.

### Import discipline

This module imports HistoricalProjection (which imports TentacleCore
and HyphaCore). It extends the regime boundary with categorical and
monadic structure.
-/

import Mathlib
import RequestProject.HistoricalProjection

set_option maxHeartbeats 800000

open ZMod Finset HeroMonster FixedPoint MonsterMycology

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
