import Mathlib

/-!
# Formalizing the Science of Insecurity: A Lean 4 Proof Architecture

This file gives a *machine-checked* formalization of the central technical claims of the
Language-Theoretic Security (LangSec) program. Rather than informal prose, each "strategic
pillar" is rendered as a Lean definition or theorem and proved.

The pillars formalized here:

* **Pillar 1 — Inputs as Languages.** An input protocol is a formal language
  (`Protocol`, a `Language α = Set (List α)`).
* **Pillar 2 — Recognizers as Automata.** A finite-state recognizer (Mathlib's `DFA`,
  i.e. an FSA) reaches a *definite* Accept/Reject decision on every input
  (`recognizer_definite`). The fixed-length "ATM" protocol is a concrete Type-3 example
  (`atm`, `atm_definite`).
* **Pillar 3 — Computational equivalence.** If two endpoints (Alice, Bob) recognize the
  *same* language, no input can distinguish them (`equivalence_no_mismatch`); conversely a
  mismatch always yields an exploitable witness string (`mismatch_has_witness`).
* **The safety invariant / weird machine.** Full recognition before processing makes every
  reachable state an intended one (`gated_machine_safe`); "shotgun parsing" lets a weird
  (unintended) state become reachable (`shotgun_unsafe`).
* **Pillar 4 — Undecidability.** Any non-trivial *extensional* semantic property of
  Turing-complete programs is undecidable (Rice's theorem,
  `undecidability_of_extensional_property`); in particular the Halting Problem is
  undecidable (`halting_undecidable`). These are the formal boundaries of provable
  security: "Turing-complete protocols are inherently unfixable."
-/

open Computability

namespace LangSec

/-! ## Pillar 1: Inputs as Languages

Every input stream is a string in a formal language. We model an input *protocol* as a
formal language over an alphabet `α`, i.e. a set of finite strings. This is definitionally
Mathlib's `Language α`. -/

/-- An input *protocol*: the formal language of well-formed input strings over `α`. -/
abbrev Protocol (α : Type*) := Language α

/-! ## Pillar 2: Recognizers as Automata (the FSA)

Input-handling code must be modeled as a formal automaton that reaches a definitive
Accept/Reject state *before* any processing logic runs. The simplest, safest recognizer is
the Finite State Automaton — Mathlib's `DFA`. -/

/-- **Definite recognition.** A finite-state recognizer gives a *decidable* Accept/Reject
verdict on every input: membership in the accepted language is decidable whenever the set
of accepting states is decidable. This is the formal content of "the automaton must reach a
definitive Accept or Reject state before processing." -/
def recognizer_definite
    {α σ : Type*} (M : DFA α σ) [DecidablePred (· ∈ M.accept)] (x : List α) :
    Decidable (x ∈ M.accepts) :=
  decidable_of_iff _ (M.mem_accepts).symm

/-- The fixed-length ATM-style protocol: all strings of a fixed length `n` (e.g. the 53-byte
ATM cell). A canonical Type-3 (regular) language recognizable by an FSA with no recursion. -/
def atm (α : Type*) (n : ℕ) : Protocol α := {x | x.length = n}

/-- The ATM protocol is *definite*: membership is decidable, so an FSA can give a crisp
Accept/Reject with no ambiguity. -/
instance atm_definite (α : Type*) (n : ℕ) (x : List α) : Decidable (x ∈ atm α n) := by
  unfold atm; exact decidable_of_iff (x.length = n) Iff.rfl

/-! ## Pillar 3: Computational equivalence (Alice and Bob)

Verified design requires that all communicating endpoints agree on the interpretation of
every string. If Alice's recognizer and Bob's recognizer disagree, an attacker can exploit
the mismatch. -/

/-- **No mismatch under equivalence.** If Alice's and Bob's recognizers accept the same
language, then no input string is interpreted differently by the two endpoints. -/
theorem equivalence_no_mismatch
    {α σ τ : Type*} (A : DFA α σ) (B : DFA α τ) (h : A.accepts = B.accepts) :
    ∀ x, x ∈ A.accepts ↔ x ∈ B.accepts := by
  intro x; rw [h]

