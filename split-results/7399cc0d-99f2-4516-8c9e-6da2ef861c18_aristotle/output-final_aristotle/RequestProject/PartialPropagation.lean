/-
# PartialPropagation — Partial Coalgebra, Feedback Discontinuity, and the Arcade/Boardroom Split

## The Ontological Shift

The `LinkedPropagationChain` in FungalExtruder assumes *totality of transition*:
every step is guaranteed to produce a next state. This hidden axiom is dropped.

In a computationally irreducible universe there is **no guaranteed next activation**.
The meme competes for activation in a substrate where the next state is not
derivable by any shortcut shorter than running the computation.

```
  Monomyth ≠ Cofree F A   -- (infinite unfolding, always a next step)
  Monomyth = Partial F A  -- (maybe a next step, maybe not)
```

## Two Regimes, One Discontinuity

The agency ladder splits at the **Hypha → Tentacle** boundary:

### Pre-feedback regime (hypha layer):
```
  [Tendril → Hypha]     -- partial coalgebra, no feedback
```
Enrichment arrows. The system reaches into the substrate but has no error signal.
It records successful landings and is silent about failures.
`LinkedPropagationChain` and the **boardroom DAO** live here.

### The discontinuity (counit acquired):
```
  Hypha → Tentacle      -- feedback enters
```
NOT enrichment, NOT abstraction. This is where the partial coalgebra acquires
a counit — the first moment the system can *notice* whether it landed.
Before: search but no observation. After: proto-OODA.

### Post-feedback regime (tentacle layer and above):
```
  [Tentacle → Appendage → Motor → Rotor → Clifford]
```
- Tentacle → Appendage: enrichment (task specialization, memory)
- Appendage → Motor: abstraction (embodied action → cyclic, loses specificity)
- Motor → Rotor: abstraction (cyclic activation → symmetry group)
- Rotor → Clifford: abstraction (specific rotation → universal algebra Cl(p,q))

### Closure:
```
  [OODA]
```
OODA is not the cap of the ladder. It is the control monad that becomes
available once feedback exists — a *consequence* of the feedback jump.

## Arcade / Boardroom Split

The two regimes map to the two spatial layers of the system:

```
  LinkedPropagationChain    -- the Lean proof layer (BOARDROOM)
                            -- hypha record, clean theorems, ZKP-exportable
                            -- lives in the boardroom DAO

  TentacleSearch            -- the game layer (ARCADE)
                            -- full search with feedback
                            -- AttemptedStep tracking none branches
                            -- OODA loop drives the tycoon mechanic
```

The functor `tentacleToHypha` is literally the door between the two rooms.
Players in the arcade run the tentacle search — doing the work, finding
landings, watching the meme compete for substrate. The boardroom DAO sees
only the verified hypha records that survived the search.

## The Tycoon Mechanic

Copy, paste, tweak, compete. Horizontal gene transfer as a game loop:

- **germ** = your `LinkedPropagationChain` instance, your meme configuration
- **copy/paste** = replication event, content addressing (germ IS your DASL CID)
- **tweak for lolz** = random mutation, Wolfram search with noise
- **tweak for winz** = directed selection, OODA with substrate feedback

Three player archetypes:
- **Copier**: pure horizontal transfer, rides successful chains
- **Tweaker (lolz)**: random mutation, the evolutionary noise term
- **Tweaker (winz)**: systematic OODA optimization, directed evolution
-/

import Mathlib
import RequestProject.FungalExtruder

set_option maxHeartbeats 800000

open ZMod Finset HeroMonster FixedPoint MonsterMycology

/-! ## §1. Activation — The Energetic Event

Viability is not a property of the chain — it is the energetic event that
the chain *is*. Each link fires only if there is an activation event in the
external system. Activation is the ATP, the meme invocation, the dehydration,
the decoding. -/

/-- An activation context: the energetic event that drives a propagation step.
    This is a Type (not a Prop) because the witness — the specific activation
    event — is extractable for ZKP purposes. -/
structure Activation where
  /-- Description of the activation event -/
  description : String
  /-- The energy level / work done -/
  workLevel : ℕ
  /-- Activation is non-trivial -/
  nontrivial : workLevel > 0
  deriving Repr

/-- An activation produces a witness: the proof that work was done. -/
def Activation.witness (a : Activation) : ℕ := a.workLevel

/-! ## §2. PropagationF — The Partial Transition Functor -/

