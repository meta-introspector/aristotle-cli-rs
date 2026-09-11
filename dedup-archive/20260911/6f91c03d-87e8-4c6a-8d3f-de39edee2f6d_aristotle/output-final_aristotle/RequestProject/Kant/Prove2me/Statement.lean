/-
# Prove2me §5 — the theorem artifact, and what its identity commits to

A theorem artifact must pin down *exactly what is to be proved*.  The
source specification lists title, description, tags and mission
membership alongside the statement; this module separates them.

The identity of a theorem commits to four things and only four:

* the exact formal statement text,
* the imports it is stated against,
* the addresses of the definitions it refers to,
* the address of the environment manifest (toolchain, library revisions,
  flags, limits).

Proved here:

* `theoremId_ignores_prose` — renaming a theorem, retitling it,
  rewriting its documentation, retagging it or moving it between
  missions does not change its address;
* `theoremId_determines_core` — conversely, the address determines all
  four committed fields, so two peers that agree on an address agree on
  what is to be proved;
* `statement_differs_id_differs`, `imports_differs_id_differs`,
  `definitions_differs_id_differs`, `environment_differs_id_differs` —
  each of the four really is committed to: change it and you have a
  different theorem.

All four conditional on an `Addressing`, which by
`no_addressing_is_witness` this project cannot supply.
-/
import RequestProject.Kant.Prove2me.Artifact

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Prove2me

open Kant Kant.Bytes Kant.Text

/-! ## Environment manifests -/

/-- The pinned environment a proof is checked in.  A verification result
is authoritative only relative to one of these. -/
structure Env where
  /-- Lean toolchain version. -/
  leanVersion : Str
  /-- Mathlib revision. -/
  mathlibRev : Str
  /-- Platform theorem-library revision. -/
  platformRev : Str
  /-- Container or operating-system image. -/
  image : Str
  /-- Build flags in effect. -/
  flags : List Str
  /-- The imports a submission is permitted to use. -/
  allowedImports : List Str
  /-- Wall-clock limit, in seconds. -/
  timeLimit : Nat
  /-- Memory limit, in mebibytes. -/
  memoryLimit : Nat
deriving DecidableEq, Repr

/-- An environment is transmissible when its text is printable. -/
structure Env.Wire (e : Env) : Prop where
  /-- The toolchain version is printable. -/
  leanVersion : IsAscii e.leanVersion
  /-- The Mathlib revision is printable. -/
  mathlibRev : IsAscii e.mathlibRev
  /-- The platform revision is printable. -/
  platformRev : IsAscii e.platformRev
  /-- The image reference is printable. -/
  image : IsAscii e.image
  /-- Every flag is printable. -/
  flags : ∀ f ∈ e.flags, IsAscii f
  /-- Every allowed import is printable. -/
  allowedImports : ∀ i ∈ e.allowedImports, IsAscii i

/-- A numeric field, rendered as hex of its big-endian bytes so that it
has exactly one printable form. -/
def natField (n : Nat) : Str := hexEncode (natToBytesBE n)

theorem isAscii_natField (n : Nat) : IsAscii (natField n) := isAscii_hexEncode _

theorem natField_inj {n m : Nat} (h : natField n = natField m) : n = m := by
  have hd := hexDecode_hexEncode (natToBytesBE n)
  rw [show hexEncode (natToBytesBE n) = hexEncode (natToBytesBE m) from h,
    hexDecode_hexEncode] at hd
  have : natToBytesBE m = natToBytesBE n := Option.some.inj hd
  have hnm := congrArg bytesBEToNat this
  rw [bytesBEToNat_natToBytesBE, bytesBEToNat_natToBytesBE] at hnm
  exact hnm.symm

/-- The content of an environment manifest. -/
def Env.content (e : Env) : Content :=
  ⟨.environment,
    [e.leanVersion, e.mathlibRev, e.platformRev, e.image,
      packText e.flags, packText e.allowedImports,
      natField e.timeLimit, natField e.memoryLimit]⟩

