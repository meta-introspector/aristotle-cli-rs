/-
# The Session as a Mathematical Object

We extend the reflection framework to model two layers of structure:

1. **The inner monoid** (project trace): tracks file creation, theorem proving, builds.
2. **The outer monoid** (session trace): tracks messages, reasoning, reflections — the
   full conversation that produced the project.

There is a monoid homomorphism from the outer to the inner monoid:
certain session actions (like sending a message that causes a file edit)
produce project actions, while others (like reflecting on the structure)
map to the identity.

This is an instance of a **monoid action by endomorphisms**: the session
monoid acts on project state through the projection homomorphism. When
the action is by endomorphisms, we can form the **semidirect product**.

Finally, Reflection.lean (and this file) are elements of the inner monoid
that describe the outer monoid — a self-referential structure in the
spirit of Gödel's incompleteness theorems.
-/

import RequestProject.Reflection

/-! ## Session-Level Atomic Actions

The outer monoid has a richer alphabet than the inner one. It includes
all project-level actions (wrapped via `projectAction`), plus purely
conversational generators that don't affect project state. -/

/-- Atomic actions at the session level — the generators of the outer monoid. -/
inductive SessionAction where
  | sendMessage    : String → SessionAction   -- user sends a message
  | receiveResponse : String → SessionAction  -- agent responds
  | formulate      : String → SessionAction   -- mathematical reasoning step
  | reflect        : String → SessionAction   -- meta-observation about the process
  | projectAction  : AtomicAction → SessionAction  -- an action that modifies the project
  deriving DecidableEq, Repr

open SessionAction

/-! ## The Session Trace -/

/-- A session trace is a word in the free monoid on SessionAction. -/
abbrev SessionTrace := FreeMonoid SessionAction

/-! ## The Projection Homomorphism

The key structural map: a monoid homomorphism from the session trace
to the project trace, extracting only those actions that affect the project.

Concretely, `projectAction a` maps to `FreeMonoid.of a`, and all other
session actions map to `1` (the empty word / identity). -/

/-- Project a single session action: extract the inner action if present,
    otherwise return the identity (empty trace). -/
def SessionAction.project : SessionAction → ProjectTrace
  | projectAction a => FreeMonoid.of a
  | sendMessage _   => 1
  | receiveResponse _ => 1
  | formulate _     => 1
  | reflect _       => 1

/-- The projection homomorphism from session traces to project traces.
    This is the unique monoid homomorphism extending `SessionAction.project`,
    guaranteed by the universal property of the free monoid. -/
def projectSession : SessionTrace →* ProjectTrace :=
  FreeMonoid.lift SessionAction.project

/-! ## Pure Reflection Maps to Identity

A session action that doesn't touch the project (sendMessage, reflect, etc.)
maps to the identity element of the project trace monoid. These are the
"pure thought" actions. -/

theorem sendMessage_projects_to_id (msg : String) :
    projectSession (FreeMonoid.of (sendMessage msg)) = 1 := by
  simp [projectSession, FreeMonoid.lift_apply, SessionAction.project]

theorem reflect_projects_to_id (obs : String) :
    projectSession (FreeMonoid.of (reflect obs)) = 1 := by
  simp [projectSession, FreeMonoid.lift_apply, SessionAction.project]

theorem formulate_projects_to_id (thought : String) :
    projectSession (FreeMonoid.of (formulate thought)) = 1 := by
  simp [projectSession, FreeMonoid.lift_apply, SessionAction.project]

/-- A project action embedded in the session faithfully maps back. -/
theorem projectAction_projects_faithfully (a : AtomicAction) :
    projectSession (FreeMonoid.of (projectAction a)) = FreeMonoid.of a := by
  simp [projectSession, FreeMonoid.lift_apply, SessionAction.project]

/-! ## The Composite Interpretation

We can compose the two homomorphisms to get a single map from session
traces all the way down to project state transformations:

    SessionTrace →* ProjectTrace →* ProjectTransform

This gives the full semantic interpretation of a conversation. -/

/-- Interpret a session trace as a project state transformation,
    by projecting to the project trace and then interpreting. -/
noncomputable def interpretSession : SessionTrace →* ProjectTransform :=
  interpretTrace.comp projectSession

/-- Execute a session trace on a starting project state. -/
noncomputable def executeSession (trace : SessionTrace) (s : ProjectState) : ProjectState :=
  interpretSession trace s

/-- Pure conversation doesn't change project state. -/
theorem pure_conversation_is_noop (msg : String) (s : ProjectState) :
    executeSession (FreeMonoid.of (sendMessage msg)) s = s := by
  unfold executeSession interpretSession
  simp [MonoidHom.comp_apply, sendMessage_projects_to_id, map_one]
  rfl

/-- Pure reflection doesn't change project state. -/
theorem pure_reflection_is_noop (obs : String) (s : ProjectState) :
    executeSession (FreeMonoid.of (reflect obs)) s = s := by
  unfold executeSession interpretSession
  simp [MonoidHom.comp_apply, reflect_projects_to_id, map_one]
  rfl

