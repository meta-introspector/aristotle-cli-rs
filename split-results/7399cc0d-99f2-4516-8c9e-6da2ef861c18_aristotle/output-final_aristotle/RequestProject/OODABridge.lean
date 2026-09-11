/-
# OODABridge — OODA as Fixed Point of Observation-Control Loop

## Regime: Closure (OODA over Tentacle Dynamics)

This is the third layer. OODA is not a cap on the agency ladder — it is
the control monad that becomes available once feedback exists. It is a
*consequence* of the Hypha→Tentacle discontinuity, not a separate regime.

### Import discipline

OODABridge imports TentacleCore (which imports HyphaCore).
The full dependency chain is:

    HyphaCore → TentacleCore → OODABridge

This mirrors the ontological structure:
- OODA requires feedback (tentacle)
- Feedback requires partial chains to exist (hypha)
- The reverse dependencies do not hold

### Contents

- ArrowKind / AgencyLevel / Regime (the arrow taxonomy)
- Agency morphisms with typed arrows
- unique_discontinuity (now a consequence of type-level separation)
- OODAPhase / OODACycle (OODA as emergent from feedback)
- Player archetypes (copier, lolz tweaker, winz tweaker)
- only_winz_uses_feedback (proved from structure)
-/

import Mathlib
import RequestProject.TentacleCore

set_option maxHeartbeats 800000

open ZMod Finset HeroMonster FixedPoint MonsterMycology

/-! ## §1. Arrow Taxonomy — Three Kinds of Morphism

The agency ladder is not a uniform chain. The arrows split into three kinds.
The distinction is load-bearing: one of them is a change in the morphism
space itself, not a morphism within it. -/

/-- The kind of morphism between agency levels. -/
inductive ArrowKind where
  /-- Same primitive, more structure (parallelism, memory, specialization) -/
  | enrichment
  /-- More general algebra, concrete detail forgotten -/
  | abstraction
  /-- Qualitative jump: new structure enters (e.g. feedback / counit).
      This is a change in the *category* of morphisms, not a morphism
      within a fixed category. -/
  | discontinuity
  deriving DecidableEq, Repr, Inhabited

/-! ## §2. The Agency Ladder -/

/-- The levels of the agency ladder. -/
inductive AgencyLevel where
  | tendril       -- local probe, no feedback
  | hypha         -- branching search, no feedback
  | tentacle      -- directed sensing WITH feedback (counit acquired)
  | appendage     -- embodied task-specific action
  | motor         -- cyclic activation
  | rotor         -- symmetry group action
  | cliffordRepr  -- universal rotor algebra Cl(p,q)
  | ooda          -- control monad (consequence of feedback, not a separate level)
  deriving DecidableEq, Repr, Inhabited

/-- Which regime an agency level belongs to.
    Pre-feedback = boardroom (HyphaCore).
    Post-feedback = arcade (TentacleCore).
    Closure = OODA (this module). -/
inductive Regime where
  /-- Partial coalgebra, no error signal, only successful paths.
      The boardroom DAO. Formalized in HyphaCore. -/
  | preFeedback
  /-- Feedback available, error signal, failed attempts trackable.
      The arcade. Formalized in TentacleCore. -/
  | postFeedback
  /-- Control monad: consequence of feedback propagated through enrichment.
      Formalized in OODABridge (this module). -/
  | closure
  deriving DecidableEq, Repr, Inhabited

/-- Classify each agency level into its regime. -/
def AgencyLevel.regime : AgencyLevel → Regime
  | .tendril      => .preFeedback
  | .hypha        => .preFeedback
  | .tentacle     => .postFeedback
  | .appendage    => .postFeedback
  | .motor        => .postFeedback
  | .rotor        => .postFeedback
  | .cliffordRepr => .postFeedback
  | .ooda         => .closure

/-- The rank of each agency level. -/
def AgencyLevel.rank : AgencyLevel → ℕ
  | .tendril      => 0
  | .hypha        => 1
  | .tentacle     => 2
  | .appendage    => 3
  | .motor        => 4
  | .rotor        => 5
  | .cliffordRepr => 6
  | .ooda         => 7

