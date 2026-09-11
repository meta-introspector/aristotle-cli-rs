/-
# TentacleCore — The Arcade Layer (Post-Feedback Coalgebra)

## Regime: Tentacle (Feedback Coalgebra)

This is the second of three layers. Failure is a typed object here — not
absence (`none`) but a first-class `FeedbackSignal` with structure.
Both success and failure are recorded. This is the game layer: the arcade.

### Import discipline

TentacleCore imports HyphaCore. HyphaCore does NOT import TentacleCore.
This asymmetry IS the regime separation — enforced at the module level,
not by axioms. No hypha-level theorem can accidentally depend on feedback.

### The discontinuity functor

The forgetful functors (toBoardroom, forget, successfulSteps) are defined
here because they are Arcade → Boardroom projections. They are the only
way to cross the regime boundary, and they are provably non-invertible:
you cannot reconstruct failure information from success-only records.

### Contents

- FeedbackSignal (the counit: what the system observes on failure)
- AttemptedStep (success OR failure, both first-class)
- TentacleSearch (full arcade search record)
- FeedbackMemeSystem (arcade-level meme system)
- FeedbackVine (arcade-level vine with miss tracking)
- Substrate / ColonizationAttempt / ColonizationResult (game world)
- RegimeBoundary (the explicit discontinuity functor)
- Proof of non-invertibility
-/

import Mathlib
import RequestProject.Bridge.HyphaCore

set_option maxHeartbeats 800000

open ZMod Finset HeroMonster FixedPoint MonsterMycology

/-! ## §1. FeedbackSignal — The Counit

This is the new capability that enters at tentacle-level.
In the game: "this tile rejected your hypha, here's why."
In the theory: the partial coalgebra acquires a counit.
This object does not exist in HyphaCore. -/

/-- A feedback signal: what the system observes when a step fails.
    This is the counit — the new capability that enters at tentacle-level. -/
structure FeedbackSignal where
  /-- What was attempted -/
  attemptDescription : String
  /-- Why it failed -/
  failureReason : String
  /-- How much work was wasted -/
  wastedWork : ℕ
  deriving Repr

/-! ## §2. AttemptedStep — Success and Failure as Typed Objects -/

/-- An attempted propagation step: records both success and failure.
    **Tentacle-level**: the system can observe its own failures.
    In the game: each tile colonization attempt is recorded. -/
inductive AttemptedStep {S T : Type} (mS : Metameme S) (mT : Metameme T) where
  /-- The activation fired and the meme landed -/
  | landed (step : PartialPropStep mS mT)
  /-- The activation was attempted but no landing site was found.
      The error signal: "I reached but there was nothing to grip." -/
  | missed (attempt : Activation) (feedback : FeedbackSignal)

/-- Whether an attempted step landed. -/
def AttemptedStep.isLanded {S T : Type} {mS : Metameme S} {mT : Metameme T} :
    AttemptedStep mS mT → Bool
  | .landed _ => true
  | .missed _ _ => false

/-- Extract the activation from an attempted step (whether it landed or not). -/
def AttemptedStep.getActivation {S T : Type} {mS : Metameme S} {mT : Metameme T} :
    AttemptedStep mS mT → Activation
  | .landed step => step.activation
  | .missed act _ => act

/-- Extract the feedback from a missed step. -/
def AttemptedStep.getFeedback {S T : Type} {mS : Metameme S} {mT : Metameme T} :
    AttemptedStep mS mT → Option FeedbackSignal
  | .landed _ => none
  | .missed _ fb => some fb

/-! ## §3. TentacleSearch — The Arcade's Data Structure

A TentacleSearch records *all* attempts from a source metameme: successes
and failures. This is the full game state of a player's extruder competing
for substrate in the arcade. -/

/-- A tentacle search: the full record of an extruder's attempts to colonize
    substrate. Records both landings and misses.
    **Arcade-level**: this is what the player sees and interacts with. -/
structure TentacleSearch {S : Type} (mS : Metameme S) where
  /-- All attempted steps, in order -/
  attempts : List (Σ T : Type, Σ mT : Metameme T, AttemptedStep mS mT)
  /-- At least one attempt was made (you have to try) -/
  nonempty : attempts ≠ []

/-- How many attempts were made. -/
def TentacleSearch.numAttempts {S : Type} {mS : Metameme S}
    (ts : TentacleSearch mS) : ℕ :=
  ts.attempts.length

/-- How many attempts landed successfully. -/
noncomputable def TentacleSearch.numLanded {S : Type} {mS : Metameme S}
    (ts : TentacleSearch mS) : ℕ :=
  ts.attempts.countP (fun ⟨_, _, a⟩ => a.isLanded)

/-- How many attempts missed. -/
noncomputable def TentacleSearch.numMissed {S : Type} {mS : Metameme S}
    (ts : TentacleSearch mS) : ℕ :=
  ts.attempts.countP (fun ⟨_, _, a⟩ => !a.isLanded)