/-- **Every mismatch is exploitable.** If two recognizers do *not* accept the same language,
then there exists a concrete witness string on which they disagree — exactly the input an
attacker uses for an implementation-bypass (X.509-style) exploit. -/
theorem mismatch_has_witness
    {α σ τ : Type*} (A : DFA α σ) (B : DFA α τ) (h : A.accepts ≠ B.accepts) :
    ∃ x, ¬ (x ∈ A.accepts ↔ x ∈ B.accepts) := by
  by_contra hc
  push_neg at hc
  exact h (Set.ext hc)

/-! ## The Safety Invariant and the Weird Machine

The safety invariant: no state transition into processing occurs unless the input has been
*fully* recognized. We model a recognizer `recog`, a processing function `run`, and the
intended ("target") state space `good`. -/

/-- A state `s` is reachable in the *gated* machine if some *fully recognized* input drives
the processing function to `s`. Processing runs only after `recog` accepts the entire input. -/
def GatedReachable {α S : Type*} (recog : List α → Bool) (run : List α → S) (s : S) : Prop :=
  ∃ x, recog x = true ∧ run x = s

/-- A state `s` is reachable under *shotgun parsing* if it arises from running the processing
logic on *some* string, including ungated/partially-recognized prefixes. -/
def ShotgunReachable {α S : Type*} (run : List α → S) (s : S) : Prop :=
  ∃ x, run x = s

/-- **Safety invariant (full recognition before processing).** If the recognizer is *sound*
with respect to the intended state space — every fully accepted input lands in a `good`
state — then *every reachable state of the gated machine is a good (intended) state*. No
weird state is reachable. -/
theorem gated_machine_safe
    {α S : Type*} (recog : List α → Bool) (run : List α → S) (good : Set S)
    (hsound : ∀ x, recog x = true → run x ∈ good) :
    ∀ s, GatedReachable recog run s → s ∈ good := by
  rintro s ⟨x, hx, rfl⟩
  exact hsound x hx

/-- **Shotgun parsing reaches weird states.** Even when the recognizer is sound on the inputs
it accepts (so the gated machine is safe), running the processing logic without gating can
drive the borrowed state into an unintended ("weird") state. Concretely: a recognizer that
accepts only the empty input is sound for `good = {0}`, yet processing the non-empty prefix
`[true]` reaches the weird state `1 ∉ good`. -/
theorem shotgun_unsafe :
    ∃ (recog : List Bool → Bool) (run : List Bool → ℕ) (good : Set ℕ),
      (∀ x, recog x = true → run x ∈ good) ∧
      (∃ s, ShotgunReachable run s ∧ s ∉ good) := by
  refine ⟨fun x => x.isEmpty, fun x => if x = [] then 0 else 1, {0}, ?_, ?_⟩
  · intro x hx
    simp only [List.isEmpty_iff] at hx
    simp [hx]
  · refine ⟨1, ⟨[true], by simp⟩, ?_⟩
    simp

/-! ## Pillar 4: Undecidability — Rice's Theorem and the Halting Problem

The fundamental limits of computation bound provable security. We work with Mathlib's
Turing-complete model of programs, `Nat.Partrec.Code`, whose semantics is `eval`. -/

/-- **Rice's Theorem (extensional form).** Any *non-trivial* (`hne` : not always false,
`huniv` : not always true) and *extensional* (`hext` : depends only on input/output
behaviour `eval`, not the implementation) semantic property `C` of programs is
**undecidable**: there is no computable predicate that decides it. This is the formal reason
that automated scanning for non-trivial semantic properties cannot succeed in general. -/
theorem undecidability_of_extensional_property
    (C : Set Nat.Partrec.Code)
    (hext : ∀ cf cg,
      Nat.Partrec.Code.eval cf = Nat.Partrec.Code.eval cg → (cf ∈ C ↔ cg ∈ C))
    (hne : C ≠ ∅) (huniv : C ≠ Set.univ) :
    ¬ ComputablePred (fun c => c ∈ C) := by
  intro h
  rcases (ComputablePred.rice₂ C hext).1 h with h0 | h1
  · exact hne h0
  · exact huniv h1

/-- **The Halting Problem is undecidable.** There is no computable predicate deciding whether
a program halts on a given input `n`. Hence "Turing-complete protocols are inherently
unfixable": there is no `80/20` engineering solution for the Halting Problem. -/
theorem halting_undecidable (n : ℕ) :
    ¬ ComputablePred (fun c : Nat.Partrec.Code => (Nat.Partrec.Code.eval c n).Dom) :=
  ComputablePred.halting_problem n

end LangSec