theorem Env.content_wire {e : Env} (h : e.Wire) : e.content.Wire := by
  intro f hf
  simp only [Env.content, List.mem_cons] at hf
  rcases hf with rfl | rfl | rfl | rfl | rfl | rfl | rfl | hf
  · exact h.leanVersion
  · exact h.mathlibRev
  · exact h.platformRev
  · exact h.image
  · exact isAscii_packText _
  · exact isAscii_packText _
  · exact isAscii_natField _
  · rcases hf with rfl | hf
    · exact isAscii_natField _
    · cases hf

/-- The canonical fields of an environment determine it. -/
theorem Env.content_inj {e e' : Env} (h : e.Wire) (h' : e'.Wire)
    (heq : e.content = e'.content) : e = e' := by
  cases e with
  | mk l m p i f a tl ml =>
    cases e' with
    | mk l' m' p' i' f' a' tl' ml' =>
      simp only [Env.content, Content.mk.injEq, List.cons.injEq, and_true] at heq
      obtain ⟨_, hl, hm, hp, hi, hf, ha, htl, hml⟩ := heq
      have hf' : f = f' := packText_inj h.flags h'.flags hf
      have ha' : a = a' := packText_inj h.allowedImports h'.allowedImports ha
      have htl' : tl = tl' := natField_inj htl
      have hml' : ml = ml' := natField_inj hml
      simp_all

/-- The address of an environment. -/
def envId (A : Addressing) (e : Env) : Cid := idOf A e.content

/-- **The environment address determines the environment**: toolchain,
library revisions, image, flags, allowed imports and limits. -/
theorem envId_determines (A : Addressing) {e e' : Env} (h : e.Wire) (h' : e'.Wire)
    (heq : envId A e = envId A e') : e = e' :=
  Env.content_inj h h' (idOf_inj A (Env.content_wire h) (Env.content_wire h') heq)

/-! ## The committed core of a theorem -/

/-- Everything a theorem's identity commits to. -/
structure Core where
  /-- The exact formal statement, as source text. -/
  statement : Str
  /-- The imports the statement is made against. -/
  imports : List Str
  /-- The definitions the statement refers to, by address. -/
  definitions : List Cid
  /-- The environment manifest, by address. -/
  environment : Cid
deriving DecidableEq, Repr

/-- A core is transmissible when its text is printable. -/
structure Core.Wire (c : Core) : Prop where
  /-- The statement is printable. -/
  statement : IsAscii c.statement
  /-- Every import is printable. -/
  imports : ∀ i ∈ c.imports, IsAscii i
  /-- Every definition address is printable. -/
  definitions : ∀ d ∈ c.definitions, IsAscii d
  /-- The environment address is printable. -/
  environment : IsAscii c.environment

/-- A theorem artifact: the committed core, plus prose that is *not*
part of its identity. -/
structure Thm where
  /-- What is to be proved. -/
  core : Core
  /-- A human-readable name.  Not committed to. -/
  name : Str
  /-- A title.  Not committed to. -/
  title : Str
  /-- Documentation.  Not committed to. -/
  documentation : Str
  /-- Tags.  Not committed to. -/
  tags : List Str
deriving DecidableEq, Repr

/-- The content of a theorem artifact: the core, and nothing else. -/
def Core.content (c : Core) : Content :=
  ⟨.thm, [c.statement, packText c.imports, packText c.definitions, c.environment]⟩

theorem Core.content_wire {c : Core} (h : c.Wire) : c.content.Wire := by
  intro f hf
  simp only [Core.content, List.mem_cons] at hf
  rcases hf with rfl | rfl | rfl | hf
  · exact h.statement
  · exact isAscii_packText _
  · exact isAscii_packText _
  · rcases hf with rfl | hf
    · exact h.environment
    · cases hf

/-- The address of a theorem. -/
def theoremId (A : Addressing) (t : Thm) : Cid := idOf A t.core.content

/-! ## What identity does and does not depend on -/

/-- **Prose is not identity.**  Two theorem artifacts with the same core
have the same address, whatever their name, title, documentation or
tags — and, since mission membership lives in a mission artifact rather
than here, whatever collections they belong to. -/
theorem theoremId_ignores_prose (A : Addressing) {t t' : Thm} (h : t.core = t'.core) :
    theoremId A t = theoremId A t' := by
  unfold theoremId
  rw [h]

/-- Worked form of the same statement: retitling in place. -/
theorem theoremId_retitle (A : Addressing) (t : Thm) (name title doc : Str)
    (tags : List Str) :
    theoremId A { t with name := name, title := title, documentation := doc, tags := tags }
      = theoremId A t := rfl

/-- The canonical core fields determine the core. -/
theorem Core.content_inj {c c' : Core} (h : c.Wire) (h' : c'.Wire)
    (heq : c.content = c'.content) : c = c' := by
  cases c with
  | mk s i d e =>
    cases c' with
    | mk s' i' d' e' =>
      simp only [Core.content, Content.mk.injEq, List.cons.injEq, and_true] at heq
      obtain ⟨_, hs, hi, hd, he⟩ := heq
      have hi' : i = i' := packText_inj h.imports h'.imports hi
      have hd' : d = d' := packText_inj h.definitions h'.definitions hd
      simp_all

/-- **The address determines what is to be proved.**  Two peers holding
the same theorem address agree on the statement text, the imports, the
definitions and the environment. -/
theorem theoremId_determines_core (A : Addressing) {t t' : Thm}
    (h : t.core.Wire) (h' : t'.core.Wire) (heq : theoremId A t = theoremId A t') :
    t.core = t'.core :=
  Core.content_inj h h' (idOf_inj A (Core.content_wire h) (Core.content_wire h') heq)

/-- Changing the statement changes the theorem. -/
theorem statement_differs_id_differs (A : Addressing) {t t' : Thm}
    (h : t.core.Wire) (h' : t'.core.Wire) (hne : t.core.statement ≠ t'.core.statement) :
    theoremId A t ≠ theoremId A t' := by
  intro heq
  exact hne (congrArg Core.statement (theoremId_determines_core A h h' heq))

/-- Changing the imports changes the theorem. -/
theorem imports_differs_id_differs (A : Addressing) {t t' : Thm}
    (h : t.core.Wire) (h' : t'.core.Wire) (hne : t.core.imports ≠ t'.core.imports) :
    theoremId A t ≠ theoremId A t' := by
  intro heq
  exact hne (congrArg Core.imports (theoremId_determines_core A h h' heq))

/-- Changing the referenced definitions changes the theorem. -/
theorem definitions_differs_id_differs (A : Addressing) {t t' : Thm}
    (h : t.core.Wire) (h' : t'.core.Wire) (hne : t.core.definitions ≠ t'.core.definitions) :
    theoremId A t ≠ theoremId A t' := by
  intro heq
  exact hne (congrArg Core.definitions (theoremId_determines_core A h h' heq))

/-- **Changing the environment changes the theorem.**  A statement
checked against a different Mathlib is a different target, and the
address says so. -/
theorem environment_differs_id_differs (A : Addressing) {t t' : Thm}
    (h : t.core.Wire) (h' : t'.core.Wire) (hne : t.core.environment ≠ t'.core.environment) :
    theoremId A t ≠ theoremId A t' := by
  intro heq
  exact hne (congrArg Core.environment (theoremId_determines_core A h h' heq))

/-- A corrected theorem is a *new* artifact with an explicit successor
link, never an edit of the old one.  This is the `predecessors` field of
the announcement, used here at the point where the specification says
"corrections should create a new object". -/
def supersede (A : Addressing) (old : Thm) (new : Thm) (author : Key) (t : Nat) : Claim :=
  announce A new.core.content author t [] [theoremId A old]

/-- Superseding does not touch the old artifact: its address is still the
address of the old core. -/
theorem supersede_keeps_old (A : Addressing) (old new : Thm) (author : Key) (t : Nat) :
    (supersede A old new author t).predecessors = [theoremId A old] := rfl

/-- And the successor announces the new core, not the old one. -/
theorem supersede_announces_new (A : Addressing) (old new : Thm) (author : Key) (t : Nat) :
    (supersede A old new author t).content = theoremId A new := rfl

end Kant.Prove2me