/-- Landed + missed = total attempts. -/
theorem TentacleSearch.landed_plus_missed {S : Type} {mS : Metameme S}
    (ts : TentacleSearch mS) :
    ts.numLanded + ts.numMissed = ts.numAttempts := by
  simp only [TentacleSearch.numLanded, TentacleSearch.numMissed, TentacleSearch.numAttempts]
  induction ts.attempts with
  | nil => simp
  | cons h t ih =>
    simp [List.countP_cons]
    split <;> simp_all <;> omega

/-! ## §4. The Door — Forgetful Functor (Arcade → Boardroom)

The forgetful functor projects the tentacle search down to its successful
steps only. This is the only way to cross the regime boundary.

Players in the arcade do the work. The boardroom sees only the results. -/

/-- Project a tentacle search down to its successful steps only.
    This is the door from the arcade to the boardroom. -/
noncomputable def TentacleSearch.successfulSteps {S : Type} {mS : Metameme S}
    (ts : TentacleSearch mS) :
    List (Σ T : Type, Σ mT : Metameme T, PartialPropStep mS mT) :=
  ts.attempts.filterMap fun ⟨T, mT, a⟩ =>
    match a with
    | .landed step => some ⟨T, mT, step⟩
    | .missed _ _ => none

/-- The number of successful steps is at most the total attempts. -/
theorem TentacleSearch.successful_le_total {S : Type} {mS : Metameme S}
    (ts : TentacleSearch mS) :
    ts.successfulSteps.length ≤ ts.numAttempts := by
  simp [TentacleSearch.successfulSteps, TentacleSearch.numAttempts]
  exact List.length_filterMap_le _ _

/-! ## §5. FeedbackMemeSystem — Arcade Record -/

/-- An arcade-level meme system: tracks all attempted transitions.
    Has an error signal. This is the player's full game state. -/
structure FeedbackMemeSystem where
  /-- The state space -/
  State : Type
  /-- Partial transition -/
  step : State → Option State
  /-- The selfish meme -/
  invariant : State → Prop
  /-- Successful path (same structure as boardroom) -/
  path : List State
  pathNonempty : path ≠ []
  pathValid : ∀ i : Fin (path.length - 1),
    step (path[i.val]'(by omega)) = some (path[i.val + 1]'(by omega))
  invHeld : ∀ x ∈ path, invariant x
  /-- ARCADE ADDITION: failed attempts at each successful state -/
  failedAttempts : State → List State
  /-- Failed attempts genuinely failed (the substrate rejected them) -/
  failedValid : ∀ s ∈ path, ∀ t ∈ failedAttempts s, step s ≠ some t

/-- The door: project arcade state down to boardroom record.
    Forgets all failed attempts. This is the discontinuity functor. -/
def FeedbackMemeSystem.toBoardroom (fsys : FeedbackMemeSystem) : MemeSystem where
  State := fsys.State
  step := fsys.step
  invariant := fsys.invariant
  path := fsys.path
  pathNonempty := fsys.pathNonempty
  pathValid := fsys.pathValid
  invHeld := fsys.invHeld

/-- The door preserves the invariant at initial. -/
theorem FeedbackMemeSystem.invariant_at_initial (fsys : FeedbackMemeSystem) :
    fsys.invariant (fsys.toBoardroom.initial) :=
  fsys.toBoardroom.invariant_at_initial

/-- The door preserves the invariant at terminal. -/
theorem FeedbackMemeSystem.invariant_at_terminal (fsys : FeedbackMemeSystem) :
    fsys.invariant (fsys.toBoardroom.terminal) :=
  fsys.toBoardroom.invariant_at_terminal

/-! ## §6. FeedbackVine — Arcade-Level Fiber Bundle -/

/-- A feedback-aware vine: tracks both landings and misses.
    **Tentacle-level / Arcade**: the vine can sense the empty air. -/
structure FeedbackVine (Base Fiber : Type) extends Vine Base Fiber where
  /-- Base points where the section reached but found no fiber -/
  misses : List Base
  /-- Misses genuinely missed -/
  missesValid : ∀ b ∈ misses, section_ b = none

/-- Project a FeedbackVine to a Vine (arcade → boardroom). Forgets misses. -/
def FeedbackVine.forget {B F : Type} (fv : FeedbackVine B F) : Vine B F :=
  fv.toVine

/-! ## §7. Substrate — The Game World

The substrate is the Totality lattice: ℤ/71 × ℤ/59 × ℤ/47.
Each point is a tile that can be colonized by an extruder. -/

/-- A substrate tile: a point in the Totality lattice. -/
structure SubstrateTile where
  /-- Position in the CRT torus -/
  position : Totality
  /-- Whether this tile is currently colonized -/
  colonized : Bool
  /-- The colonizer's meme signature (if colonized) -/
  colonizer : Option MonomythSignature
  deriving Repr

