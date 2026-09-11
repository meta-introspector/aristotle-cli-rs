/-
# PartialPropagation — Partial Coalgebra, Feedback Discontinuity, and the Arcade/Boardroom Split

## The Ontological Shift

The `LinkedPropagationChain` in FungalExtruder assumes *totality of transition*:
every step is guaranteed to produce a next state. This hidden axiom is dropped.

## Two Regimes, One Discontinuity

The agency ladder splits at the **Hypha → Tentacle** boundary.

### Pre-feedback regime (hypha layer) — formalized in HyphaCore.lean
### Post-feedback regime (tentacle layer) — formalized in TentacleCore.lean
### This file: the arrow taxonomy, agency ladder, OODA, and player archetypes

## Arcade / Boardroom Split

  LinkedPropagationChain = the Lean proof layer (BOARDROOM, HyphaCore)
  TentacleSearch         = the game layer (ARCADE, TentacleCore)

The functor `tentacleToHypha` is literally the door between the two rooms.
-/

import Mathlib
import RequestProject.Bridge.TentacleCore

set_option maxHeartbeats 800000

open ZMod Finset HeroMonster FixedPoint MonsterMycology

/-! ## §1–§4 are in HyphaCore.lean
    (Activation, PropagationF, PartialCoalgebra, PartialPropStep,
     PartialChain, concrete fungal chain, MemeSystem, Vine, etc.)

    §8 tentacle types are in TentacleCore.lean
    (FeedbackSignal, AttemptedStep, TentacleSearch, FeedbackMemeSystem,
     FeedbackVine, SubstrateTile, ColonizationAttempt, ColonizationResult) -/

/-! ## §5. Arrow Taxonomy — Three Kinds of Morphism

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

/-! ## §6. The Agency Ladder -/

/-- The levels of the agency ladder. -/
inductive AgencyLevel where
  | tendril       -- local probe, no feedback
  | hypha         -- branching search, no feedback
  | tentacle      -- directed sensing WITH feedback (counit acquired)
  | appendage     -- embodied task-specific action
  | motor         -- cyclic activation
  | rotor         -- symmetry group action
  | cliffordRepr  -- universal rotor algebra Cl(p,q)
  | ooda          -- control monad (consequence of feedback)
  deriving DecidableEq, Repr, Inhabited

/-- Which regime an agency level belongs to. -/
inductive Regime where
  | preFeedback   -- boardroom DAO
  | postFeedback  -- arcade
  | closure       -- OODA control monad
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

/-! ## §7. Agency Morphisms — Typed Arrows -/

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

/-- Hypha → Tentacle: **DISCONTINUITY** (feedback / counit acquired). -/
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

/-- Clifford → OODA: OODA is the control monad. -/
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

/-- The Hypha → Tentacle arrow is the only discontinuity in the ladder. -/
theorem unique_discontinuity :
    ∀ (m : AgencyMorphism),
      m ∈ agencyLadder →
      m.kind = .discontinuity → m = hyphaToTentacle := by
  intro m hm hkind
  simp [agencyLadder, List.mem_cons] at hm
  rcases hm with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
    simp_all [tendrilToHypha, hyphaToTentacle, tentacleToAppendage,
              appendageToMotor, motorToRotor, rotorToClifford, cliffordToOODA]

/-- Pre-feedback levels are exactly tendril and hypha. -/
theorem preFeedback_levels :
    ∀ a : AgencyLevel, a.regime = .preFeedback ↔ (a = .tendril ∨ a = .hypha) := by
  intro a; cases a <;> simp [AgencyLevel.regime]

/-- The feedback boundary. -/
theorem feedback_boundary :
    AgencyLevel.hypha.regime = .preFeedback ∧
    AgencyLevel.tentacle.regime = .postFeedback :=
  ⟨rfl, rfl⟩

instance : Fintype AgencyLevel where
  elems := {.tendril, .hypha, .tentacle, .appendage, .motor, .rotor, .cliffordRepr, .ooda}
  complete := by intro a; cases a <;> simp

theorem agency_ladder_levels : Fintype.card AgencyLevel = 8 := by decide