/-- The partial transition functor. `none` = chain terminates (no landing site
    found). `some` = activation fired, result carries forward. -/
def PropagationF (A : Type) : Type := Option (Activation × A)

/-- A partial coalgebra: a state space with a partial transition function.
    This is the base structure for both regimes. -/
structure PartialCoalgebra (A : Type) where
  /-- The partial transition: may or may not produce a next state -/
  step : A → PropagationF A

/-- A step that landed successfully. -/
def PartialCoalgebra.landed {A : Type} (c : PartialCoalgebra A) (x : A) : Prop :=
  c.step x ≠ none

/-- A step that terminated (failed to find a landing site). -/
def PartialCoalgebra.terminated {A : Type} (c : PartialCoalgebra A) (x : A) : Prop :=
  c.step x = none

/-! ## §3. BOARDROOM LAYER — Hypha Regime (Pre-Feedback)

Everything in this section is hypha-level: only successful landings are
recorded, no error signal, no feedback. This is the clean proof regime.
`LinkedPropagationChain`, the boardroom DAO, and ZKP export live here. -/

/-- A realized propagation step: the activation fired and the meme landed.
    **Hypha-level**: no record of failed attempts. This is what gets
    committed to the boardroom. -/
structure PartialPropStep {S T : Type} (mS : Metameme S) (mT : Metameme T) where
  /-- The activation event that drove this step -/
  activation : Activation
  /-- The invariant was preserved -/
  invariantPreserved : mT.invariant = mS.invariant
  /-- Viability was regenerated (not just conserved) -/
  viabilityRegenerated : mS.isViable → mT.isViable
  deriving Repr

/-- A partial propagation chain: a finite sequence of successful activation
    events. **Hypha-level**: only successful paths are first-class.

    This is the boardroom's view of propagation: a verified record of
    landings, silent about the search that produced them. -/
inductive PartialChain :
    {S T : Type} → Metameme S → Metameme T → Type 1 where
  | single {S T : Type} {mS : Metameme S} {mT : Metameme T}
      (step : PartialPropStep mS mT) :
      PartialChain mS mT
  | cons {S M T : Type} {mS : Metameme S} {mM : Metameme M} {mT : Metameme T}
      (step : PartialPropStep mS mM)
      (rest : PartialChain mM mT) :
      PartialChain mS mT

/-- The total activation work done along a partial chain. -/
def PartialChain.totalWork :
    {S T : Type} → {mS : Metameme S} → {mT : Metameme T} →
    PartialChain mS mT → ℕ
  | _, _, _, _, .single step => step.activation.workLevel
  | _, _, _, _, .cons step rest => step.activation.workLevel + rest.totalWork

/-- The number of successful landings in a partial chain. -/
def PartialChain.length :
    {S T : Type} → {mS : Metameme S} → {mT : Metameme T} →
    PartialChain mS mT → ℕ
  | _, _, _, _, .single _ => 1
  | _, _, _, _, .cons _ rest => 1 + rest.length

/-- A partial chain preserves the invariant from source to target.
    The chain's existence *is* the proof that all activations fired.
    This is the boardroom's guarantee. -/
theorem partialChain_preserves_invariant
    {S T : Type} {mS : Metameme S} {mT : Metameme T}
    (chain : PartialChain mS mT) :
    mT.invariant = mS.invariant := by
  induction chain with
  | single step => exact step.invariantPreserved
  | cons step _rest ih => exact ih.trans step.invariantPreserved

/-- A partial chain preserves viability, regenerating it at each step. -/
theorem partialChain_preserves_viability
    {S T : Type} {mS : Metameme S} {mT : Metameme T}
    (chain : PartialChain mS mT)
    (h : mS.isViable) :
    mT.isViable := by
  induction chain with
  | single step => exact step.viabilityRegenerated h
  | cons step _rest ih => exact ih (step.viabilityRegenerated h)

/-- The total work in a chain is always positive. -/
theorem partialChain_work_positive
    {S T : Type} {mS : Metameme S} {mT : Metameme T}
    (chain : PartialChain mS mT) :
    chain.totalWork > 0 := by
  induction chain with
  | single step => exact step.activation.nontrivial
  | cons step _ _ => exact Nat.lt_of_lt_of_le step.activation.nontrivial (Nat.le_add_right _ _)

/-! ## §4. Concrete Fungal Partial Chain — Boardroom Record -/