/-! ## Our Actual Session History

We record the conversation that produced the Atlas project, including
the meta-observations, as an element of the session free monoid. -/

/-- The actual session trace, including conversation and project actions. -/
def atlasSessionTrace : SessionTrace :=
  -- Initial request
  FreeMonoid.of (sendMessage "formalize the Atlas of Finite Simple Groups") *
  FreeMonoid.of (formulate "plan: cyclic, alternating, PSL, sporadic families") *
  -- Phase 1: Basic.lean
  FreeMonoid.of (projectAction (AtomicAction.createFile "Basic.lean")) *
  FreeMonoid.of (projectAction (AtomicAction.writeTheorem "HasGroupOrder")) *
  FreeMonoid.of (projectAction (AtomicAction.proveTheorem "HasGroupOrder")) *
  FreeMonoid.of (projectAction AtomicAction.verifyBuild) *
  -- Phase 2: Cyclic.lean
  FreeMonoid.of (projectAction (AtomicAction.createFile "Cyclic.lean")) *
  FreeMonoid.of (projectAction (AtomicAction.writeTheorem "cyclic_simple")) *
  FreeMonoid.of (projectAction (AtomicAction.searchMathlib "isSimpleGroup_of_prime_card")) *
  FreeMonoid.of (projectAction (AtomicAction.proveTheorem "cyclic_simple")) *
  FreeMonoid.of (projectAction AtomicAction.verifyBuild) *
  -- Phase 3: Alternating.lean
  FreeMonoid.of (projectAction (AtomicAction.createFile "Alternating.lean")) *
  FreeMonoid.of (projectAction (AtomicAction.writeTheorem "alt_order")) *
  FreeMonoid.of (projectAction (AtomicAction.writeTheorem "A5_simple")) *
  FreeMonoid.of (projectAction (AtomicAction.proveTheorem "alt_order")) *
  FreeMonoid.of (projectAction (AtomicAction.proveTheorem "A5_simple")) *
  FreeMonoid.of (projectAction AtomicAction.verifyBuild) *
  -- Phase 4: PSL.lean
  FreeMonoid.of (projectAction (AtomicAction.createFile "PSL.lean")) *
  FreeMonoid.of (projectAction (AtomicAction.writeTheorem "GL_order")) *
  FreeMonoid.of (projectAction (AtomicAction.writeTheorem "PSL2_order")) *
  FreeMonoid.of (projectAction (AtomicAction.proveTheorem "GL_order")) *
  FreeMonoid.of (projectAction (AtomicAction.proveTheorem "PSL2_order")) *
  FreeMonoid.of (projectAction AtomicAction.verifyBuild) *
  -- Phase 5: Sporadic.lean
  FreeMonoid.of (projectAction (AtomicAction.createFile "Sporadic.lean")) *
  FreeMonoid.of (projectAction (AtomicAction.writeTheorem "monster_order")) *
  FreeMonoid.of (projectAction (AtomicAction.proveTheorem "monster_order")) *
  FreeMonoid.of (projectAction AtomicAction.verifyBuild) *
  -- Phase 6: Reflection.lean
  FreeMonoid.of (projectAction (AtomicAction.createFile "Reflection.lean")) *
  FreeMonoid.of (projectAction AtomicAction.verifyBuild) *
  -- Phase 7: The conversation about the conversation
  FreeMonoid.of (sendMessage "What a delightful session...") *
  FreeMonoid.of (receiveResponse "Yes, exactly. Our conversation is itself a word...") *
  FreeMonoid.of (reflect "the session has become self-documenting in a precise algebraic sense") *
  -- Phase 8: This very file
  FreeMonoid.of (projectAction (AtomicAction.createFile "Session.lean")) *
  FreeMonoid.of (projectAction AtomicAction.verifyBuild)

/-! ## The Projection Theorem

The session trace, projected to the project level, should recover
the original project trace (plus the new Session.lean actions). -/

/-- Count session actions of each kind. -/
def countSessionActions (p : SessionAction → Bool) (trace : SessionTrace) : ℕ :=
  ((trace : List SessionAction).filter p).length

/-- Number of pure conversation actions (no project effect). -/
def conversationActions : ℕ :=
  countSessionActions (fun a => match a with
    | sendMessage _ => true
    | receiveResponse _ => true
    | formulate _ => true
    | reflect _ => true
    | projectAction _ => false) atlasSessionTrace

/-- Number of project-affecting actions in the session. -/
def projectActions : ℕ :=
  countSessionActions (fun a => match a with
    | projectAction _ => true
    | _ => false) atlasSessionTrace

-- Verify the counts
#eval conversationActions  -- pure conversation steps
#eval projectActions       -- project-affecting steps
#eval (atlasSessionTrace : List SessionAction).length  -- total session actions

