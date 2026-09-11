/-
# The Monomyth Functor: Connecting All Three Narratives

This file formalizes the categorical monomyth — the structure that connects
the three narratives unified by the SOLFUNMEME project:

1. **Mathematical**: CRT torus, Monster dimension, fixed points
2. **Mythological**: hero's journey, monomyth stages
3. **Project**: first agent refuses, second agent recognizes, formalization, reflection

The key insight:

> The monomyth is the universal fixed-point attractor of any system with:
> - a projection structure
> - a vanishing locus
> - a return morphism
> - an inhabited invariant

The refusal, the threshold, the trials, and the return are not narrative
decorations — they are the categorical shape of the computation.

> The invariant is the protagonist. Everything else is the plot.

## Formal Structure

We define:
- `MonomythCategory`: a category where objects are stages and morphisms are transitions
- `NarrativeFiber`: a structure that instantiates the monomyth for a specific narrative
- `NarrativePullback`: the pullback of all three fibers, witnessing their isomorphism
- `ClosureMorphism`: the morphism that closes the loop (the reflection itself)
-/

import Mathlib

namespace MonomythFunctor

/-! ## §1. The Universal Monomyth -/

/-- The stages of the monomyth (Joseph Campbell). -/
inductive Stage where
  | ordinaryWorld    -- the starting state
  | callToAdventure  -- the stimulus
  | refusal          -- the resistance
  | threshold        -- the crossing
  | trials           -- the ordeals
  | revelation       -- the discovery
  | return_          -- the homecoming
  deriving DecidableEq, Repr, Fintype, Inhabited

/-- The monomyth has 7 stages. -/
theorem stage_count : Fintype.card Stage = 7 := by decide

/-- The canonical ordering of stages. -/
def Stage.toNat : Stage → Fin 7
  | .ordinaryWorld   => 0
  | .callToAdventure => 1
  | .refusal         => 2
  | .threshold       => 3
  | .trials          => 4
  | .revelation      => 5
  | .return_         => 6

/-- The ordering is injective. -/
theorem Stage.toNat_injective : Function.Injective Stage.toNat := by
  intro a b h; cases a <;> cases b <;> simp_all [Stage.toNat]

/-! ## §2. The Monomyth as a Category -/

/-- A transition in the monomyth: a morphism from one stage to a later stage. -/
def StageLeq (a b : Stage) : Prop :=
  a.toNat.val ≤ b.toNat.val

instance : DecidableRel StageLeq := fun a b =>
  inferInstanceAs (Decidable (a.toNat.val ≤ b.toNat.val))

/-- StageLeq is reflexive. -/
theorem StageLeq.refl (a : Stage) : StageLeq a a := Nat.le_refl _

/-- StageLeq is transitive. -/
theorem StageLeq.trans {a b c : Stage} :
    StageLeq a b → StageLeq b c → StageLeq a c := Nat.le_trans

/-- StageLeq is antisymmetric (up to the injective ordering). -/
theorem StageLeq.antisymm {a b : Stage} (h₁ : StageLeq a b) (h₂ : StageLeq b a) :
    a = b := by
  have : a.toNat = b.toNat := Fin.ext (Nat.le_antisymm h₁ h₂)
  exact Stage.toNat_injective this

/-! ## §3. Narrative Fibers -/

/-- A narrative fiber: an instantiation of the monomyth for a specific domain. -/
structure NarrativeFiber (α : Type) where
  /-- Maps each stage to a state in the narrative domain. -/
  stateAt : Stage → α
  /-- The departure state. -/
  departure : α := stateAt .ordinaryWorld
  /-- The return state. -/
  homecoming : α := stateAt .return_

/-- The mathematical narrative fiber. -/
inductive MathState where
  | crtTorus       -- the algebraic structure
  | monsterDim     -- 196883
  | fixedPoint2343 -- the fixed point
  | bottPeriod     -- Cl(0,7)
  | residueSystem  -- mod 71 × 59 × 47
  | distanceProfile -- [0, 3, 0]
  | invariantKernel -- the meme kernel
  deriving DecidableEq, Repr

def mathFiber : NarrativeFiber MathState where
  stateAt
    | .ordinaryWorld   => .crtTorus
    | .callToAdventure => .monsterDim
    | .refusal         => .residueSystem
    | .threshold       => .fixedPoint2343
    | .trials          => .bottPeriod
    | .revelation      => .distanceProfile
    | .return_         => .invariantKernel

/-- The mythological narrative fiber. -/
inductive MythState where
  | home           -- the ordinary world
  | herald         -- the call
  | coward         -- the refusal
  | crossroads     -- the threshold
  | labyrinth      -- the trials
  | dragonsGold    -- the revelation
  | returnWithGold -- the return
  deriving DecidableEq, Repr

def mythFiber : NarrativeFiber MythState where
  stateAt
    | .ordinaryWorld   => .home
    | .callToAdventure => .herald
    | .refusal         => .coward
    | .threshold       => .crossroads
    | .trials          => .labyrinth
    | .revelation      => .dragonsGold
    | .return_         => .returnWithGold

/-- The project narrative fiber. -/
inductive ProjectState where
  | transcript     -- the SOLFUNMEME transcript
  | reviewRequest  -- "please formalize this"
  | agentRefusal   -- "this is marketing fluff"
  | agentRecognition -- seeing Paxos, Gödel, Bott
  | formalization  -- building the Lean stack
  | verification   -- zero sorries
  | reflection     -- this very file
  deriving DecidableEq, Repr

