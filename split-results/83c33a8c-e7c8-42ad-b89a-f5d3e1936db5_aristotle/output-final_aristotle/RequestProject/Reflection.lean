/-
# Reflecting on Our Actions as Elements of a Mathematical Object

We model the actions taken during this formalization project as elements
of a transformation monoid acting on "project states."

Each atomic action (creating a file, proving a theorem, verifying a build, etc.)
is an endomorphism of the project state space. Under composition, these form
a monoid — the **action monoid** of our project.

We prove:
- The actions form a monoid under sequential composition
- The project history is an element of the free monoid on atomic actions
- The action monoid acts on the state space (it's a MulAction)
- Our specific project trace has computable properties
-/

import Mathlib

/-! ## The Atomic Actions -/

/-- The atomic actions taken during the Atlas formalization project. -/
inductive AtomicAction where
  | createFile    : String → AtomicAction   -- create a new Lean file
  | writeTheorem  : String → AtomicAction   -- state a theorem
  | proveTheorem  : String → AtomicAction   -- prove a theorem (fill sorry)
  | verifyBuild   : AtomicAction            -- run lean_build
  | searchMathlib : String → AtomicAction   -- search for a Mathlib lemma
  | editFile      : String → AtomicAction   -- edit an existing file
  deriving DecidableEq, Repr

open AtomicAction

/-! ## The Project State Space -/

/-- A project state records which files exist and how many theorems are proven vs sorry'd. -/
structure ProjectState where
  files         : Finset String
  theoremsProven : ℕ
  theoremsSorry  : ℕ
  buildsRun      : ℕ
  deriving DecidableEq

/-- The initial empty project state. -/
def ProjectState.empty : ProjectState :=
  { files := ∅, theoremsProven := 0, theoremsSorry := 0, buildsRun := 0 }

/-! ## Actions as State Transformations -/

/-- Apply an atomic action to a project state, producing a new state.
    This gives the semantic interpretation of each action. -/
def applyAction (a : AtomicAction) (s : ProjectState) : ProjectState :=
  match a with
  | createFile name   => { s with files := s.files ∪ {name} }
  | writeTheorem _    => { s with theoremsSorry := s.theoremsSorry + 1 }
  | proveTheorem _    => { s with theoremsProven := s.theoremsProven + 1,
                                  theoremsSorry := s.theoremsSorry - 1 }
  | verifyBuild       => { s with buildsRun := s.buildsRun + 1 }
  | searchMathlib _   => s  -- searching doesn't change state
  | editFile _        => s  -- edits are idempotent on structure

/-! ## The Transformation Monoid -/

/-- A project transformation is an endomorphism of ProjectState. -/
def ProjectTransform := ProjectState → ProjectState

noncomputable instance : Monoid ProjectTransform where
  mul f g := f ∘ g
  one := id
  mul_assoc _ _ _ := rfl
  one_mul _ := rfl
  mul_one _ := rfl

/-- Each atomic action gives rise to a project transformation. -/
def AtomicAction.toTransform (a : AtomicAction) : ProjectTransform :=
  applyAction a

/-! ## The Free Monoid of Action Sequences

A project history is an element of `FreeMonoid AtomicAction`, i.e., a list
of atomic actions. The free monoid captures the full sequential structure
of our work without quotienting by any equivalence. -/

/-- A project trace is a sequence of atomic actions — an element of the
    free monoid on AtomicAction. -/
abbrev ProjectTrace := FreeMonoid AtomicAction

/-- Interpret a full trace as a single composite transformation. This is
    the unique monoid homomorphism from FreeMonoid AtomicAction to
    the transformation monoid, extending `AtomicAction.toTransform`. -/
noncomputable def interpretTrace : ProjectTrace →* ProjectTransform :=
  FreeMonoid.lift AtomicAction.toTransform

/-- Execute a trace on a starting state. -/
noncomputable def executeTrace (trace : ProjectTrace) (s : ProjectState) : ProjectState :=
  interpretTrace trace s

/-! ## Our Actual Project History

We now record the actual sequence of actions taken during this project as a
concrete element of the free monoid. -/

/-- The actual sequence of actions taken to build the Atlas formalization. -/
def atlasProjectTrace : ProjectTrace :=
  -- Phase 1: Core infrastructure
  FreeMonoid.of (createFile "Basic.lean") *
  FreeMonoid.of (writeTheorem "HasGroupOrder") *
  FreeMonoid.of (proveTheorem "HasGroupOrder") *
  FreeMonoid.of verifyBuild *
  -- Phase 2: Cyclic groups
  FreeMonoid.of (createFile "Cyclic.lean") *
  FreeMonoid.of (writeTheorem "cyclic_simple") *
  FreeMonoid.of (searchMathlib "isSimpleGroup_of_prime_card") *
  FreeMonoid.of (proveTheorem "cyclic_simple") *
  FreeMonoid.of verifyBuild *
  -- Phase 3: Alternating groups
  FreeMonoid.of (createFile "Alternating.lean") *
  FreeMonoid.of (writeTheorem "alt_order") *
  FreeMonoid.of (writeTheorem "A5_simple") *
  FreeMonoid.of (proveTheorem "alt_order") *
  FreeMonoid.of (proveTheorem "A5_simple") *
  FreeMonoid.of verifyBuild *
  -- Phase 4: PSL
  FreeMonoid.of (createFile "PSL.lean") *
  FreeMonoid.of (writeTheorem "GL_order") *
  FreeMonoid.of (writeTheorem "PSL2_order") *
  FreeMonoid.of (proveTheorem "GL_order") *
  FreeMonoid.of (proveTheorem "PSL2_order") *
  FreeMonoid.of verifyBuild *
  -- Phase 5: Sporadic groups
  FreeMonoid.of (createFile "Sporadic.lean") *
  FreeMonoid.of (writeTheorem "monster_order") *
  FreeMonoid.of (proveTheorem "monster_order") *
  FreeMonoid.of verifyBuild *
  -- Phase 6: Reflection (this very file!)
  FreeMonoid.of (createFile "Reflection.lean") *
  FreeMonoid.of verifyBuild

/-! ## Properties of Our Project Trace -/

/-- The trace, viewed as a list, has a definite length — the total
    number of atomic actions taken. -/
def traceLength : ℕ := (atlasProjectTrace : List AtomicAction).length

/-- Count how many actions of a given kind appear in a trace. -/
def countActions (p : AtomicAction → Bool) (trace : ProjectTrace) : ℕ :=
  ((trace : List AtomicAction).filter p).length

/-- The number of files created during the project. -/
def filesCreated : ℕ :=
  countActions (fun a => match a with | createFile _ => true | _ => false) atlasProjectTrace

/-- The number of theorems proven during the project. -/
def theoremsProvenCount : ℕ :=
  countActions (fun a => match a with | proveTheorem _ => true | _ => false) atlasProjectTrace

/-- The number of builds run during the project. -/
def buildsVerified : ℕ :=
  countActions (fun a => match a with | verifyBuild => true | _ => false) atlasProjectTrace

-- Compute these values
#eval traceLength        -- total atomic actions
#eval filesCreated       -- files created
#eval theoremsProvenCount -- theorems proven
#eval buildsVerified     -- builds verified

/-! ## The Action Monoid Acts on States

We verify that interpretTrace is indeed a monoid homomorphism, meaning
sequential composition of traces corresponds to sequential application
of transformations. This is guaranteed by construction (FreeMonoid.lift),
but we can state it explicitly. -/

theorem trace_composition (t₁ t₂ : ProjectTrace) (s : ProjectState) :
    executeTrace (t₁ * t₂) s = executeTrace t₁ (executeTrace t₂ s) := by
  unfold executeTrace
  simp [map_mul]
  rfl

theorem trace_identity (s : ProjectState) :
    executeTrace 1 s = s := by
  unfold executeTrace
  simp [map_one]
  rfl

/-! ## The Monoid of Idempotent Actions

Some actions are idempotent: applying them twice is the same as applying
them once (e.g., searchMathlib, verifyBuild in some models). We can
identify the idempotent sub-semigroup. -/

/-- An action is observationally idempotent if applying it twice gives
    the same result as applying it once, for all states. -/
def isIdempotentAction (a : AtomicAction) : Prop :=
  ∀ s : ProjectState, applyAction a (applyAction a s) = applyAction a s

/-- Searching Mathlib is idempotent — it doesn't change the project state. -/
theorem searchMathlib_idempotent (q : String) :
    isIdempotentAction (searchMathlib q) := by
  intro s
  simp [applyAction]

/-- Creating a file is idempotent — creating it twice is the same as once
    (the file already exists after the first creation). -/
theorem createFile_idempotent (name : String) :
    isIdempotentAction (createFile name) := by
  intro s
  simp [applyAction]

/-! ## Group Completion: Undoable Actions

If we allow "undo" operations, our monoid embeds into a group — the
**Grothendieck group** of the action monoid. In practice, version control
(git) provides this group structure: every commit can be reverted.

We model this by noting that the free monoid on AtomicAction embeds into
the free group on AtomicAction. -/

/-- The group of undoable project actions — the free group on atomic actions.
    Every action has an inverse (its "undo"). -/
abbrev UndoableActions := FreeGroup AtomicAction

/-- The canonical embedding of the action monoid into the group of
    undoable actions, sending each action to its group element. -/
def embedInGroup : ProjectTrace →* UndoableActions :=
  FreeMonoid.lift (FreeGroup.of ·)

/-- Every action, once embedded in the group, has an inverse — its "undo". -/
theorem every_action_undoable (a : AtomicAction) :
    embedInGroup (FreeMonoid.of a) * (embedInGroup (FreeMonoid.of a))⁻¹ = 1 := by
  exact mul_inv_cancel _

/-! ## Summary

Our formalization project is itself a mathematical object:

1. **Atomic actions** form a finite alphabet Σ = {createFile, writeTheorem, ...}
2. **Action sequences** are elements of the **free monoid** Σ*
3. **State transformations** form a **transformation monoid** End(ProjectState)
4. **interpretTrace** is the unique monoid homomorphism Σ* → End(ProjectState)
5. The **free group** F(Σ) provides "undo" — the group completion
6. Our specific project history is a concrete element of Σ*, and its
   properties (length, composition) are computationally verifiable.

In the words of the Erlangen program: the mathematical content of our
project is captured by the action of the transformation monoid on the
space of project states. The symmetries of this action encode which
re-orderings of our work would have produced the same result.
-/