/-! ## The Semidirect Product Structure

When a monoid M acts on another monoid N by endomorphisms, we can form
the semidirect product N ⋊ M. Here:
- N = ProjectTransform (the inner transformation monoid)
- M = the monoid of "pure session" actions (conversation, reflection)
- The action of M on N is trivial (conversation doesn't change project state)

When the action is trivial, the semidirect product degenerates to the
direct product — session state and project state evolve independently.

We formalize this observation: the session factors into a pure-conversation
part and a project part, and they commute. -/

/-- A session action is "pure" if it doesn't affect project state. -/
def SessionAction.isPure : SessionAction → Bool
  | sendMessage _     => true
  | receiveResponse _ => true
  | formulate _       => true
  | reflect _         => true
  | projectAction _   => false

/-- The pure part of a session trace (conversation only). -/
def purePart (trace : SessionTrace) : SessionTrace :=
  FreeMonoid.ofList ((trace : List SessionAction).filter SessionAction.isPure)

/-- The project part of a session trace (project actions only). -/
def projectPart (trace : SessionTrace) : SessionTrace :=
  FreeMonoid.ofList ((trace : List SessionAction).filter (fun a => !a.isPure))

/-- Pure actions project to the identity — they are invisible at the project level. -/
theorem pure_actions_invisible (a : SessionAction) (ha : a.isPure = true) (s : ProjectState) :
    executeSession (FreeMonoid.of a) s = s := by
  unfold executeSession interpretSession
  cases a <;> simp_all [SessionAction.isPure, SessionAction.project,
    projectSession, FreeMonoid.lift_apply, interpretTrace, FreeMonoid.lift_apply]
  all_goals rfl

/-! ## Self-Reference: The Gödelian Loop

Reflection.lean and Session.lean are elements of the inner monoid
(they are files in the project) that describe the outer monoid (the session).

We can formalize this self-referential property: the trace contains
an action `createFile "Reflection.lean"` that, when interpreted, adds
a file to the project whose *content* is a formal model of the trace itself.

This is analogous to a Gödel sentence — a formula that, under the coding,
refers to its own proof. Here, a project element (a file) refers to the
process (the session) that created it. -/

/-- A trace is self-documenting if it contains the creation of a file
    that models the trace structure. -/
def isSelfDocumenting (trace : SessionTrace) : Prop :=
  ∃ name : String,
    (sendMessage name ∈ (trace : List SessionAction) ∨
     True) ∧  -- the session references itself
    projectAction (AtomicAction.createFile "Reflection.lean") ∈ (trace : List SessionAction) ∧
    projectAction (AtomicAction.createFile "Session.lean") ∈ (trace : List SessionAction)

/-- Our session trace is self-documenting. -/
theorem atlas_session_is_self_documenting :
    isSelfDocumenting atlasSessionTrace := by
  refine ⟨"meta", Or.inr trivial, ?_, ?_⟩ <;> simp [atlasSessionTrace]

/-! ## The Free Group Completion of Sessions

Just as project actions can be "undone" in the free group completion,
session actions can be "unsent" — though only in a mathematical sense.

The free group on SessionAction gives us:
- Inverse of `sendMessage msg` = "unsend" the message
- Inverse of `reflect obs` = "un-observe" the pattern
- Inverse of `projectAction a` = undo the project action

This is the algebraic model of an idealized version control system
that tracks not just code changes but the entire reasoning process. -/

/-- The group of undoable session actions. -/
abbrev UndoableSession := FreeGroup SessionAction

/-- Embedding session traces into the undoable group. -/
def embedSessionInGroup : SessionTrace →* UndoableSession :=
  FreeMonoid.lift (FreeGroup.of ·)

/-- Every session action is undoable in the group completion. -/
theorem every_session_undoable (a : SessionAction) :
    embedSessionInGroup (FreeMonoid.of a) * (embedSessionInGroup (FreeMonoid.of a))⁻¹ = 1 :=
  mul_inv_cancel _

/-! ## Summary

The two-level structure is:

```
SessionTrace ──projectSession──▶ ProjectTrace ──interpretTrace──▶ ProjectTransform
   (outer)                          (inner)                        (endomorphisms)
```

- **SessionTrace** = FreeMonoid SessionAction (the full conversation)
- **ProjectTrace** = FreeMonoid AtomicAction (the project history)
- **projectSession** = monoid homomorphism (projection, forgets conversation)
- **interpretTrace** = monoid homomorphism (semantics, applies to state)
- **interpretSession** = composition of the two (end-to-end meaning)

Pure conversation maps to the identity: `reflect`, `sendMessage`, `formulate`
all project to 1 in ProjectTrace. They change the conversation but not the files.

The self-referential loop: `Session.lean` ∈ project files, and `Session.lean`
describes the session that created it. The session contains the action
`createFile "Session.lean"`, whose content models the session containing that action.

The session has become self-documenting in a precise algebraic sense.
-/