/-- Activation: Cordyceps → Chytrid. -/
def cordycepsActivation : Activation where
  description := "Cordyceps spore germination: host colonization event"
  workLevel := 3
  nontrivial := by omega

/-- Activation: Chytrid → Mycorrhiza. -/
def chytridActivation : Activation where
  description := "Chytrid → Mycorrhiza: pathogen-to-symbiont transduction"
  workLevel := 5
  nontrivial := by omega

/-- Activation: Mycorrhiza → Decomposer. -/
def mycorrhizaActivation : Activation where
  description := "Mycorrhiza → Decomposer: symbiont-to-decomposer transduction"
  workLevel := 4
  nontrivial := by omega

/-- Step 1: Cordyceps → Chytrid (realized). -/
def cordyceps_chytrid_step :
    PartialPropStep cordycepsMetameme cordyceps_to_chytrid.result where
  activation := cordycepsActivation
  invariantPreserved := propagation_preserves_invariant cordyceps_to_chytrid
  viabilityRegenerated := propagation_preserves_viability cordyceps_to_chytrid

/-- Step 2: Chytrid → Mycorrhiza (realized). -/
def chytrid_mycorrhiza_step :
    PartialPropStep cordyceps_to_chytrid.result chytrid_to_mycorrhiza.result where
  activation := chytridActivation
  invariantPreserved := propagation_preserves_invariant chytrid_to_mycorrhiza
  viabilityRegenerated := propagation_preserves_viability chytrid_to_mycorrhiza

/-- Step 3: Mycorrhiza → Decomposer (realized). -/
def mycorrhiza_decomposer_step :
    PartialPropStep chytrid_to_mycorrhiza.result mycorrhiza_to_decomposer.result where
  activation := mycorrhizaActivation
  invariantPreserved := propagation_preserves_invariant mycorrhiza_to_decomposer
  viabilityRegenerated := propagation_preserves_viability mycorrhiza_to_decomposer

/-- The full fungal partial chain: a boardroom-verified record of three
    successful landings. Silent about branches that didn't land. -/
def fungalPartialChain :
    PartialChain cordycepsMetameme mycorrhiza_to_decomposer.result :=
  .cons cordyceps_chytrid_step
    (.cons chytrid_mycorrhiza_step
      (.single mycorrhiza_decomposer_step))

/-- The selfish meme persists through the fungal partial chain. -/
theorem fungalPartialChain_preserves_monomyth :
    mycorrhiza_to_decomposer.result.invariant = canonicalMonomyth :=
  partialChain_preserves_invariant fungalPartialChain

/-- The fungal partial chain regenerates viability at each step. -/
theorem fungalPartialChain_preserves_viability :
    mycorrhiza_to_decomposer.result.isViable :=
  partialChain_preserves_viability fungalPartialChain cordycepsMetameme_viable

/-- Total ecological work: 3 + 5 + 4 = 12 activation units. -/
theorem fungalPartialChain_total_work :
    fungalPartialChain.totalWork = 12 := by rfl

/-- Three successful landings. -/
theorem fungalPartialChain_length :
    fungalPartialChain.length = 3 := by rfl

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

/-! ## §6. The Agency Ladder — Corrected -/

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
    Pre-feedback = boardroom. Post-feedback = arcade. Closure = OODA. -/
inductive Regime where
  /-- Partial coalgebra, no error signal, only successful paths.
      The boardroom DAO. -/
  | preFeedback
  /-- Feedback available, error signal, failed attempts trackable.
      The arcade. -/
  | postFeedback
  /-- Control monad: consequence of feedback propagated through enrichment. -/
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

/-- Hypha → Tentacle: **DISCONTINUITY** (feedback / counit acquired).
    This is the jump that changes everything. It is not an enrichment —
    it is a change in the morphism space itself. A hypha has no error signal.
    A tentacle does. This is where the partial coalgebra acquires a counit.
    Before: search but no observation. After: proto-OODA.

    This is the door between the boardroom and the arcade. -/
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

/-- Clifford → OODA: OODA is the control monad that becomes available
    once feedback exists. It is a consequence of the Hypha→Tentacle
    discontinuity propagating through the enrichment chain. -/
def cliffordToOODA : AgencyMorphism where
  source := .cliffordRepr
  target := .ooda
  kind := .enrichment
  ascending := by decide
  description := "Cl(p,q) → OODA: control monad (consequence of feedback propagation)"