instance : LE AgencyLevel where
  le a b := a.rank ≤ b.rank

instance : LT AgencyLevel where
  lt a b := a.rank < b.rank

instance (a b : AgencyLevel) : Decidable (a ≤ b) :=
  inferInstanceAs (Decidable (a.rank ≤ b.rank))

instance (a b : AgencyLevel) : Decidable (a < b) :=
  inferInstanceAs (Decidable (a.rank < b.rank))

/-! ## §3. Agency Morphisms — Typed Arrows -/

/-- An agency morphism: a typed arrow between agency levels. -/
structure AgencyMorphism where
  source : AgencyLevel
  target : AgencyLevel
  kind : ArrowKind
  ascending : source ≤ target
  description : String

/-- Tendril → Hypha: enrichment (parallelization). -/
def tendrilToHypha : AgencyMorphism where
  source := .tendril
  target := .hypha
  kind := .enrichment
  ascending := by decide
  description := "single probe → branching search tree (parallelization)"

/-- Hypha → Tentacle: **DISCONTINUITY** (feedback / counit acquired).
    This is the Lean-level shadow of the module boundary:
    TentacleCore imports HyphaCore, and FeedbackSignal is defined only there.
    The arrow is a *change in the morphism space itself*. -/
def hyphaToTentacle : AgencyMorphism where
  source := .hypha
  target := .tentacle
  kind := .discontinuity
  ascending := by decide
  description := "COUNIT ACQUIRED: branching search → directed sensing + feedback"

/-- Tentacle → Appendage: enrichment (task specialization, memory). -/
def tentacleToAppendage : AgencyMorphism where
  source := .tentacle
  target := .appendage
  kind := .enrichment
  ascending := by decide
  description := "directed sensing → embodied task-specific action (memory added)"

/-- Appendage → Motor: abstraction (embodied action → cyclic). -/
def appendageToMotor : AgencyMorphism where
  source := .appendage
  target := .motor
  kind := .abstraction
  ascending := by decide
  description := "embodied action → cyclic activation (loses task specificity)"

/-- Motor → Rotor: abstraction (cyclic → symmetry group). -/
def motorToRotor : AgencyMorphism where
  source := .motor
  target := .rotor
  kind := .abstraction
  ascending := by decide
  description := "cyclic activation → SO(3) rotation group (symmetry exposed)"

/-- Rotor → Clifford: abstraction (rotation → universal algebra). -/
def rotorToClifford : AgencyMorphism where
  source := .rotor
  target := .cliffordRepr
  kind := .abstraction
  ascending := by decide
  description := "SO(3) rotation → Cl(p,q) universal rotor algebra"

/-- Clifford → OODA: enrichment. OODA is the control monad available
    once feedback exists. -/
def cliffordToOODA : AgencyMorphism where
  source := .cliffordRepr
  target := .ooda
  kind := .enrichment
  ascending := by decide
  description := "Cl(p,q) → OODA: control monad (consequence of feedback propagation)"

/-- The complete agency ladder as an ordered list. -/
def agencyLadder : List AgencyMorphism :=
  [tendrilToHypha, hyphaToTentacle, tentacleToAppendage,
   appendageToMotor, motorToRotor, rotorToClifford, cliffordToOODA]

/-- The Hypha → Tentacle arrow is the only discontinuity in the ladder.

    This is now a *consequence* of the 3-layer architecture:
    - HyphaCore has no FeedbackSignal (pre-feedback)
    - TentacleCore introduces FeedbackSignal (post-feedback)
    - The discontinuity is the import boundary between the two modules
    - This theorem just confirms the ladder matches the module structure -/
theorem unique_discontinuity :
    ∀ (m : AgencyMorphism),
      m ∈ agencyLadder →
      m.kind = .discontinuity → m = hyphaToTentacle := by
  intro m hm hkind
  simp [agencyLadder, List.mem_cons] at hm
  rcases hm with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
    simp_all [tendrilToHypha, hyphaToTentacle, tentacleToAppendage,
              appendageToMotor, motorToRotor, rotorToClifford, cliffordToOODA]