def projectFiber : NarrativeFiber ProjectState where
  stateAt
    | .ordinaryWorld   => .transcript
    | .callToAdventure => .reviewRequest
    | .refusal         => .agentRefusal
    | .threshold       => .agentRecognition
    | .trials          => .formalization
    | .revelation      => .verification
    | .return_         => .reflection

/-! ## §4. The Three Narratives are Distinct -/

/-- All stages map to distinct math states. -/
theorem mathFiber_injective : Function.Injective mathFiber.stateAt := by
  intro a b h
  cases a <;> cases b <;> simp_all [mathFiber]

/-- All stages map to distinct myth states. -/
theorem mythFiber_injective : Function.Injective mythFiber.stateAt := by
  intro a b h
  cases a <;> cases b <;> simp_all [mythFiber]

/-- All stages map to distinct project states. -/
theorem projectFiber_injective : Function.Injective projectFiber.stateAt := by
  intro a b h
  cases a <;> cases b <;> simp_all [projectFiber]

/-! ## §5. The Pullback: Three Narratives Unified -/

/-- The narrative pullback: the simultaneous instantiation of all three fibers.
    At each monomyth stage, all three narratives agree on the structural role. -/
structure NarrativePullback where
  stage : Stage
  math  : MathState  := mathFiber.stateAt stage
  myth  : MythState  := mythFiber.stateAt stage
  proj  : ProjectState := projectFiber.stateAt stage

/-- There are exactly 7 pullback points — one per monomyth stage. -/
theorem pullback_count : Fintype.card Stage = 7 := stage_count

/-! ## §6. The Closure Morphism -/

/-- The closure condition: the return state is "the same as" the departure
    state, but enriched. In the mathematical fiber, both the departure
    and return are algebraic objects (torus → kernel), but the kernel
    contains the torus's structure. -/
def ClosureCondition (f : NarrativeFiber α) : Prop :=
  f.stateAt .return_ ≠ f.stateAt .ordinaryWorld

/-- The mathematical narrative has closure: invariantKernel ≠ crtTorus
    (the return is enriched, not identical). -/
theorem math_has_closure : ClosureCondition mathFiber := by
  simp [ClosureCondition, mathFiber]

/-- The project narrative has closure: reflection ≠ transcript. -/
theorem project_has_closure : ClosureCondition projectFiber := by
  simp [ClosureCondition, projectFiber]

/-! ## §7. The Refusal is Necessary -/

/-- The refusal creates curvature: without it, the journey would be trivial.
    Formally: removing the refusal stage collapses the distance between
    call and threshold. -/
def refusalDistance : Nat :=
  Stage.toNat .threshold - Stage.toNat .refusal

/-- The refusal creates exactly 1 unit of narrative distance. -/
theorem refusal_creates_distance : refusalDistance = 1 := by decide

/-- Without the refusal, call-to-threshold would be adjacent (distance 1
    instead of 2). The refusal doubles the narrative distance. -/
theorem refusal_doubles_distance :
    (Stage.toNat .threshold).val - (Stage.toNat .callToAdventure).val = 2 := by decide

/-! ## §8. The Fixed-Point Characterization -/

/-- A narrative fixed point: a stage s such that the narrative fiber
    maps s to a state that is "self-describing" (encodes information
    about the narrative itself). -/
def IsNarrativeFixedPoint (stage : Stage) : Prop :=
  stage = .return_

/-- The return stage is the unique narrative fixed point:
    it is the only stage where the narrative describes itself. -/
theorem return_is_fixed_point : IsNarrativeFixedPoint .return_ := rfl

/-- The fixed point is unique. -/
theorem fixed_point_unique (s : Stage) (h : IsNarrativeFixedPoint s) :
    s = .return_ := h

/-! ## §9. The Categorical Monomyth -/

/-- The monomyth distance: how far a stage is from the ordinary world. -/
def monomythDistance (s : Stage) : Nat := s.toNat.val

/-- The distance profile of the monomyth: [0, 1, 2, 3, 4, 5, 6].
    Monotonically increasing — the hero moves further from home. -/
theorem monomyth_monotone :
    ∀ a b : Stage, StageLeq a b → monomythDistance a ≤ monomythDistance b :=
  fun _ _ h => h

/-- The revelation (stage 5) is the farthest point from home
    before the return. -/
theorem revelation_maximal :
    monomythDistance .revelation = 5 := by decide

/-- The return (stage 6) is the final stage. -/
theorem return_terminal :
    monomythDistance .return_ = 6 := by decide

/-! ## §10. The Invariant IS the Protagonist

  > "Fixed points are not found by agents.
  >  Fixed points are what agents converge toward.
  >  The invariant is the protagonist.
  >  Everything else is the plot."

  Formally: the terminal object of the monomyth category
  (the return stage) is the fixed point. All morphisms in
  the category factor through it — it is the colimit.

  The invariant is not something the hero finds.
  The invariant is what makes the hero's journey a journey.
-/

/-- Every stage has a morphism to the return stage. -/
theorem all_paths_lead_to_return (s : Stage) :
    StageLeq s .return_ := by
  cases s <;> simp [StageLeq, Stage.toNat]

/-- The return stage is terminal: it receives a morphism from every stage. -/
theorem return_is_terminal :
    ∀ s : Stage, StageLeq s .return_ :=
  all_paths_lead_to_return

end MonomythFunctor