/-- The Hypha → Tentacle arrow is the only discontinuity in the ladder. -/
theorem unique_discontinuity :
    ∀ (m : AgencyMorphism),
      m ∈ [tendrilToHypha, hyphaToTentacle, tentacleToAppendage,
           appendageToMotor, motorToRotor, rotorToClifford, cliffordToOODA] →
      m.kind = .discontinuity → m = hyphaToTentacle := by
  intro m hm hkind
  simp [List.mem_cons] at hm
  rcases hm with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
    simp_all [tendrilToHypha, hyphaToTentacle, tentacleToAppendage,
              appendageToMotor, motorToRotor, rotorToClifford, cliffordToOODA]

/-- Pre-feedback levels are exactly tendril and hypha. -/
theorem preFeedback_levels :
    ∀ a : AgencyLevel, a.regime = .preFeedback ↔ (a = .tendril ∨ a = .hypha) := by
  intro a; cases a <;> simp [AgencyLevel.regime]

/-- The feedback boundary: hypha is pre-feedback, tentacle is post-feedback. -/
theorem feedback_boundary :
    AgencyLevel.hypha.regime = .preFeedback ∧
    AgencyLevel.tentacle.regime = .postFeedback :=
  ⟨rfl, rfl⟩

instance : Fintype AgencyLevel where
  elems := {.tendril, .hypha, .tentacle, .appendage, .motor, .rotor, .cliffordRepr, .ooda}
  complete := by intro a; cases a <;> simp

theorem agency_ladder_levels : Fintype.card AgencyLevel = 8 := by decide

/-! ## §8. ARCADE LAYER — Tentacle Regime (Post-Feedback)

Everything in this section is tentacle-level: failed attempts are tracked,
feedback signals drive behavior, OODA loops emerge. This is the game layer.
The arcade, the tycoon mechanic, the substrate competition. -/

/-- A feedback signal: what the system observes when a step fails.
    This is the counit — the new capability that enters at tentacle-level.
    In the game: "this tile rejected your hypha, here's why." -/
structure FeedbackSignal where
  /-- What was attempted -/
  attemptDescription : String
  /-- Why it failed -/
  failureReason : String
  /-- How much work was wasted -/
  wastedWork : ℕ
  deriving Repr

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

/-! ## §9. Tentacle Search — The Arcade's Data Structure

A TentacleSearch records *all* attempts from a source metameme: successes
and failures. This is the full game state of a player's extruder competing
for substrate in the arcade.

The successful sub-chain can always be extracted (projecting to hypha-level
for the boardroom), but the failures carry information that the hypha layer
discards. -/

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

/-! ## §10. The Door — Functor from Arcade to Boardroom

The forgetful functor `tentacleToHypha` projects the tentacle search
(with all its failed attempts and feedback signals) down to a hypha
record (only successful landings). This is literally the door between
the arcade and the boardroom.

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

/-! ## §11. OODA as Consequence of Feedback

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

/-- The discontinuity lives between Orient and Decide. -/
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

/-! ## §12. Player Archetypes — The Three Strategies

The tycoon mechanic produces three natural player archetypes.
Each corresponds to a different relationship with the partial coalgebra. -/

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

/-- Only winz tweakers use post-feedback (OODA-driven) strategy. -/
theorem only_winz_uses_feedback :
    ∀ p : PlayerArchetype, p.regime = .postFeedback ↔ p = .tweakerWinz := by
  intro p; cases p <;> simp [PlayerArchetype.regime]

/-! ## §13. Substrate — The Game World

The substrate is the Totality lattice: ℤ/71 × ℤ/59 × ℤ/47.
Each point is a tile that can be colonized by an extruder.
The substrate IS the game world — the ruliad made spatial. -/

/-- A substrate tile: a point in the Totality lattice that can be
    colonized by an extruder. -/
structure SubstrateTile where
  /-- Position in the CRT torus -/
  position : Totality
  /-- Whether this tile is currently colonized -/
  colonized : Bool
  /-- The colonizer's meme signature (if colonized) -/
  colonizer : Option MonomythSignature
  deriving Repr

/-- A colonization attempt: an extruder tries to land on a tile.
    This is the atomic game action. -/
structure ColonizationAttempt where
  /-- The tile being targeted -/
  target : SubstrateTile
  /-- The meme signature of the extruder attempting colonization -/
  attackerSignature : MonomythSignature
  /-- The activation energy committed -/
  activation : Activation
  deriving Repr