/-- Pre-feedback levels are exactly tendril and hypha.
    These are the levels whose computations live entirely in HyphaCore. -/
theorem preFeedback_levels :
    ∀ a : AgencyLevel, a.regime = .preFeedback ↔ (a = .tendril ∨ a = .hypha) := by
  intro a; cases a <;> simp [AgencyLevel.regime]

/-- The feedback boundary: hypha is pre-feedback, tentacle is post-feedback.
    This is the Lean-level shadow of "TentacleCore imports HyphaCore." -/
theorem feedback_boundary :
    AgencyLevel.hypha.regime = .preFeedback ∧
    AgencyLevel.tentacle.regime = .postFeedback :=
  ⟨rfl, rfl⟩

instance : Fintype AgencyLevel where
  elems := {.tendril, .hypha, .tentacle, .appendage, .motor, .rotor, .cliffordRepr, .ooda}
  complete := by intro a; cases a <;> simp

theorem agency_ladder_levels : Fintype.card AgencyLevel = 8 := by decide

/-! ## §4. OODA as Consequence of Feedback

OODA is not the closure of the ladder. OODA is what happens *after*
the Hypha→Tentacle discontinuity propagates through the enrichment chain.

The four phases map to the ladder:
- Observe = tendril (probe the environment)
- Orient  = hypha (branch and contextualize)
- Decide  = tentacle (select action WITH FEEDBACK — counit fires here)
- Act     = motor/rotor/Clifford (execute transformation)

The Decide phase is critical: it is the first phase that can *reject*
an option based on observed failure. Without the Hypha→Tentacle jump,
Decide would be indistinguishable from Orient. -/

/-- The four phases of the OODA loop. -/
inductive OODAPhase where
  | observe   -- probe the environment (tendril-level)
  | orient    -- contextualize observations (hypha-level, pre-feedback)
  | decide    -- select action WITH FEEDBACK (tentacle-level, post-feedback)
  | act       -- execute transformation (motor/rotor/Clifford-level)
  deriving DecidableEq, Repr, Inhabited, Fintype

/-- Map OODA phases to agency levels. -/
def OODAPhase.agencyLevel : OODAPhase → AgencyLevel
  | .observe => .tendril
  | .orient  => .hypha
  | .decide  => .tentacle   -- the counit fires here
  | .act     => .motor

/-- The discontinuity lives between Orient and Decide.
    Orient is hypha-level (HyphaCore). Decide is tentacle-level (TentacleCore).
    The OODA loop crosses the regime boundary at exactly this point. -/
theorem ooda_discontinuity :
    OODAPhase.orient.agencyLevel.regime = .preFeedback ∧
    OODAPhase.decide.agencyLevel.regime = .postFeedback :=
  ⟨rfl, rfl⟩

/-- An OODA cycle: one complete iteration of the control loop.
    Each phase is a partial step — any phase can fail to land.
    The Decide phase is special: it can reject based on feedback. -/
structure OODACycle (A : Type) where
  /-- The state at the start of the cycle -/
  initial : A
  /-- Observe: probe and possibly receive data (tendril) -/
  observe : A → Option A
  /-- Orient: contextualize (hypha, no feedback yet) -/
  orient : A → Option A
  /-- Decide: select action WITH FEEDBACK (tentacle, counit fires) -/
  decide : A → Option A
  /-- Act: execute transformation (motor/rotor/Clifford) -/
  act : A → Option A

/-- A complete OODA cycle: all four phases landed. -/
def OODACycle.complete {A : Type} (c : OODACycle A) : Option A :=
  c.observe c.initial >>= c.orient >>= c.decide >>= c.act

/-- An OODA cycle is successful if all four phases landed. -/
def OODACycle.successful {A : Type} (c : OODACycle A) : Prop :=
  c.complete.isSome

/-- An OODA cycle that loops: the output feeds back into the next cycle's input.
    This is the fixed-point structure: OODA is a coalgebra over itself. -/