/-! ## §9. OODA as Consequence of Feedback -/

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
  | .decide  => .tentacle
  | .act     => .motor

/-- The discontinuity lives between Orient and Decide. -/
theorem ooda_discontinuity :
    OODAPhase.orient.agencyLevel.regime = .preFeedback ∧
    OODAPhase.decide.agencyLevel.regime = .postFeedback :=
  ⟨rfl, rfl⟩

/-- An OODA cycle: one complete iteration of the control loop. -/
structure OODACycle (A : Type) where
  initial : A
  observe : A → Option A
  orient : A → Option A
  decide : A → Option A
  act : A → Option A

/-- A complete OODA cycle: all four phases landed. -/
def OODACycle.complete {A : Type} (c : OODACycle A) : Option A :=
  c.observe c.initial >>= c.orient >>= c.decide >>= c.act

/-- An OODA cycle is successful if all four phases landed. -/
def OODACycle.successful {A : Type} (c : OODACycle A) : Prop :=
  c.complete.isSome

/-- An OODA loop: the output feeds back into the next cycle's input. -/
structure OODALoop (A : Type) where
  cycle : OODACycle A
  feedback_loop : ∀ a, cycle.complete = some a → (cycle.observe a).isSome
  description : String

/-- Run an OODA loop for n iterations. -/
def OODALoop.iterate {A : Type} (loop : OODALoop A) : ℕ → Option A
  | 0 => some loop.cycle.initial
  | n + 1 => do
    let prev ← loop.iterate n
    let observed ← loop.cycle.observe prev
    let oriented ← loop.cycle.orient observed
    let decided ← loop.cycle.decide oriented
    loop.cycle.act decided

/-! ## §10. Player Archetypes -/

/-- The three player archetypes in the tycoon mechanic. -/
inductive PlayerArchetype where
  | copier
  | tweakerLolz
  | tweakerWinz
  deriving DecidableEq, Repr, Inhabited

/-- How each archetype relates to the regime structure. -/
def PlayerArchetype.regime : PlayerArchetype → Regime
  | .copier => .preFeedback
  | .tweakerLolz => .preFeedback
  | .tweakerWinz => .postFeedback

/-- Only winz tweakers use post-feedback strategy. -/
theorem only_winz_uses_feedback :
    ∀ p : PlayerArchetype, p.regime = .postFeedback ↔ p = .tweakerWinz := by
  intro p; cases p <;> simp [PlayerArchetype.regime]

/-- The module map: which module each archetype's computations live in. -/
def PlayerArchetype.module : PlayerArchetype → String
  | .copier      => "HyphaCore"
  | .tweakerLolz => "HyphaCore"
  | .tweakerWinz => "TentacleCore"

/-! ## §11. Summary — Two Rooms, One Door

| Layer | Room | Regime | Error Signal | Lean Structure |
|-------|------|--------|--------------|----------------|
| Tendril | Boardroom | Pre-feedback | None | `PartialCoalgebra` |
| Hypha | Boardroom | Pre-feedback | None | `PartialChain`, `Vine`, `MemeSystem` |
| **--- DISCONTINUITY (counit acquired) --- THE DOOR ---** | | | | |
| Tentacle | Arcade | Post-feedback | Yes | `AttemptedStep`, `TentacleSearch` |
| Appendage | Arcade | Post-feedback | Yes | (enrichment of tentacle) |
| Motor | Arcade | Post-feedback | Yes | (abstraction: cyclic) |
| Rotor | Arcade | Post-feedback | Yes | (abstraction: symmetry) |
| Clifford | Arcade | Post-feedback | Yes | (abstraction: Cl(p,q)) |
| **--- CLOSURE ---** | | | | |
| OODA | Arcade | Closure | Yes | `OODACycle` (consequence) |

HyphaCore (proof layer) = **Boardroom** = hypha records.
TentacleCore (game layer) = **Arcade** = tentacle search with feedback.
PartialPropagation (this module) = **Arrow taxonomy + OODA + Player archetypes**.
OODABridge (next module) = imports all and adds OODALoop structure.
-/