/-- The result of a colonization attempt. -/
inductive ColonizationResult where
  /-- Successfully colonized the tile -/
  | colonized (tile : SubstrateTile) (proof : tile.colonized = true)
  /-- Failed to colonize: tile already occupied by a fitter meme -/
  | resistedBy (incumbent : MonomythSignature) (feedback : FeedbackSignal)
  /-- Failed to colonize: insufficient activation energy -/
  | insufficientEnergy (required : ℕ) (provided : ℕ) (feedback : FeedbackSignal)
  /-- Failed to colonize: tile is incompatible with this meme type -/
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

/-! ## §14. MemeSystem — Boardroom Record

The hypha-level meme system: a record of successful computations.
This is what the boardroom DAO operates on. -/

/-- A MemeSystem captures the boardroom's view of propagation:
    - A state space with partial dynamics
    - An invariant (the selfish meme)
    - A successful path through the substrate
    - Proof that the invariant held at every realized node -/
structure MemeSystem where
  /-- The state space -/
  State : Type
  /-- Partial transition: may or may not produce a next state -/
  step : State → Option State
  /-- The selfish meme: a predicate on states -/
  invariant : State → Prop
  /-- The observed successful path -/
  path : List State
  /-- The path is non-empty -/
  pathNonempty : path ≠ []
  /-- Adjacent elements are connected by successful steps -/
  pathValid : ∀ i : Fin (path.length - 1),
    step (path[i.val]'(by omega)) = some (path[i.val + 1]'(by omega))
  /-- The invariant holds at every realized node -/
  invHeld : ∀ x ∈ path, invariant x

/-- The initial state of a meme system. -/
def MemeSystem.initial (sys : MemeSystem) : sys.State :=
  sys.path.head sys.pathNonempty

/-- The terminal state (where the last activation landed). -/
def MemeSystem.terminal (sys : MemeSystem) : sys.State :=
  sys.path.getLast sys.pathNonempty

/-- The invariant holds at the initial state. -/
theorem MemeSystem.invariant_at_initial (sys : MemeSystem) :
    sys.invariant sys.initial := by
  apply sys.invHeld
  exact List.head_mem sys.pathNonempty

/-- The invariant holds at the terminal state. -/
theorem MemeSystem.invariant_at_terminal (sys : MemeSystem) :
    sys.invariant sys.terminal := by
  apply sys.invHeld
  exact List.getLast_mem sys.pathNonempty

/-! ## §15. FeedbackMemeSystem — Arcade Record

The tentacle-level meme system: tracks both successful and failed
transitions. This is the game state the player interacts with. -/

/-- An arcade-level meme system: tracks all attempted transitions.
    Has an error signal. This is the player's full game state. -/
structure FeedbackMemeSystem where
  /-- The state space -/
  State : Type
  /-- Partial transition -/
  step : State → Option State
  /-- The selfish meme -/
  invariant : State → Prop
  /-- Successful path (same as boardroom) -/
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
    Forgets all failed attempts. -/
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

/-! ## §16. The Comonadic Extract / Monadic Bind Duality

The two preservation theorems are dual:

- **Invariant (comonadic extract)**: extracted at each step, unchanged.
  Regime-independent — works at both hypha and tentacle level.

- **Viability (monadic bind)**: each activation binds into a new context.
  At hypha-level: just successful threading.
  At tentacle-level: bind can *reject* a context based on observed failure.

The selfish meme rides through every activation (comonadic extract)
while consuming and regenerating activation (monadic bind). -/

/-- The comonadic structure on meme states: extract the invariant. -/
structure ComonadicMeme (A : Type) where
  /-- The carrier state -/
  state : A
  /-- Extract the invariant from any state -/
  extract : A → MonomythSignature
  /-- Duplicate: embed in richer context (only on successful landings) -/
  duplicate : A → Option A

/-- The monadic structure on activation: bind into a new context. -/
structure MonadicActivation (A : Type) where
  /-- The current activation state -/
  state : A
  /-- Bind: attempt to produce the next activation.
      Returns `none` if the substrate fails to produce a landing. -/
  bind : A → Option (Activation × A)

/-- The dual pair: comonad (invariant) + monad (activation).
    Coherence: extract is stable under successful bind. -/