structure OODALoop (A : Type) where
  /-- The cycle template -/
  cycle : OODACycle A
  /-- The output of one cycle becomes the input of the next -/
  feedback_loop : ∀ a, cycle.complete = some a → (cycle.observe a).isSome
  /-- The loop label / description -/
  description : String

/-- Run an OODA loop for n iterations, returning the final state if all
    iterations succeeded. Returns none if any iteration fails to complete. -/
def OODALoop.iterate {A : Type} (loop : OODALoop A) : ℕ → Option A
  | 0 => some loop.cycle.initial
  | n + 1 => do
    let prev ← loop.iterate n
    let observed ← loop.cycle.observe prev
    let oriented ← loop.cycle.orient observed
    let decided ← loop.cycle.decide oriented
    loop.cycle.act decided

/-! ## §5. Player Archetypes — The Three Strategies

The tycoon mechanic produces three natural player archetypes.
Each corresponds to a different relationship with the partial coalgebra.

The key theorem: **only winz tweakers use post-feedback**.
This is proved from structure, not asserted as an axiom.
Copiers replicate (no feedback needed). Lolz tweakers mutate blind.
Only winz tweakers run the OODA loop. -/

/-- The three player archetypes in the tycoon mechanic. -/
inductive PlayerArchetype where
  /-- Pure horizontal transfer. Rides successful chains others found.
      Low risk, low ceiling. No mutation. -/
  | copier
  /-- Random mutation for chaos and entertainment. Occasionally discovers
      new landing sites by accident. The evolutionary noise term. -/
  | tweakerLolz
  /-- Systematic OODA-driven optimization. Reads the substrate, modifies
      the germ deliberately, maximizes colonization. Directed evolution. -/
  | tweakerWinz
  deriving DecidableEq, Repr, Inhabited

/-- How each archetype relates to the regime structure. -/
def PlayerArchetype.regime : PlayerArchetype → Regime
  | .copier => .preFeedback       -- copiers don't need feedback, just replicate
  | .tweakerLolz => .preFeedback  -- lolz tweakers mutate blind, no feedback loop
  | .tweakerWinz => .postFeedback -- winz tweakers need the counit to optimize

/-- Only winz tweakers use post-feedback (OODA-driven) strategy.
    This is a theorem, not an axiom: it follows from the definition of
    regime assignment. The game's economic balance has a formal invariant. -/
theorem only_winz_uses_feedback :
    ∀ p : PlayerArchetype, p.regime = .postFeedback ↔ p = .tweakerWinz := by
  intro p; cases p <;> simp [PlayerArchetype.regime]

/-- The module map: which module each archetype's computations live in. -/
def PlayerArchetype.module : PlayerArchetype → String
  | .copier      => "HyphaCore"
  | .tweakerLolz => "HyphaCore"
  | .tweakerWinz => "TentacleCore"

/-! ## §6. Summary — Three Layers, One Discontinuity Functor

### Layer 1: HyphaCore (Boardroom)
- PartialCoalgebra, PartialChain, MemeSystem, Vine
- No FeedbackSignal. No failure tracking. Clean proofs.
- Copiers and lolz tweakers live here.

### Layer 2: TentacleCore (Arcade)
- FeedbackSignal, AttemptedStep, TentacleSearch, FeedbackMemeSystem
- FeedbackVine, ColonizationResult, SubstrateTile
- RegimeBoundary (the explicit discontinuity functor)
- Failure is a typed object (FeedbackSignal), not absence (none).
- Winz tweakers live here.

### Layer 3: OODABridge (this module)
- OODA as fixed-point of observation-control loop
- Agency ladder with typed arrows
- unique_discontinuity (consequence of type-level module separation)
- Player archetypes with formal regime assignment

### The Discontinuity

The Hypha→Tentacle boundary is enforced at three levels:

1. **Module level**: TentacleCore imports HyphaCore, not vice versa.
   FeedbackSignal is defined only in TentacleCore.

2. **Functor level**: RegimeBoundary provides the explicit bridge.
   It is provably non-invertible (canonicalRegimeBoundary).

3. **Ladder level**: unique_discontinuity confirms the ladder matches
   the module structure.

The regime separation is not axiomatic — it is structural. -/