/-- A colonization attempt: an extruder tries to land on a tile. -/
structure ColonizationAttempt where
  /-- The tile being targeted -/
  target : SubstrateTile
  /-- The meme signature of the extruder attempting colonization -/
  attackerSignature : MonomythSignature
  /-- The activation energy committed -/
  activation : Activation
  deriving Repr

/-- The result of a colonization attempt: 4 outcomes.
    - colonized: success
    - resistedBy: tile occupied by fitter meme (feedback: who beat you)
    - insufficientEnergy: not enough work (feedback: how much was needed)
    - incompatible: tile rejects this meme type (feedback: why) -/
inductive ColonizationResult where
  /-- Successfully colonized the tile -/
  | colonized (tile : SubstrateTile) (proof : tile.colonized = true)
  /-- Failed: tile already occupied by a fitter meme -/
  | resistedBy (incumbent : MonomythSignature) (feedback : FeedbackSignal)
  /-- Failed: insufficient activation energy -/
  | insufficientEnergy (required : ℕ) (provided : ℕ) (feedback : FeedbackSignal)
  /-- Failed: tile is incompatible with this meme type -/
  | incompatible (feedback : FeedbackSignal)

/-- A colonization attempt that succeeded produces a colonized tile. -/
def ColonizationResult.isSuccess : ColonizationResult → Bool
  | .colonized _ _ => true
  | _ => false

/-- A colonization attempt that failed produces a feedback signal. -/
def ColonizationResult.getFeedback : ColonizationResult → Option FeedbackSignal
  | .colonized _ _ => none
  | .resistedBy _ fb => some fb
  | .insufficientEnergy _ _ fb => some fb
  | .incompatible fb => some fb

/-! ## §8. RegimeBoundary — The Explicit Discontinuity Functor

This is the key structural object that replaces axioms like `unique_discontinuity`.
Instead of asserting "there is exactly one discontinuity" as a theorem about a list,
we define the discontinuity as a **typed functor** between two non-isomorphic categories.

The functor is:
- `lift`: HyphaState → TentacleState (embed boardroom data into arcade)
- `project`: TentacleState → HyphaState (forget failure information)
- `project ∘ lift = id` (roundtrip through the door preserves boardroom data)
- `lift ∘ project ≠ id` (the functor is NOT invertible: failure info is lost)

This enforces:
- No accidental backward reasoning (can't infer arcade state from boardroom)
- No feedback leakage into hypha proofs (hypha module doesn't import this)
- Explicit discontinuity instead of axiomatic mixing -/

/-- The regime boundary: a functorial bridge between hypha (boardroom) and
    tentacle (arcade) computation regimes.

    This is the formalization of the Hypha→Tentacle discontinuity as a
    change in the morphism space, not an axiom about a list of arrows. -/
structure RegimeBoundary (HyphaState : Type*) (TentacleState : Type*) where
  /-- Lift boardroom data into the arcade (embedding) -/
  lift : HyphaState → TentacleState
  /-- Project arcade data down to the boardroom (forgetful functor) -/
  project : TentacleState → HyphaState
  /-- The projection is a left inverse of the lift: boardroom data roundtrips -/
  section_retract : ∀ h, project (lift h) = h
  /-- The lift is NOT a left inverse of the projection: information is lost -/
  not_invertible : ∃ t, lift (project t) ≠ t

/-
The canonical regime boundary: MemeSystem ↔ FeedbackMemeSystem.

    The lift embeds a boardroom record as an arcade record with no failures.
    The project forgets failures. The roundtrip preserves boardroom data.
    But the arcade has strictly more information (failed attempts).
-/
noncomputable def canonicalRegimeBoundary :
    RegimeBoundary MemeSystem FeedbackMemeSystem where
  lift := fun sys => {
    State := sys.State
    step := sys.step
    invariant := sys.invariant
    path := sys.path
    pathNonempty := sys.pathNonempty
    pathValid := sys.pathValid
    invHeld := sys.invHeld
    failedAttempts := fun _ => []
    failedValid := by simp
  }
  project := fun fsys => fsys.toBoardroom
  section_retract := by intro sys; rfl
  not_invertible := by
    -- We construct a FeedbackMemeSystem with non-empty failedAttempts.
    -- After lift ∘ project, the failedAttempts become empty, so it differs.
    fconstructor;
    use Bool;
    exact fun b => some ( !b );
    exact fun _ => True;
    exact [ Bool.true ];
    all_goals norm_num;
    grind;
    exact fun _ => [ Bool.true ];
    grind +revert;
    exact fun _ _ _ _ => fun h => by have := congr_fun h Bool.true; simp +decide at this;

/-- The regime boundary is strictly information-losing:
    the forgetful functor cannot be inverted. -/
theorem regime_boundary_strict (rb : RegimeBoundary H T) :
    ¬ (∀ t, rb.lift (rb.project t) = t) := by
  intro h
  obtain ⟨t, ht⟩ := rb.not_invertible
  exact ht (h t)