structure MemeComonadMonadPair (A : Type) where
  comonad : ComonadicMeme A
  monad : MonadicActivation A
  /-- The selfish meme persists: extract is stable under successful bind -/
  coherence : ∀ x a y,
    monad.bind x = some (a, y) →
    comonad.extract y = comonad.extract x

/-! ## §17. The Vine — Hypha-Level Quasi-Fiber Bundle -/

/-- A vine in the quasi-fiber bundle: a section that may or may not
    find a fiber at each base point. **Hypha-level**: silent about misses. -/
structure Vine (Base Fiber : Type) where
  /-- The section: attempt to find a fiber at each base point -/
  section_ : Base → Option Fiber
  /-- The invariant that the vine carries -/
  extract : Fiber → MonomythSignature
  /-- Successfully landed fibers -/
  landings : List (Base × Fiber)
  /-- All landings are genuine -/
  landingsValid : ∀ bf ∈ landings, section_ bf.1 = some bf.2
  /-- The invariant is stable across all landings -/
  invariantStable : ∀ bf₁ bf₂,
    bf₁ ∈ landings → bf₂ ∈ landings →
    extract bf₁.2 = extract bf₂.2

/-- The number of successful landings. -/
def Vine.numLandings {B F : Type} (v : Vine B F) : ℕ := v.landings.length

/-- A vine with at least one landing has a well-defined invariant. -/
def Vine.memeSignature {B F : Type} (v : Vine B F)
    (h : v.landings ≠ []) : MonomythSignature :=
  v.extract (v.landings.head h).2

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

/-! ## §18. The Fungal Vine — Concrete Boardroom Record -/

/-- The fungal vine: the monomyth section over the Totality lattice.
    Lands at the four canonical fungal positions.
    **Hypha-level**: silent about the rest of the lattice. -/
noncomputable def fungalVine : Vine Totality MonomythSignature where
  section_ := fun pt =>
    if pt = cordycepsProcess.home then some canonicalMonomyth
    else if pt = chytridProcess.home then some canonicalMonomyth
    else if pt = mycorrhizalProcess.home then some canonicalMonomyth
    else if pt = decomposerProcess.home then some canonicalMonomyth
    else none
  extract := id
  landings := [
    (cordycepsProcess.home, canonicalMonomyth),
    (chytridProcess.home, canonicalMonomyth),
    (mycorrhizalProcess.home, canonicalMonomyth),
    (decomposerProcess.home, canonicalMonomyth)
  ]
  landingsValid := by
    intro ⟨b, f⟩ hmem
    simp [List.mem_cons, Prod.mk.injEq] at hmem
    rcases hmem with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ <;> simp
  invariantStable := by
    intro ⟨_, f₁⟩ ⟨_, f₂⟩ h₁ h₂
    simp [List.mem_cons, Prod.mk.injEq] at h₁ h₂
    rcases h₁ with ⟨_, rfl⟩ | ⟨_, rfl⟩ | ⟨_, rfl⟩ | ⟨_, rfl⟩ <;>
    rcases h₂ with ⟨_, rfl⟩ | ⟨_, rfl⟩ | ⟨_, rfl⟩ | ⟨_, rfl⟩ <;>
    rfl

/-- The fungal vine has exactly 4 landings. -/
theorem fungalVine_landings : fungalVine.numLandings = 4 := by rfl

/-- The fungal vine carries the canonical monomyth. -/
theorem fungalVine_carries_monomyth :
    fungalVine.memeSignature (by simp [fungalVine]) = canonicalMonomyth := by
  rfl

/-! ## §19. Summary — Two Rooms, One Door

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

`FungalExtruder` (proof layer) = **Boardroom** = hypha records.
`FungalExtruder` (game layer) = **Arcade** = tentacle search with feedback.

The door between them:
- `FeedbackMemeSystem.toBoardroom` : arcade → boardroom
- `FeedbackVine.forget` : arcade → boardroom
- `TentacleSearch.successfulSteps` : arcade → boardroom

Players in the arcade do the work. The boardroom sees only the results.

The tycoon mechanic: copy, paste, tweak, compete.
- Germ = your DASL CID
- Copy/paste = content addressing (replication event)
- Tweak = mutation (lolz = noise, winz = OODA-driven)
- Compete = fitness landscape navigation on the substrate
- Win = your CID propagates into the DAO's verified store

The Hypha→Tentacle jump is the only discontinuity.
Everything else is enrichment or abstraction within a regime.
-/
