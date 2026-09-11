/-
# Prove2me §6 — proof submissions and the two structural refusals

A submission is an authored attempt against one theorem address.  The
source specification lists refusals in prose ("MUST reject if it imports
the target theorem itself", "MUST reject placeholders such as `sorry`
unless the artifact represents a sketch").  Both are decidable checks on
data a peer already holds, so here they are `Bool` functions with an
`iff` characterisation — the discipline used elsewhere in this project
for anything a client must be able to decide offline.

Proved here:

* `admissible_iff` — the single `Bool` gate spelled out as exactly six
  conditions, so nothing is hidden inside it;
* `admissible_no_self_import` — an admissible submission never imports
  its own target, so a proof cannot be "by the theorem itself";
* `proof_placeholder_free` — an admissible submission that is *not*
  flagged as a sketch contains neither `sorry` nor `admit`;
* `sketch_is_not_a_proof` — a sketch is admissible as an artifact and
  still refused as a proof, which is the distinction the source
  specification asks for but does not make;
* `admissible_targets` / `admissible_environment` — an admissible
  submission names its target and its environment;
* `subId_determines` — the submission address determines the source
  text, the target, the declared imports, the kind and the environment.

`Disproof` is given a statement-level meaning here, as the review of the
specification asked: a disproof is a submission whose *target* is the
negation theorem, so it is checked exactly like any other proof rather
than being a special status word.  `Reduction` is the only kind that can
resolve a parent through children (`Kant.Prove2me.Graph`).
-/
import RequestProject.Kant.Prove2me.Statement

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Prove2me

open Kant Kant.Bytes Kant.Text

/-! ## Submission kinds -/

/-- What a submission claims to do. -/
inductive SubKind where
  /-- A proof of the target statement. -/
  | direct
  /-- A proof of the target, where the target is itself a negation.  The
  check performed is the same; the label is for display. -/
  | disproof
  /-- A reduction: a proof of the target from named child theorems. -/
  | reduction
deriving DecidableEq, Repr

/-- Wire code of a submission kind. -/
def SubKind.code : SubKind → Nat
  | .direct => 1
  | .disproof => 2
  | .reduction => 3

/-- Read a submission kind back. -/
def SubKind.ofCode : Nat → Option SubKind
  | 1 => some .direct
  | 2 => some .disproof
  | 3 => some .reduction
  | _ => none

@[simp] theorem SubKind.ofCode_code (k : SubKind) : SubKind.ofCode k.code = some k := by
  cases k <;> rfl

theorem SubKind.code_inj {a b : SubKind} (h : a.code = b.code) : a = b := by
  have hr := SubKind.ofCode_code a
  rw [h, SubKind.ofCode_code b] at hr
  exact (Option.some.inj hr).symm

/-! ## Submissions -/

/-- A proof submission. -/
structure Sub where
  /-- The address of the theorem this attempts. -/
  target : Cid
  /-- The proof source text, exactly as it will be compiled. -/
  source : Str
  /-- The modules the source imports. -/
  declaredImports : List Str
  /-- What the submission claims to be. -/
  kind : SubKind
  /-- The environment the author checked it in. -/
  environment : Cid
  /-- Whether the artifact is explicitly a sketch rather than a proof. -/
  isSketch : Bool
  /-- Prose.  Not part of the submission's identity. -/
  explanation : Str
deriving DecidableEq, Repr

/-- A submission is transmissible when its committed text is printable. -/
structure Sub.Wire (s : Sub) : Prop where
  /-- The target address is printable. -/
  target : IsAscii s.target
  /-- The source is printable. -/
  source : IsAscii s.source
  /-- Every declared import is printable. -/
  declaredImports : ∀ i ∈ s.declaredImports, IsAscii i
  /-- The environment address is printable. -/
  environment : IsAscii s.environment

/-- A boolean field, as one printable character. -/
def boolField (b : Bool) : Str := if b then ['1'] else ['0']

theorem isAscii_boolField (b : Bool) : IsAscii (boolField b) := by
  cases b <;> intro c hc <;> simp [boolField] at hc <;> subst hc <;> decide

theorem boolField_inj {a b : Bool} (h : boolField a = boolField b) : a = b := by
  cases a <;> cases b <;> simp_all [boolField]

/-- The content of a submission.  The explanation is *not* included: two
identical proofs with different commentary are one artifact. -/
def Sub.content (s : Sub) : Content :=
  ⟨.submission,
    [s.target, s.source, packText s.declaredImports, natField s.kind.code,
      s.environment, boolField s.isSketch]⟩

theorem Sub.content_wire {s : Sub} (h : s.Wire) : s.content.Wire := by
  intro f hf
  simp only [Sub.content, List.mem_cons] at hf
  rcases hf with rfl | rfl | rfl | rfl | rfl | hf
  · exact h.target
  · exact h.source
  · exact isAscii_packText _
  · exact isAscii_natField _
  · exact h.environment
  · rcases hf with rfl | hf
    · exact isAscii_boolField _
    · cases hf

/-- The address of a submission. -/
def subId (A : Addressing) (s : Sub) : Cid := idOf A s.content

theorem Sub.content_inj {s s' : Sub} (h : s.Wire) (h' : s'.Wire)
    (heq : s.content = s'.content) :
    s.target = s'.target ∧ s.source = s'.source ∧
      s.declaredImports = s'.declaredImports ∧ s.kind = s'.kind ∧
      s.environment = s'.environment ∧ s.isSketch = s'.isSketch := by
  simp only [Sub.content, Content.mk.injEq, List.cons.injEq, and_true] at heq
  obtain ⟨_, ht, hs, hi, hk, he, hb⟩ := heq
  exact ⟨ht, hs, packText_inj h.declaredImports h'.declaredImports hi,
    SubKind.code_inj (natField_inj hk), he, boolField_inj hb⟩

/-- **The submission address determines the submission**: the exact
source that was checked, against which target, with which imports, in
which environment. -/
theorem subId_determines (A : Addressing) {s s' : Sub} (h : s.Wire) (h' : s'.Wire)
    (heq : subId A s = subId A s') :
    s.target = s'.target ∧ s.source = s'.source ∧
      s.declaredImports = s'.declaredImports ∧ s.kind = s'.kind ∧
      s.environment = s'.environment ∧ s.isSketch = s'.isSketch :=
  Sub.content_inj h h' (idOf_inj A (Sub.content_wire h) (Sub.content_wire h') heq)

/-! ## The structural refusals -/

/-- The module name under which a published theorem is importable. -/
def moduleOf (c : Cid) : Str := "Prove2me.".toList ++ c

theorem moduleOf_inj {a b : Cid} (h : moduleOf a = moduleOf b) : a = b := by
  simpa [moduleOf] using h

/-- Does the submission import the very theorem it claims to prove? -/
def importsTarget (s : Sub) : Bool := s.declaredImports.contains (moduleOf s.target)

/-- Does the source contain a proof placeholder? -/
def hasPlaceholder (src : Str) : Bool :=
  containsSub "sorry".toList src || containsSub "admit".toList src

/-- Does the source declare the required top-level `solution`? -/
def hasSolutionDecl (src : Str) : Bool := containsSub "theorem solution".toList src

/-- Are all declared imports permitted by the environment? -/
def importsAllowed (e : Env) (s : Sub) : Bool :=
  s.declaredImports.all (fun i => e.allowedImports.contains i)

/-- **The local admissibility gate.**  Everything a peer can decide about
a submission without compiling anything and without asking anybody. -/
def admissibleB (tid envCid : Cid) (e : Env) (s : Sub) : Bool :=
  (s.target == tid) && (s.environment == envCid) && !importsTarget s &&
    (s.isSketch || !hasPlaceholder s.source) && hasSolutionDecl s.source &&
    importsAllowed e s

theorem importsTarget_false_iff {s : Sub} :
    importsTarget s = false ↔ moduleOf s.target ∉ s.declaredImports := by
  simp [importsTarget]

theorem importsAllowed_iff {e : Env} {s : Sub} :
    importsAllowed e s = true ↔ ∀ i ∈ s.declaredImports, i ∈ e.allowedImports := by
  simp [importsAllowed]

theorem hasSolutionDecl_iff {src : Str} :
    hasSolutionDecl src = true ↔ "theorem solution".toList <:+: src :=
  containsSub_iff_infix _ _

theorem hasPlaceholder_false_iff {src : Str} :
    hasPlaceholder src = false ↔
      (¬ "sorry".toList <:+: src ∧ ¬ "admit".toList <:+: src) := by
  simp only [hasPlaceholder, Bool.or_eq_false_iff, ← containsSub_iff_infix, Bool.not_eq_true]

/-- The gate, spelled out. -/
theorem admissible_iff {tid envCid : Cid} {e : Env} {s : Sub} :
    admissibleB tid envCid e s = true ↔
      (s.target = tid ∧ s.environment = envCid ∧
        moduleOf s.target ∉ s.declaredImports ∧
        (s.isSketch = true ∨
          (¬ "sorry".toList <:+: s.source ∧ ¬ "admit".toList <:+: s.source)) ∧
        "theorem solution".toList <:+: s.source ∧
        ∀ i ∈ s.declaredImports, i ∈ e.allowedImports) := by
  simp only [admissibleB, Bool.and_eq_true, beq_iff_eq, Bool.or_eq_true, Bool.not_eq_true',
    importsTarget_false_iff, importsAllowed_iff, hasSolutionDecl_iff,
    hasPlaceholder_false_iff]
  tauto

/-- **No self-reference.**  An admissible submission does not import the
theorem it claims to prove. -/
theorem admissible_no_self_import {tid envCid : Cid} {e : Env} {s : Sub}
    (h : admissibleB tid envCid e s = true) : moduleOf s.target ∉ s.declaredImports :=
  (admissible_iff.mp h).2.2.1

/-- An admissible submission names the target it was checked against. -/
theorem admissible_targets {tid envCid : Cid} {e : Env} {s : Sub}
    (h : admissibleB tid envCid e s = true) : s.target = tid :=
  (admissible_iff.mp h).1

/-- An admissible submission names the environment it was checked in. -/
theorem admissible_environment {tid envCid : Cid} {e : Env} {s : Sub}
    (h : admissibleB tid envCid e s = true) : s.environment = envCid :=
  (admissible_iff.mp h).2.1

/-- **A proof has no holes.**  An admissible submission that does not
declare itself a sketch contains no `sorry` and no `admit`. -/
theorem proof_placeholder_free {tid envCid : Cid} {e : Env} {s : Sub}
    (h : admissibleB tid envCid e s = true) (hs : s.isSketch = false) :
    ¬ "sorry".toList <:+: s.source ∧ ¬ "admit".toList <:+: s.source := by
  rcases (admissible_iff.mp h).2.2.2.1 with h' | h'
  · rw [hs] at h'
    exact absurd h' (by simp)
  · exact h'

/-- An admissible submission uses only imports the environment permits. -/
theorem admissible_imports_allowed {tid envCid : Cid} {e : Env} {s : Sub}
    (h : admissibleB tid envCid e s = true) :
    ∀ i ∈ s.declaredImports, i ∈ e.allowedImports :=
  (admissible_iff.mp h).2.2.2.2.2

/-- A submission whose source is a hole, published honestly as a sketch,
is an admissible *artifact*. -/
theorem sketch_admissible {tid envCid : Cid} {e : Env} {s : Sub}
    (hs : s.isSketch = true) (ht : s.target = tid) (he : s.environment = envCid)
    (hself : moduleOf s.target ∉ s.declaredImports)
    (hsol : "theorem solution".toList <:+: s.source)
    (himp : ∀ i ∈ s.declaredImports, i ∈ e.allowedImports) :
    admissibleB tid envCid e s = true :=
  admissible_iff.mpr ⟨ht, he, hself, Or.inl hs, hsol, himp⟩

/-- The proof gate: what a submission must satisfy before a verification
result about it can be *accepted* as a proof.  A sketch never passes it,
however admissible it is as an artifact. -/
def proofCandidateB (tid envCid : Cid) (e : Env) (s : Sub) : Bool :=
  admissibleB tid envCid e s && !s.isSketch

/-- **A sketch is not a proof.** -/
theorem sketch_is_not_a_proof {tid envCid : Cid} {e : Env} {s : Sub}
    (hs : s.isSketch = true) : proofCandidateB tid envCid e s = false := by
  simp [proofCandidateB, hs]

/-- A proof candidate is admissible, has no holes, and names its target
and environment. -/
theorem proofCandidate_sound {tid envCid : Cid} {e : Env} {s : Sub}
    (h : proofCandidateB tid envCid e s = true) :
    s.target = tid ∧ s.environment = envCid ∧
      moduleOf s.target ∉ s.declaredImports ∧
      ¬ "sorry".toList <:+: s.source ∧ ¬ "admit".toList <:+: s.source := by
  simp only [proofCandidateB, Bool.and_eq_true, Bool.not_eq_true'] at h
  obtain ⟨ha, hs⟩ := h
  obtain ⟨hfree1, hfree2⟩ := proof_placeholder_free ha hs
  exact ⟨admissible_targets ha, admissible_environment ha, admissible_no_self_import ha,
    hfree1, hfree2⟩

end Kant.Prove2me
